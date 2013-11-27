Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759158Ab3K0CPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:15:35 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:43167 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477Ab3K0CPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:15:33 -0500
MIME-Version: 1.0
In-Reply-To: <5956447.Fj3sMXmCsu@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org>
	<1385429290-25397-4-git-send-email-yinghai@kernel.org>
	<5956447.Fj3sMXmCsu@vostro.rjw.lan>
Date: Tue, 26 Nov 2013 18:15:32 -0800
X-Google-Sender-Auth: 2o6skVnj_tlyXgtE3WhXNiqKwG0
Message-ID: <CAE9FiQXjGPB4uurUA8wYL73UcBzSJYVKx90px-KuEYit1-c_GQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/10] PCI: Move resources and bus_list releasing to pci_release_dev
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 5:15 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> @@ -36,11 +22,6 @@ static void pci_destroy_dev(struct pci_dev *dev)
>>  {
>>       device_del(&dev->dev);
>>
>> -     down_write(&pci_bus_sem);
>> -     list_del(&dev->bus_list);
>> -     up_write(&pci_bus_sem);
>> -
>> -     pci_free_resources(dev);
>>       put_device(&dev->dev);
>
> And if the side effects are benign enough, why don't we do a device_unregister()
> here?

Yes, that is same, but we are using device_add in pci_device_add...

Thanks

Yinghai
