Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab3BAWcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:32:07 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:51591 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab3BAWcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:32:03 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1302011442200.11804@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1301181302260.31163@jlaw-desktop.mno.stratus.com>
 <alpine.DEB.2.02.1301181322500.31163@jlaw-desktop.mno.stratus.com>
 <1359674965.2426.13.camel@zim.stowe> <alpine.DEB.2.02.1302011442200.11804@jlaw-desktop.mno.stratus.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 1 Feb 2013 15:31:41 -0700
Message-ID: <CAErSpo7OYFF7YGDneoTvVjhxMq1q92UewddseLrx_w7VJ+JOBA@mail.gmail.com>
Subject: Re: [PATCH 1/2] PCI: ASPM exit link state code could skip devices
To: Joe Lawrence <Joe.Lawrence@stratus.com>
Cc: Myron Stowe <mstowe@redhat.com>, linux-pci@vger.kernel.org,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        David Bulkow <david.bulkow@stratus.com>, shli@kernel.org,
        shli@fusionio.com, kaneshige.kenji@jp.fujitsu.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 12:55 PM, Joe Lawrence <Joe.Lawrence@stratus.com> wrote:
> On Thu, 31 Jan 2013, Myron Stowe wrote:

>> PCI: ASPM exit link state code is skipping devices
>>
>> From: Myron Stowe <myron.stowe@redhat.com>
>>
>> On PCI bus hotplug removal, 'pcie_aspm_exit_link_state' can potentially
>> skip parent devices that have link_state allocated.  Instead of exiting
>> early if a given device in not PCIe, check whether or not the device's
>> parent has link_state allocated.  This enables 'pcie_aspm_exit_link_state'
>> to properly clean up parent link_state when the last function in a slot
>> might not be PCIe.
>>
>> Reported-by: Joe Lawrence <joe.lawrence@stratus.com>
>> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
>> ---
>>
>>  drivers/pci/pcie/aspm.c |    5 +----
>>  1 files changed, 1 insertions(+), 4 deletions(-)
>>
>>
>> diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
>> index 8474b6a..aa52727 100644
>> --- a/drivers/pci/pcie/aspm.c
>> +++ b/drivers/pci/pcie/aspm.c
>> @@ -634,10 +634,7 @@ void pcie_aspm_exit_link_state(struct pci_dev *pdev)
>>       struct pci_dev *parent = pdev->bus->self;
>>       struct pcie_link_state *link, *root, *parent_link;
>>
>> -     if (!pci_is_pcie(pdev) || !parent || !parent->link_state)
>> -             return;
>> -     if ((pci_pcie_type(parent) != PCI_EXP_TYPE_ROOT_PORT) &&
>> -         (pci_pcie_type(parent) != PCI_EXP_TYPE_DOWNSTREAM))
>> +     if (!parent || !parent->link_state)
>>               return;
>>
>>       down_read(&pci_bus_sem);
>>
>>
>>
>
> Hi Myron,
>
> The patch tests eliminates the reported crash when hotplugging our
> problem PCI bus.
>
> The additional checks removed from pcie_aspm_exit_link_state (ie, the
> simplification) do appear to be unnecessary as pcie_aspm_init_link_state
> is already preventing such devices from allocating link state.

I added a Tested-by for you, Joe, and applied this to my pci/joe-aspm
branch for v3.9.  Thanks!
