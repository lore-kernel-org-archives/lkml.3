Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaGIOpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:45:08 -0400
Received: from smtp.citrix.com ([66.165.176.89]:25009 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932066AbaGIOpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:45:06 -0400
X-IronPort-AV: E=Sophos;i="5.01,631,1400025600"; 
   d="scan'208";a="150983278"
Message-ID: <53BD556F.10408@citrix.com>
Date: Wed, 9 Jul 2014 15:45:03 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
CC: <konrad@kernel.org>, <boris.ostrovsky@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [PATCH v3 1/7] xen-pciback: Document the various
 parameters and attributes in SysFS
References: <1404845909-13563-1-git-send-email-konrad@kernel.org> <1404845909-13563-2-git-send-email-konrad@kernel.org> <53BD32C2.6000306@citrix.com> <20140709135922.GD21837@laptop.dumpdata.com> <53BD4C44.30805@citrix.com> <20140709141354.GG21837@laptop.dumpdata.com> <53BD5026.2030908@citrix.com> <20140709142510.GI21837@laptop.dumpdata.com>
In-Reply-To: <20140709142510.GI21837@laptop.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/14 15:25, Konrad Rzeszutek Wilk wrote:
> On Wed, Jul 09, 2014 at 03:22:30PM +0100, Andrew Cooper wrote:
>> On 09/07/14 15:13, Konrad Rzeszutek Wilk wrote:
>>> On Wed, Jul 09, 2014 at 03:05:56PM +0100, Andrew Cooper wrote:
>>>> On 09/07/14 14:59, Konrad Rzeszutek Wilk wrote:
>>>>>>> +What:           /sys/bus/pci/drivers/pciback/irq_handler_state
>>>>>>> +Date:           Oct 2011
>>>>>>> +KernelVersion:  3.1
>>>>>>> +Contact:        xen-devel@lists.xenproject.org
>>>>>>> +Description:
>>>>>>> +                An option to toggle Xen PCI back to acknowledge (or stop)
>>>>>>> +                interrupts for the specific device regardless of whether the
>>>>>>> +                device is shared, enabled, or on a level interrupt line.
>>>>>>> +                Writing a string of DDDD:BB:DD.F will toggle the state.
>>>>>>> +                This is Domain:Bus:Device.Function where domain is optional.
>>>>>> I do not understand under what circumstances this should be used in.
>>>>> So that dom0 does not disable the IRQ line as it would be getting the IRQs
>>>>> for the guest as well (because the IRQ line is level and another guest
>>>>> uses an PCI device that is using the same line).
>>>> Why is this relevant?  Xen (and Xen alone) actually controls this aspect
>>>> of interrupts.  Xen manages passing line level interrupts to any domain
>>>> which might have a device hanging off a particular line, and has to wait
>>>> until all domains have EOI'd the line until it can clear the interrupt
>>>> at the IO-APIC.
>>> Because Linux will think there is an IRQ storm as the event->IRQ points
>>> to the default one. And then it will mask the event, which means dom0
>>> will mask the PIRQ, and Xen will then also mask the IRQ.
>>
>> Xen will (and by this I mean 'should', and this was the behaviour last
>> time I delved in there) only mask the IRQ if dom0 is the only consumer
>> of these interrupts.
>>
>> For any PCIPassthrough, dom0 will get line interrupts for passed-through
>> devices, but in this case pci-back should always handle the line
>> interrupts so Linux doesn't block them as an IRQ storm.
> 
> And that is what it does - and this option provides the option to enable/disable
> it the system admin wishes to do it.

I still don't understand why someone would want to flip the handler to
a broken mode.

The original commit isn't very enlightening either.

David
