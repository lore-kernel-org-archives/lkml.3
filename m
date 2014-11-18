Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974AbaKRKRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:17:36 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:53019 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847AbaKRKRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:17:33 -0500
Message-ID: <546B1CA6.1030300@linaro.org>
Date: Tue, 18 Nov 2014 11:17:10 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linaro-acpi@lists.linaro.org
CC: linux-arm-kernel@lists.infradead.org, rjw@rjwysocki.net,
        linux-pci@vger.kernel.org, catalin.marinas@arm.com, x86@kernel.org,
        Liviu.Dudau@arm.com, linux-kernel@vger.kernel.org, will.deacon@arm.com,
        linux-acpi@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        bhelgaas@google.com, tglx@linutronix.de
Subject: Re: [Linaro-acpi] [RFC PATCH 4/4] arm64, acpi, pci: Provide arch-specific
 calls for PCI host bridge dirver (PNP0A03).
References: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org> <4474363.kMvYSLl2Ev@wuerfel> <54660D44.9020406@linaro.org> <2009440.GJsvyI3SUN@wuerfel>
In-Reply-To: <2009440.GJsvyI3SUN@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.11.2014 15:53, Arnd Bergmann wrote:
> On Friday 14 November 2014 15:10:12 Tomasz Nowicki wrote:
>> On 07.11.2014 15:24, Arnd Bergmann wrote:
>>> On Friday 07 November 2014 14:27:56 Tomasz Nowicki wrote:
>>>>
>>>>    #ifdef CONFIG_PCI
>>>> +struct pci_controller {
>>>> +	struct acpi_device *companion;
>>>> +	int segment;
>>>> +	int node;		/* nearest node with memory or NUMA_NO_NODE for global allocation */
>>>> +};
>>>> +
>>>> +#define PCI_CONTROLLER(busdev) ((struct pci_controller *) busdev->sysdata)
>>>> +
>>>
>>> Don't use busdev->sysdata in architecture specific code, it belongs to the
>>> host bridge driver with the new model. For ACPI you don't have a host bridge
>>> driver, but it's better to keep these separate.
>>>
>>> The segment is always the same as the domain number, so just use that.
>>> The node and companion members here can get added to struct pci_host_bridge.
>>
>> The reason why I put segment field to struct pci_controller is to
>> initialize domain_nr of struct pci_bus being in pci_create_root_bus(),
>> domain_nr can be used later on though. Correct me I am wrong.
>>
>> Honestly I do not see the way to create root bus without e.g.
>> sysdata.segment here.
>
> See the patches that Liviu and Lorenzo have been posting recently. This
> should be straightforward in 3.19.

Hi Arnd,

I have been looking into patch (if that what you meant) :
[RFC PATCH v2] drivers: pci: move PCI domain assignment to generic PCI code

This is not enough for me since it gets domain number from its OF parent 
or just uses sequential increased domain number. In my case, I do not 
have parent so I need to get segment from ACPI node which is not 
available there.

On the other hand, patch set posted by Wang Yijing:
[RFC PATCH 00/16] Refine PCI host bridge scan interfaces
tends to solve that issue.

What would be the best way for this patch, keep busdev->sysdata usage 
and rebase once Wang Yijing patch set will be accepted?

Regards,
Tomasz



