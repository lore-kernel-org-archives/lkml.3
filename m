Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaJKSPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:15:48 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57269 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752050AbaJKSPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:15:46 -0400
Message-ID: <543973C9.5060105@hurleysoftware.com>
Date: Sat, 11 Oct 2014 14:15:37 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Otavio Salvador <otavio@ossystems.com.br>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Peter Chen <peter.chen@freescale.com>, Rik van Riel <riel@redhat.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Josh Triplett <josh@joshtriplett.org>,
        Rabin Vincent <rabin@rab.in>, Alan Stern <stern@rowland.harvard.edu>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: RCU bug with v3.17-rc3 ?
References: <20141008212938.GP22688@saruman>	<20141009160138.GA2396@cmpxchg.org>	<20141009162656.GE16002@saruman>	<20141009204101.GA25955@debian>	<20141009204637.GE25729@saruman>	<20141009210715.GH25729@saruman>	<20141010135743.GB31348@saruman>	<20141010162531.GL12379@n2100.arm.linux.org.uk>	<54388B81.5020306@mentor.com>	<20141011035431.GK3756@peterchendt>	<20141011141638.GN12379@n2100.arm.linux.org.uk> <CAP9ODKrOv+_KtJDrwJ=tQCN6OrmzVopyWJKWes7vd9rKowmMjQ@mail.gmail.com>
In-Reply-To: <CAP9ODKrOv+_KtJDrwJ=tQCN6OrmzVopyWJKWes7vd9rKowmMjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2014 10:51 AM, Otavio Salvador wrote:
> Hello Russell,
> 
> On Sat, Oct 11, 2014 at 11:16 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Sat, Oct 11, 2014 at 11:54:32AM +0800, Peter Chen wrote:
>>> On Fri, Oct 10, 2014 at 08:44:33PM -0500, Nathan Lynch wrote:
>>>> On 10/10/2014 11:25 AM, Russell King - ARM Linux wrote:
>>>>>
>>>>> Right, so GCC 4.8.{1,2} are totally unsuitable for kernel building (and
>>>>> it seems that this has been known about for some time.)
>>>>
>>>> Looking at http://gcc.gnu.org/PR58854 it seems that all 4.8.x for x < 3
>>>> are affected, as well as 4.9.0.
>>>>
>>>>> We can blacklist these GCC versions quite easily.  We already have GCC
>>>>> 3.3 blacklisted, and it's trivial to add others.  I would want to include
>>>>> some proper details about the bug, just like the other existing entries
>>>>> we already have in asm-offsets.c, where we name the functions that the
>>>>> compiler is known to break where appropriate.
>>>>
>>>> Before blacklisting anything, it's worth considering that simple version
>>>> checks would break existing pre-4.8.3 compilers that have been patched
>>>> for PR58854.  It looks like Yocto and Buildroot issued releases with
>>>> patched 4.8.2 compilers well before the (fixed) 4.8.3 release.  I think
>>>> the most we can reasonably do without breaking some correctly-behaving
>>>> toolchains is to emit a warning.
>>>
>>> Yocto has PR58854 problem patch.
>>>
>>> http://git.yoctoproject.org/cgit/cgit.cgi/poky/tree/meta/recipes-devtools/gcc/gcc-4.8/0048-PR58854_fix_arm_apcs_epilogue.patch?h=daisy
>>
>> Right, and we can provide links to these in the comments above the #error
>> so people have the right places to do a bit of research into whether their
>> compiler is safe.
>>
>> It is unfortunate that they are indistinguishable from the broken versions,
>> but that's really a distro problem for causing that issue themselves -
>> especially given how serious this bug is.
> 
> What about checking if GCC_PR58854_FIXED is not defined for error? So
> build systems and people could easily define it if they know their GCC
> has the fix applied.

If the distro/build system/individual is capable of patching gcc, then it
seems reasonable that the same distro/build system/individual is capable
of carrying a patch on top of mainline kernel for building with their
"special" compiler.

