Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbaE1N6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:58:17 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:41009 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbaE1N6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:58:15 -0400
Message-ID: <5385EB75.4090202@linaro.org>
Date: Wed, 28 May 2014 08:58:13 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: "mporter@linaro.org" <mporter@linaro.org>,
        "bcm@fixthebug.org" <bcm@fixthebug.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "rjui@broadcom.com" <rjui@broadcom.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "rvaswani@codeaurora.org" <rvaswani@codeaurora.org>
Subject: Re: [PATCH v4 1/5] devicetree: bindings: document Broadcom CPU enable
 method
References: <1400607830-10989-1-git-send-email-elder@linaro.org> <1400607830-10989-2-git-send-email-elder@linaro.org> <20140527114958.GC18476@e102568-lin.cambridge.arm.com> <53855867.7050800@linaro.org> <20140528103625.GA29219@e102568-lin.cambridge.arm.com> <5385D4EE.2040304@linaro.org> <20140528133428.GB29219@e102568-lin.cambridge.arm.com>
In-Reply-To: <20140528133428.GB29219@e102568-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 08:34 AM, Lorenzo Pieralisi wrote:
> On Wed, May 28, 2014 at 01:22:06PM +0100, Alex Elder wrote:
>> On 05/28/2014 05:36 AM, Lorenzo Pieralisi wrote:
>>> On Wed, May 28, 2014 at 04:30:47AM +0100, Alex Elder wrote:
>>>> On 05/27/2014 06:49 AM, Lorenzo Pieralisi wrote:
>>>>> On Tue, May 20, 2014 at 06:43:46PM +0100, Alex Elder wrote:
>>>>>> Broadcom mobile SoCs use a ROM-implemented holding pen for
>>>>>> controlled boot of secondary cores.  A special register is
>>>>>> used to communicate to the ROM that a secondary core should
>>>>>> start executing kernel code.  This enable method is currently
>>>>>> used for members of the bcm281xx and bcm21664 SoC families.
>>>>>>
>>>>>> The use of an enable method also allows the SMP operation vector to
>>>>>> be assigned as a result of device tree content for these SoCs.
>>>>>>
>>>>>> Signed-off-by: Alex Elder <elder@linaro.org>
>>>>>
>>>>> This is getting out of control, it is absolutely ghastly. I wonder how
>>>>> I can manage to keep cpus.txt updated if anyone with a boot method
>>>>> du jour adds into cpus.txt, and honestly in this specific case it is even
>>>>> hard to understand why.
>>>>
>>>> OK, in this message I'll focus on the particulars of this
>>>> proposed binding.
>>>>
>>>>> Can't it be done with bindings for the relative register address space
>>>>> (regmap ?) and platform code just calls the registers driver to set-up the
>>>>> jump address ? It is platform specific code anyway there is no way you
>>>>> can make this generic.
>>>>
>>>> I want to clarify what you're after here.
>>>>
>>>> My aim is to add SMP support for a class of Broadcom SMP
>>>> machines.  To do so, I'm told I need to use the technique
>>>> of assigning the SMP operations vector as a result of
>>>> identifying an enable method in the DT.
>>>>
>>>> For 32-bit ARM, there are no generic "enable-method" values.
>>>> (I did attempt to create one for "spin-table" but that was
>>>> rejected by Russell King.)  For the machines I'm trying to
>>>> enable, secondary CPUS start out spinning in a ROM-based
>>>> holding pen, and there is no need for a kernel-based one.
>>>>
>>>> However, like a spin-table/holding pen enable method, a
>>>> memory location is required for coordination between the
>>>> boot CPU running kernel code and secondary CPUs running ROM
>>>> code.  My proposal specifies it using a special numeric
>>>> property value named "secondary-boot-reg" in the "cpus"
>>>> node in the DT.
>>>>
>>>> And as I understand it, the issue you have relates to how
>>>> this memory location is specified.
>>>
>>> The issue I have relates to cluttering cpus.txt with all
>>> sorts of platform specific SMP boot hacks.
>>
>> OK, as I mentioned in my other message, I totally
>> agree with you here.  It's a total (and building)
>> mess.  I discussed this with Mark Rutland at ELC
>> last month and suggested splitting that stuff out
>> of "cpus.txt", which I have now proposed with a
>> patch.
>>     https://lkml.org/lkml/2014/5/8/545
> 
> I think this makes sense, I will review that patchset, and with this
> approach agreed I am ok with adding a platform specific boot method,
> since it is split up "nicely", do not bother adding a specific driver
> to poke a register (it will be fun to see the number of files we have
> to add to /cpu-enable-method though, big fun).

Great!

I used the existing documentation and the code as a guide in
crafting the text of those descriptions.  Some of them I had
to speculate though--especially for ARM64 (for which there is
documentation but nothing in the tree that uses it).  So it
needs some informed feedback.

> I still think that it is high time we started pushing back on these
> platform hacks and move towards a common interface like PSCI to boot
> (and suspend) ARM processors, there is no reason whatsoever why this
> can't be done on the platforms you are trying to get merged unless I am
> missing something.

We have no need for anything other than SMP startup at this point
on this platform.  If the framework were there for me to use I
would have used it.

Thanks again for working through this with me.

					-Alex

> Lorenzo
> 

