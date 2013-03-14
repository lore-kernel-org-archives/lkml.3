Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab3CNOqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:46:10 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:46588 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715Ab3CNOqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:46:08 -0400
Message-ID: <5141E2AA.8010303@openvz.org>
Date: Thu, 14 Mar 2013 18:46:02 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130119 Firefox/10.0.11esrpre Iceape/2.7.12
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Kexec Mailing List <kexec@lists.infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: 3.9.0-rc1: kexec not working: root disk does not show up
References: <20130308171704.GE8219@redhat.com> <20130312192922.GA2268@redhat.com> <51402ED5.6000902@openvz.org> <20130313135351.GB11528@redhat.com> <514092DC.5020500@openvz.org> <20130314135507.GA24238@redhat.com>
In-Reply-To: <20130314135507.GA24238@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Wed, Mar 13, 2013 at 06:53:16PM +0400, Konstantin Khlebnikov wrote:
>
> [..]
>> PCI: Don't try to disable Bus Master on disconnected PCI devices
>>
>> From: Konstantin Khlebnikov<khlebnikov@openvz.org>
>>
>> This is fix for commit 7897e6022761ace7377f0f784fca059da55f5d71 from v3.9-rc1
>> ("PCI: Disable Bus Master unconditionally in pci_device_shutdown()")
>> in turn that was fix for b566a22c23327f18ce941ffad0ca907e50a53d41 from v3.5-rc1
>> ("PCI: disable Bus Master on PCI device shutdown")
>>
>> Unfortunately fixing one bug uncovers another: after ->shutdown() device can be
>> already disconnected from the bus and configuration space in no longer available
>>
>> Link: https://lkml.org/lkml/2013/3/12/529
>> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
>> Reported-by: Vivek Goyal<vgoyal@redhat.com>
>> Cc: Bjorn Helgaas<bhelgaas@google.com>
>> Cc: Rafael J. Wysocki<rafael.j.wysocki@intel.com>
>> ---
>>   drivers/pci/pci-driver.c |    5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
>> index 1fa1e48..79277fb 100644
>> --- a/drivers/pci/pci-driver.c
>> +++ b/drivers/pci/pci-driver.c
>> @@ -390,9 +390,10 @@ static void pci_device_shutdown(struct device *dev)
>>
>>   	/*
>>   	 * Turn off Bus Master bit on the device to tell it to not
>> -	 * continue to do DMA
>> +	 * continue to do DMA. Don't touch devices in D3cold or unknown states.
>>   	 */
>> -	pci_clear_master(pci_dev);
>> +	if (pci_dev->current_state<= PCI_D3hot)
>> +		pci_clear_master(pci_dev);
>>   }
>>
>>   #ifdef CONFIG_PM
>
> Hi,
>
> Above patch fixed the issue on my box. Now I can kexec. Thanks.
>
> Vivek
>

Ok, thanks for testing.
