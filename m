Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaJ1Oai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:30:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbaJ1Oag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:30:36 -0400
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] arm64: amd-seattle: Adding device tree for AMD Seattle platform
From: Alexander Graf <agraf@suse.de>
X-Mailer: iPhone Mail (12B411)
In-Reply-To: <544F9525.80304@amd.com>
Date: Tue, 28 Oct 2014 15:30:32 +0100
Cc: =?utf-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "liviu.dudau@arm.com" <liviu.dudau@arm.com>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <DA04E483-1B4F-4B24-88B4-ABB7925EEC2C@suse.de>
References: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com> <544C2D67.8000405@suse.de> <544CEC5B.4020104@suse.de> <A1BC53C1-A78E-4B0C-879B-F6A462E58C72@suse.de> <544E56DB.7020305@amd.com> <544ED462.20601@suse.de> <544F9525.80304@amd.com>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> Am 28.10.2014 um 14:07 schrieb Suravee Suthikulanit <suravee.suthikulpanit@amd.com>:
> 
>> On 10/27/2014 6:25 PM, Alexander Graf wrote:
>> 
>> 
>>> On 27.10.14 15:29, Suravee Suthikulanit wrote:
>>> On 10/26/2014 9:08 AM, Alexander Graf wrote:
>>>>>> This option doesn't exist in upstream kernels, does it? Why not just
>>>>>>>> make it dtb-y?
>>>>>> 
>>>>>> CONFIG_ARCH_SEATTLE is being added one hunk above.:)
>>>> Oops:).
>>>> 
>>>> I'm not convinced we need a config option just for the sake of
>>>> compiling a device tree though.
>>>> 
>>>> 
>>>> Alex
>>>> 
>>> 
>>> Eventually, we would add other device driver selections when
>>> CONFIG_ARCH_SEATTLE=y. At this point, those drivers are still not ready.
>> 
>> Could you please give me some examples of drivers that would depend on
>> CONFIG_ARCH_SEATTLE? I like the current way things work without the need
>> for such an option, where everything's implemented purely as drivers you
>> can opt in our out of.
>> 
>> You don't have a CONFIG_ARCH_SB7XX on x86 either, right? ;)
>> 
>> 
>> Alex
>> 
> 
> I am not saying that device drivers need to depend on CONFIG_ARCH_SEATTLE. I am thinking along the line of an easy way to enable SOC without having to manually select each of the required drivers to support the SOC. An example is the "ARCH_VEXPRESS".

Works for me, but then please don't make anything depend on CONFIG_ARCH_SEATTLE. Everything you need for seattle support should be possible to select without the easy enable switch until we see a good reason to have one ;).

So in this particular case, we shouldn't build the device tree depending on CONFIG_ARCH_SEATTLE but rather slways which again means the switch does not need to get introduced by this patch ;)

But at the end of the day, this is Catalin's subsystem and his opinion counts more than mine. Catalin, do you have strong feelings in any direction here?


Alex

