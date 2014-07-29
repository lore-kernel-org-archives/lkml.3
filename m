Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaG2MQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:16:28 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52365 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaG2MQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:16:26 -0400
Content-Type: text/plain;
	charset=gb2312
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 3/4 v3] xen-pciback: use pci device flag operation helper function
From: Ethan Zhao <ethan.kernel@gmail.com>
X-Mailer: iPad Mail (11D201)
In-Reply-To: <53D7725C.5010405@citrix.com>
Date: Tue, 29 Jul 2014 20:16:12 +0800
Cc: Ethan Zhao <ethan.zhao@oracle.com>,
        "<bhelgaas@google.com>" <bhelgaas@google.com>,
        "<linux-pci@vger.kernel.org>" <linux-pci@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<gleb@kernel.org>" <gleb@kernel.org>,
        "<pbonzini@redhat.com>" <pbonzini@redhat.com>,
        "<kvm@vger.kernel.org>" <kvm@vger.kernel.org>,
        "<konrad.wilk@oracle.com>" <konrad.wilk@oracle.com>,
        "<boris.ostrovsky@oracle.com>" <boris.ostrovsky@oracle.com>,
        "<xen-devel@lists.xenproject.org>" <xen-devel@lists.xenproject.org>,
        "<alex.williamson@redhat.com>" <alex.williamson@redhat.com>,
        "<alexander.h.duyck@intel.com>" <alexander.h.duyck@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <32E4A68B-AF5E-49ED-92AC-99DFCD0960BD@gmail.com>
References: <1406606791-8834-1-git-send-email-ethan.zhao@oracle.com> <1406606791-8834-4-git-send-email-ethan.zhao@oracle.com> <53D7725C.5010405@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> 在 2014年7月29日，下午6:07，David Vrabel <david.vrabel@citrix.com> 写道：
> 
>> On 29/07/14 05:06, Ethan Zhao wrote:
>> Use pci device flag operation helper functions when set device
>> to assigned or deassigned state.
>> 
>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
> 
> Konrad already reviewed this but you've not included his reviewed-by tag.
> 
yep，I lost Konrad's reviewed-by tag.
Thanks.
> I don't understand why we bother with this flag on Xen since we never
> use it but:
> 
> Acked-by: David Vrabel <david.vrabel@citrix.com>
> 
> I'm expecting this to go via the PCI tree.
> 
> David
> 
>> --- a/drivers/xen/xen-pciback/pci_stub.c
>> +++ b/drivers/xen/xen-pciback/pci_stub.c
>> @@ -133,7 +133,7 @@ static void pcistub_device_release(struct kref *kref)
>>    xen_pcibk_config_free_dyn_fields(dev);
>>    xen_pcibk_config_free_dev(dev);
>> 
>> -    dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
>> +    pci_clear_dev_assigned(dev);
>>    pci_dev_put(dev);
>> 
>>    kfree(psdev);
>> @@ -404,7 +404,7 @@ static int pcistub_init_device(struct pci_dev *dev)
>>    dev_dbg(&dev->dev, "reset device\n");
>>    xen_pcibk_reset_device(dev);
>> 
>> -    dev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
>> +    pci_set_dev_assigned(dev);
>>    return 0;
>> 
>> config_release:
>> 
> 
