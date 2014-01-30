Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaA3RYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 12:24:41 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:47488 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753097AbaA3RYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 12:24:38 -0500
Message-ID: <52EA8AD3.8080904@arm.com>
Date: Thu, 30 Jan 2014 17:24:35 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <Will.Deacon@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: document "mach-virt" platform.
References: <1391098262-15944-1-git-send-email-ian.campbell@citrix.com>  <52EA8853.8080709@arm.com> <1391102475.9495.44.camel@kazak.uk.xensource.com>
In-Reply-To: <1391102475.9495.44.camel@kazak.uk.xensource.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/01/14 17:21, Ian Campbell wrote:
> On Thu, 2014-01-30 at 17:13 +0000, Marc Zyngier wrote:
>> Hi Ian,
>>
>> On 30/01/14 16:11, Ian Campbell wrote:
>>> mach-virt has existed for a while but it is not written down what it actually
>>> consists of. Although it seems a bit unusual to document a binding for an
>>> entire platform since mach-virt is entirely virtual it is helpful to have
>>> something to refer to in the absence of a single concrete implementation.
>>>
>>> I've done my best to capture the requirements based on the git log and my
>>> memory/understanding.
>>>
>>> While here remove the xenvm dts example, the Xen tools will now build a
>>> suitable mach-virt compatible dts when launching the guest.
>>>
>>> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
>>> Cc: Rob Herring <robh+dt@kernel.org>
>>> Cc: Pawel Moll <pawel.moll@arm.com>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Cc: Kumar Gala <galak@codeaurora.org>
>>> Cc: Olof Johansson <olof@lixom.net>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>> Cc: Will Deacon <will.deacon@arm.com>
>>> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>> Cc: devicetree@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: linux-arm-kernel@lists.infradead.org
>>> ---
>>> I'm not sure which tree this sort of thing should go though, sorry for the
>>> huge Cc.
>>> ---
>>>  .../devicetree/bindings/arm/mach-virt.txt          |   32 ++++++++
>>>  arch/arm/boot/dts/xenvm-4.2.dts                    |   81 --------------------
>>>  2 files changed, 32 insertions(+), 81 deletions(-)
>>>  create mode 100644 Documentation/devicetree/bindings/arm/mach-virt.txt
>>>  delete mode 100644 arch/arm/boot/dts/xenvm-4.2.dts
>>>
>>> diff --git a/Documentation/devicetree/bindings/arm/mach-virt.txt b/Documentation/devicetree/bindings/arm/mach-virt.txt
>>> new file mode 100644
>>> index 0000000..562bcda
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/arm/mach-virt.txt
>>> @@ -0,0 +1,32 @@
>>> +* Mach-virt "Dummy Virtual Machine" platform
>>> +
>>> +"mach-virt" is the smallest, dumbest platform possible, to be used as
>>> +a guest for Xen, KVM and other hypervisors. It has no
>>> +properties/functionality of its own and is driven entirely by device
>>> +tree.
>>> +
>>> +This document defines the requirements for such a platform.
>>> +
>>> +* Required properties:
>>> +
>>> +- compatible: should be one of:
>>> +	"linux,dummy-virt"
>>> +	"xen,xenvm"
>>> +
>>> +In addition to the standard nodes (chosen, cpus, memory etc) the
>>> +platform is required to provide certain other basic functionality
>>> +which must be described in the device tree:
>>> +
>>> +    The platform must provide an ARM Generic Interrupt Controller
>>> +    (GIC), defined in Documentation/devicetree/bindings/arm/gic.txt.
>>> +
>>> +    The platform must provide ARM architected timer, defined in
>>> +    Documentation/devicetree/bindings/arm/arch_timer.txt.
>>> +
>>> +    If the platform is SMP then it must provide the Power State
>>> +    Coordination Interface (PSCI) described in
>>> +    Documentation/devicetree/bindings/arm/psci.txt.
>>
>> I'm afraid I disagree with most of the above. The whole point of
>> mach-virt is to provide a shell for DT platforms. None of this hardware
>> is mandated. Instead, all the necessary information should be described
>> in DT.
> 
> "Add support for the smallest, dumbest possible platform, to be
>  used as a guest for KVM or other hypervisors.
> 
>  It only mandates a GIC and architected timers"
> 
> (your original commit message :-P)

Right. 1984, here we come. I'll disappear for a while, rewriting the
history. More seriously, that was just me scheming to get it merged,
hiding my cunning plan for mach-virt world domination!

>> Actually, mach-virt doesn't really stand for Virtual Machine. It stands
>> for virtual mach-* directory! Eventually, mach-virt should become the
>> default platform, the one we use when we don't match anything else in
>> the kernel
> 
> I can word it more like that for sure, along with the alternative
> wording suggested by Christopher/Stefano to clarify the intent that
> everything comes from DTB and removal of the specific requirements for
> GIC/timer/PSCI I think that suit the (new) intention better?

Yes, please! :-)

	M.
-- 
Jazz is not dead. It just smells funny...
