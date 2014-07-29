Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaG2MeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:34:06 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:38857 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaG2MeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:34:04 -0400
MIME-Version: 1.0
In-Reply-To: <53D7725C.5010405@citrix.com>
References: <1406606791-8834-1-git-send-email-ethan.zhao@oracle.com>
	<1406606791-8834-4-git-send-email-ethan.zhao@oracle.com>
	<53D7725C.5010405@citrix.com>
Date: Tue, 29 Jul 2014 20:34:02 +0800
Message-ID: <CABawtvPLXE=VF-yP6UuguBgxU5Pv=m8PS8kLSOUD=TmkgS6KVA@mail.gmail.com>
Subject: Re: [PATCH 3/4 v3] xen-pciback: use pci device flag operation helper function
From: Ethan Zhao <ethan.kernel@gmail.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Ethan Zhao <ethan.zhao@oracle.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "<gleb@kernel.org>" <gleb@kernel.org>,
        "<pbonzini@redhat.com>" <pbonzini@redhat.com>,
        "<kvm@vger.kernel.org>" <kvm@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "<boris.ostrovsky@oracle.com>" <boris.ostrovsky@oracle.com>,
        "<xen-devel@lists.xenproject.org>" <xen-devel@lists.xenproject.org>,
        "<alex.williamson@redhat.com>" <alex.williamson@redhat.com>,
        "<alexander.h.duyck@intel.com>" <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 6:07 PM, David Vrabel <david.vrabel@citrix.com> wrote:
> On 29/07/14 05:06, Ethan Zhao wrote:
>> Use pci device flag operation helper functions when set device
>> to assigned or deassigned state.
>>
>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>
> Konrad already reviewed this but you've not included his reviewed-by tag.
>
> I don't understand why we bother with this flag on Xen since we never
> use it but:
>
> Acked-by: David Vrabel <david.vrabel@citrix.com>
>
> I'm expecting this to go via the PCI tree.

  Seems Bjorn still holds his bullet for last shot :)
>
> David
>
>> --- a/drivers/xen/xen-pciback/pci_stub.c
>> +++ b/drivers/xen/xen-pciback/pci_stub.c
>> @@ -133,7 +133,7 @@ static void pcistub_device_release(struct kref *kref)
>>       xen_pcibk_config_free_dyn_fields(dev);
>>       xen_pcibk_config_free_dev(dev);
>>
>> -     dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
>> +     pci_clear_dev_assigned(dev);
>>       pci_dev_put(dev);
>>
>>       kfree(psdev);
>> @@ -404,7 +404,7 @@ static int pcistub_init_device(struct pci_dev *dev)
>>       dev_dbg(&dev->dev, "reset device\n");
>>       xen_pcibk_reset_device(dev);
>>
>> -     dev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
>> +     pci_set_dev_assigned(dev);
>>       return 0;
>>
>>  config_release:
>>
>
