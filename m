Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaJYVML (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 17:12:11 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:34961 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaJYVMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 17:12:09 -0400
MIME-Version: 1.0
In-Reply-To: <544B0D22.2070509@zytor.com>
References: <CALCETrUmA+5499fEqp7S-nfSBVxTEo76mA9r32zYQ41E3c+YhQ@mail.gmail.com>
 <544B0D22.2070509@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 24 Oct 2014 21:42:35 -0700
Message-ID: <CALCETrW+VYimgKLep6aCyLUAvAkmc4YMnZ9v4zk1Tn7W69z4sw@mail.gmail.com>
Subject: Re: vmalloced stacks on x86_64?
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 24, 2014 7:38 PM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 10/24/2014 05:22 PM, Andy Lutomirski wrote:
> > Is there any good reason not to use vmalloc for x86_64 stacks?
>
> Additional TLB pressure if anything else.

I wonder how much this matters.  It certainly helps on context
switches if the new stack is in the same TLB entry.  But, for entries
that use less than one page of stack, I can imagine this making almost
no difference.

>
> Now, on the flipside: what is the *benefit*?

Immediate exception on overflow, and no high order allocation issues.
The former is a nice mitigation against exploits based on overflowing
the stack.

--Andy

>
>         -hpa
>
