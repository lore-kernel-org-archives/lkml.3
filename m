Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaJLTe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 15:34:29 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:36575 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaJLTe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 15:34:28 -0400
Date: Sun, 12 Oct 2014 14:34:22 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Clean up stack access code in irq_32.c
Message-ID: <20141012143422.5b9bb40e@as>
In-Reply-To: <EF2BF2D8-F612-4812-AF96-05944AE0200C@zytor.com>
References: <20141012114353.4aa73c00@as>
	<17ED2609-CA12-4842-8ECE-A1F08693FC01@zytor.com>
	<20141012115332.5ec3db90@as>
	<EF2BF2D8-F612-4812-AF96-05944AE0200C@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2014 10:13:33 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> That's not a justification for change.  Claiming no harm is nevessary but not sufficient.
> 

The optimization is also a little better with GCC when using C
instead of asm for current_stack_pointer. Probably not enough better
to do different macros for gcc and other compilers though.

clang actually moves %esp to memory and then into another register
instead of moving it directly when using the current macro. Their
optimizer really needs some work...

> On October 12, 2014 9:53:32 AM PDT, Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
> >On Sun, 12 Oct 2014 09:47:53 -0700
> >"H. Peter Anvin" <hpa@zytor.com> wrote:
> >
> >[replying to the list this time, sigh]
> >
> >> We changed this to asm because the C broke some compilers.  Why are
> >you changing it back?
> >> 
> >
> >The C broke some compilers because it was using a global register
> >variable. This is a local one, which the clang documentation says is
> >supported. And I compiled it with clang with no problem.
> >
> >> On October 12, 2014 9:43:53 AM PDT, Chuck Ebbert
> ><cebbert.lkml@gmail.com> wrote:
> >> >Use C instead of asm for accessing the stack pointer. And define
> >some
> >> >macros to make the code easier to understand.
> >> >
> 

