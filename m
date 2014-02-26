Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaBZDAe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 22:00:34 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50354 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaBZDAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 22:00:33 -0500
Message-ID: <530D58CD.4080202@mit.edu>
Date: Tue, 25 Feb 2014 19:00:29 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, behanw@converseincode.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, oleg@redhat.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: LLVMLinux: Reimplement current_stack_pointer without
 register usage.
References: <1392957882-24105-1-git-send-email-behanw@converseincode.com> <5306DC49.4060603@zytor.com>
In-Reply-To: <5306DC49.4060603@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 08:55 PM, H. Peter Anvin wrote:
> This seems like really deep magic when looking at it... at the very
> least, this needs to be very carefully commented, including why it works
> on the various platforms.
> 
> How much does this actually affect the output?  I only see three uses of
> current_stack_pointer:
> 
> /* how to get the thread information struct from C */
> static inline struct thread_info *current_thread_info(void)
> {
>         return (struct thread_info *)
>                 (current_stack_pointer & ~(THREAD_SIZE - 1));
> }
> 
> ... here we need the mov anyway, because we have to then AND it with a
> mask, which we obviously can't do inside the stack pointer.

No clue what code is actually generated, but the new code could generate:

mov $MASK, %rax;
and %esp, %rax;

Admittedly, I can't see any reason why this would be an improvement.

--Andy
