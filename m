Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaJFSFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:05:49 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:64178 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaJFSFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:05:48 -0400
Message-ID: <5432D9F8.9040004@gmail.com>
Date: Mon, 06 Oct 2014 11:05:44 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: linux-mips@linux-mips.org, Zubair.Kakakhel@imgtec.com,
        david.daney@cavium.com, peterz@infradead.org,
        paul.gortmaker@windriver.com, davidlohr@hp.com, macro@linux-mips.org,
        chenhc@lemote.com, zajec5@gmail.com, james.hogan@imgtec.com,
        keescook@chromium.org, alex@alex-smith.me.uk, tglx@linutronix.de,
        blogic@openwrt.org, jchandra@broadcom.com, paul.burton@imgtec.com,
        qais.yousef@imgtec.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, markos.chandras@imgtec.com,
        manuel.lauss@gmail.com, akpm@linux-foundation.org,
        lars.persson@axis.com
Subject: Re: [PATCH 2/3] MIPS: Setup an instruction emulation in VDSO protected
 page instead of user stack
References: <20141004030438.28569.85536.stgit@linux-yegoshin> <20141004031730.28569.38511.stgit@linux-yegoshin>
In-Reply-To: <20141004031730.28569.38511.stgit@linux-yegoshin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2014 08:17 PM, Leonid Yegoshin wrote:
> Historically, during FPU emulation MIPS runs live BD-slot instruction in stack.
> This is needed because it was the only way to correctly handle branch
> exceptions with unknown COP2 instructions in BD-slot. Now there is
> an eXecuteInhibit feature and it is desirable to protect stack from execution
> for security reasons.
> This patch moves FPU emulation from stack area to VDSO-located page which is set
> write-protected for application access. VDSO page itself is now per-thread and
> it's addresses and offsets are stored in thread_info.
> Small stack of emulation blocks is supported because nested traps are possible
> in MIPS32/64 R6 emulation mix with FPU emulation.
>

Can you explain how this per-thread mapping works.

I am especially interested in what happens when a different thread from 
the thread using the special mapping, issues flush_tlb_mm(), and 
invalidates the TLBs on all CPUs.  How does the TLB entry for the 
special mapping survive this?

David Daney

