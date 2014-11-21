Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbaKUOsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:48:39 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36795 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbaKUOsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:48:38 -0500
Message-ID: <546F50BD.8070501@arm.com>
Date: Fri, 21 Nov 2014 14:48:29 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
CC: Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Schopp, Joel" <Joel.Schopp@amd.com>
Subject: Re: [PATCH V3] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
References: <D0955C2B.9B22%suravee.suthikulpanit@amd.com>
In-Reply-To: <D0955C2B.9B22%suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/11/14 14:40, Suthikulpanit, Suravee wrote:
> 
> 
> On 11/21/14, 19:57, "Marc Zyngier" <marc.zyngier@arm.com> wrote:
> 
>>> +	gic: interrupt-controller@e1101000 {
>>> +		compatible = "arm,gic-400", "arm,cortex-a15-gic";
>>> +		interrupt-controller;
>>> +		#interrupt-cells = <3>;
>>> +		#address-cells = <2>;
>>> +		#size-cells = <2>;
>>> +		reg = <0x0 0xe1110000 0 0x1000>,
>>> +		      <0x0 0xe112f000 0 0x2000>,
>>> +		      <0x0 0xe1140000 0 0x10000>,
>>> +		      <0x0 0xe1160000 0 0x10000>;
>>> +		interrupts = <1 8 0xf04>;
>>
>> Are you sure about this one? ARM systems usually have this wired on PPI9
>> (interrupt 25)...
>>
>> Thanks,
>>
>> 	M.
> 
> I think you might be right. GIC-400 TRM says that this is should be
> 25, and used for virtual maintenance interrupts. How can I verify
> this in Linux? KVM?

KVM is one way, but you'll never see the interrupt firing (we kill the
interrupt while in HYP, before the kernel gets a chance to see it).

If you effectively have GIC400 on this system, then I know for sure this
is interrupt 25.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
