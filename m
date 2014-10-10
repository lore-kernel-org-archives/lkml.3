Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaJJW5C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 18:57:02 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:44092 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbaJJW5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 18:57:01 -0400
Message-ID: <54386438.9090606@gmail.com>
Date: Fri, 10 Oct 2014 15:56:56 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org,
        Zubair.Kakakhel@imgtec.com, geert+renesas@glider.be,
        david.daney@cavium.com, peterz@infradead.org,
        paul.gortmaker@windriver.com, davidlohr@hp.com, macro@linux-mips.org,
        chenhc@lemote.com, richard@nod.at, zajec5@gmail.com,
        keescook@chromium.org, alex@alex-smith.me.uk, tglx@linutronix.de,
        blogic@openwrt.org, jchandra@broadcom.com, paul.burton@imgtec.com,
        qais.yousef@imgtec.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, markos.chandras@imgtec.com,
        dengcheng.zhu@imgtec.com, manuel.lauss@gmail.com,
        akpm@linux-foundation.org, lars.persson@axis.com
Subject: Re: [PATCH v2 2/3] MIPS: Setup an instruction emulation in VDSO protected
 page instead of user stack
References: <20141009195030.31230.58695.stgit@linux-yegoshin> <20141009200017.31230.69698.stgit@linux-yegoshin> <20141009224304.GA4818@jhogan-linux.le.imgtec.org> <543715D7.1020505@imgtec.com> <20141009234044.GB4818@jhogan-linux.le.imgtec.org> <5437232F.60800@imgtec.com> <20141010100334.GD4818@jhogan-linux.le.imgtec.org> <5438621C.8020708@imgtec.com>
In-Reply-To: <5438621C.8020708@imgtec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2014 03:47 PM, Leonid Yegoshin wrote:
> On 10/10/2014 03:03 AM, James Hogan wrote:
>> I just mean an (illegal/undefined) sequence of FPU branch instructions
>> in one anothers delay slots shouldn't be able to crash the kernel.
>> Actually 2 of them would be enough to verify the kernel didn't get too
>> confused. Maybe the second will be detected & ignored, or maybe it
>> doesn't matter if the first emuframe gets overwritten by the second
>> one from the kernels point of view.
>
> Yes, I am looking into that sequences. I try to keep both emulators
> isolated from the rest of kernel and from each other as much as possible
> but intercalls via illegal combinations are still possible.
>
>
>  > From Peter Zijlstra:
>
>  > Right, look at uprobes, it does exactly all this with a single page.
>  > Slot allocation will block waiting for a free slot when all are in use.
>
> I don't see a reason to change my 300 lines design into much more
> lengthy code. That code has more links to the rest of kernel and high
> possibility to execute atomic operation/locks/mutex/etc - I can't do it
> for emulation of MIPS locking instructions.
>

It isn't just the number of lines of code that is important.

Doesn't your solution consume an extra page for each thread requiring 
emulation?  That could be a significant amount of memory in a system 
with many threads.

Are you are using this to emulate atomic operations in addition to FPU 
branch delay slot instructions?  Where is the code that does that?

David Daney

> - Leonid.
>
>
>

