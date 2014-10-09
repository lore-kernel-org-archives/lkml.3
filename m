Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaJIXKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 19:10:24 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:29224 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaJIXKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 19:10:21 -0400
Message-ID: <543715D7.1020505@imgtec.com>
Date: Thu, 9 Oct 2014 16:10:15 -0700
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: <linux-mips@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>,
        <geert+renesas@glider.be>, <david.daney@cavium.com>,
        <peterz@infradead.org>, <paul.gortmaker@windriver.com>,
        <davidlohr@hp.com>, <macro@linux-mips.org>, <chenhc@lemote.com>,
        <richard@nod.at>, <zajec5@gmail.com>, <keescook@chromium.org>,
        <alex@alex-smith.me.uk>, <tglx@linutronix.de>, <blogic@openwrt.org>,
        <jchandra@broadcom.com>, <paul.burton@imgtec.com>,
        <qais.yousef@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <ralf@linux-mips.org>, <markos.chandras@imgtec.com>,
        <dengcheng.zhu@imgtec.com>, <manuel.lauss@gmail.com>,
        <akpm@linux-foundation.org>, <lars.persson@axis.com>
Subject: Re: [PATCH v2 2/3] MIPS: Setup an instruction emulation in VDSO protected
 page instead of user stack
References: <20141009195030.31230.58695.stgit@linux-yegoshin> <20141009200017.31230.69698.stgit@linux-yegoshin> <20141009224304.GA4818@jhogan-linux.le.imgtec.org>
In-Reply-To: <20141009224304.GA4818@jhogan-linux.le.imgtec.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Small stack of emulation blocks is supported because nested traps are possible
>> in MIPS32/64 R6 emulation mix with FPU emulation.
> Could you please clarify how this nesting of emulation blocks could
> happen now that signals are handled more cleanly.
>
> I.e. isn't the emuframe stuff only required for instructions in branch
> delay slots, and branches shouldn't be in branch delay slots anyway, so
> I don't get how they could nest.
>
It may be a case for mix of FPU and MIPS R6 emulations. I just keep both 
emulators separate as much as possible but I assume that without prove 
it may be stackable - some rollback is needed to join both and it may 
(probably) cause a double emulation setup - dsemul may be called twice 
for the same pair of instructions. I didn't see that yet, honestly and 
you may be right.

And as for signals - it is a different issue, some signal may happen 
before or after emulated instruction in emulation block and I see that. 
But I see it only before because of probability for it is a lot of 
higher. Unwinding is need because signal handler may not return but 
longjump to somewhere.
