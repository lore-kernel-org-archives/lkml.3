Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbaLDLtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:49:31 -0500
Received: from eddie.linux-mips.org ([148.251.95.138]:57124 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbaLDLt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:49:29 -0500
Date: Thu, 4 Dec 2014 11:49:27 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: David Daney <ddaney@caviumnetworks.com>
cc: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>, Zubair.Kakakhel@imgtec.com,
        geert+renesas@glider.be, peterz@infradead.org,
        paul.gortmaker@windriver.com, chenhc@lemote.com, cl@linux.com,
        Ingo Molnar <mingo@kernel.org>, richard@nod.at, zajec5@gmail.com,
        james.hogan@imgtec.com, keescook@chromium.org, tj@kernel.org,
        alex@alex-smith.me.uk, pbonzini@redhat.com, blogic@openwrt.org,
        paul.burton@imgtec.com, qais.yousef@imgtec.com,
        linux-kernel@vger.kernel.org, markos.chandras@imgtec.com,
        dengcheng.zhu@imgtec.com, manuel.lauss@gmail.com,
        lars.persson@axis.com, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 2/3] MIPS: Add full ISA emulator.
In-Reply-To: <547FA8D2.2030703@caviumnetworks.com>
Message-ID: <alpine.LFD.2.11.1412040310100.22073@eddie.linux-mips.org>
References: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com> <1417650258-2811-3-git-send-email-ddaney.cavm@gmail.com> <547FA2E5.1040105@imgtec.com> <547FA8D2.2030703@caviumnetworks.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, David Daney wrote:

> > but it doesn't support customized instructions,
> 
> GCC will never put these in the delay slot of a FPU branch, so it is not
> needed.
> 
> > multiple ASEs,
> 
> Same as above.  But any instructions that are deemed necessary can easily be
> added.

 GAS will happily schedule any instruction into a branch delay slot as 
long as the instruction is not architecturally forbidden there (e.g. 
ERET), there is no data dependency with the branch that would affect the 
result produced and the instruction is not an explicit exception trap 
operation (BREAK, SYSCALL, TEQ, etc.).  For some reason, unknown to me all 
MT ASE instructions are disallowed too.  Anything else -- free to go in!

 Of course instructions can be scheduled into branch delay slots manually 
too, in handcoded assembly, and that has to continue working.

  Maciej
