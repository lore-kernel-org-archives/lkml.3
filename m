Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaLDAwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:52:11 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:27338 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbaLDAwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:52:09 -0500
Message-ID: <547FB032.2000000@imgtec.com>
Date: Wed, 3 Dec 2014 16:52:02 -0800
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <ralf@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>,
        <geert+renesas@glider.be>, <peterz@infradead.org>,
        <paul.gortmaker@windriver.com>, <macro@linux-mips.org>,
        <chenhc@lemote.com>, <cl@linux.com>, <mingo@kernel.org>,
        <richard@nod.at>, <zajec5@gmail.com>, <james.hogan@imgtec.com>,
        <keescook@chromium.org>, <tj@kernel.org>, <alex@alex-smith.me.uk>,
        <pbonzini@redhat.com>, <blogic@openwrt.org>, <paul.burton@imgtec.com>,
        <qais.yousef@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <markos.chandras@imgtec.com>, <dengcheng.zhu@imgtec.com>,
        <manuel.lauss@gmail.com>, <lars.persson@axis.com>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 2/3] MIPS: Add full ISA emulator.
References: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com> <1417650258-2811-3-git-send-email-ddaney.cavm@gmail.com> <547FA2E5.1040105@imgtec.com> <547FA8D2.2030703@caviumnetworks.com>
In-Reply-To: <547FA8D2.2030703@caviumnetworks.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 04:20 PM, David Daney wrote:
> On 12/03/2014 03:55 PM, Leonid Yegoshin wrote:
>> On 12/03/2014 03:44 PM, David Daney wrote:
>>
>> (...)
>>
>> Big work
>
> Not really, although by number of lines of code, it is about 3x the 
> size of your patch, it only touches the existing code in one place.  
> It only took about 3 days to write, adding full MIPS64 and R6 support 
> would probably be less than another week of work.
>
> microMIPS I haven't looked at as we don't have anything to test it on.
>
>> but it doesn't support customized instructions,
>
> GCC will never put these in the delay slot of a FPU branch, so it is 
> not needed.

I doubt that it is correct in all situations and with any GCC parameter 
combination.

Never say never, if it is about toolchain. IMG Arch team was assured 
that branch likely are never used and removed it in MIPS R6, but BGEZL 
(or so) was a first which I hit then I ran GLIBC.

Besides GCC there are LLVM and another JITs.

>
>> multiple ASEs,
>
> Same as above.  But any instructions that are deemed necessary can 
> easily be added.
>
>> MIPS R6
>
> It is a proof of concept.  R6 can easily be added if needed.
>
> Your XOL emulation doesn't handle R6 either, so this is no worse than 
> your patch in that respect.

You probably didn't research it well. A lot of changes in 
arch/mips/kernel/branch.c and and arch/mips/math-emu/cp1emu.c, all of it 
related with R6.

>
>> etc.
>
> GCC will never put trapping instructions in the delay slot either.

It seems like it is not correct and requires a more accurate statement. 
FPU instructions may trap, LWL and LWR traps on R6 with RI, etc. Yes, 
there are restrictions but basing a kernel on that assumptions is 
unsafe. The only safe is HW architecture document.

Finally, there is a manual encoding too.

>
> All we have to support are non-trapping and non-branch/jump 
> instructions from the ISA manuals that can be executed from userspace 
> processes. That makes it slightly simpler than complete ISA emulation.
>
>>
>> Well, it is still not a replacement of XOL emulation.
>
> For use by the FPU emulator, it is probably good enough
>
>> Even close.
>
> I disagree, that is why I took the time to do it.
>
>>
>>
>

