Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbaI2Tdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:33:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:53731 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaI2Tda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:33:30 -0400
Date: Mon, 29 Sep 2014 21:33:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Lackner <sebastian@fds-team.de>
cc: Andy Lutomirski <luto@amacapital.net>, Anish Bhatt <anish@chelsio.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
In-Reply-To: <5429A556.50507@fds-team.de>
Message-ID: <alpine.DEB.2.02.1409292059530.22082@ionos.tec.linutronix.de>
References: <1411674171-24442-1-git-send-email-anish@chelsio.com> <54299979.6080705@amacapital.net> <5429A556.50507@fds-team.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014, Sebastian Lackner wrote:
> On 29.09.2014 19:40, Andy Lutomirski wrote:
> Well, the best documentation I've found is something like
> http://www.fermimn.gov.it/linux/quarta/x86/int.htm
> 
> which states:
> 
> --- snip ---
> INTERRUPT-TO-INNER-PRIVILEGE:
>    [...]
>    TF := 0;
>    NT := 0;
> --- snip ---
> (Doesn't say anything about HW interrupts though)
> 
> This also makes sense at my opinion, since the interrupt handler has
> to know if it should return to the previous task (when NT=1) or to
> the same task (when NT=0).

No, it does not. Simply because Linux does not support nested tasks at
all, because the TSS is not accessible and the TSS.back_link is
sturdily NULL. So even if it would not explode with a #GP in IA-32e
mode it would explode while trying to execute the instruction at NULL.

> That might be possible. It probably makes sense to review other
> parts of the code, for similar issues.

What's the issue? Stupid user space programs segfaulting?

Thanks,

	tglx
