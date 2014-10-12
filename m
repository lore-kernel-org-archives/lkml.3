Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaJLQxk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 12:53:40 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:55502 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaJLQxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 12:53:36 -0400
Date: Sun, 12 Oct 2014 11:53:32 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Clean up stack access code in irq_32.c
Message-ID: <20141012115332.5ec3db90@as>
In-Reply-To: <17ED2609-CA12-4842-8ECE-A1F08693FC01@zytor.com>
References: <20141012114353.4aa73c00@as>
	<17ED2609-CA12-4842-8ECE-A1F08693FC01@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2014 09:47:53 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

[replying to the list this time, sigh]

> We changed this to asm because the C broke some compilers.  Why are you changing it back?
> 

The C broke some compilers because it was using a global register
variable. This is a local one, which the clang documentation says is
supported. And I compiled it with clang with no problem.

> On October 12, 2014 9:43:53 AM PDT, Chuck Ebbert <cebbert.lkml@gmail.com> wrote:
> >Use C instead of asm for accessing the stack pointer. And define some
> >macros to make the code easier to understand.
> >
