Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbbAUDWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:22:54 -0500
Received: from ozlabs.org ([103.22.144.67]:58989 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbbAUDWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:22:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 10/16] s390: add pci_iomap_range
In-Reply-To: <alpine.LFD.2.11.1501161051380.1742@denkbrett>
References: <1421256142-11512-1-git-send-email-mst@redhat.com> <1421256142-11512-11-git-send-email-mst@redhat.com> <alpine.LFD.2.11.1501161051380.1742@denkbrett>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 21 Jan 2015 11:13:14 +1030
Message-ID: <87fvb5arq5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Ott <sebott@linux.vnet.ibm.com> writes:
> On Wed, 14 Jan 2015, Michael S. Tsirkin wrote:
>>  }
>> -EXPORT_SYMBOL_GPL(pci_iomap);
>> +EXPORT_SYMBOL_GPL(pci_iomap_range);
>> +
>> +void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
>> +{
>> +	return pci_iomap_range(dev, bar, 0, maxlen);
>> +}
>> +EXPORT_SYMBOL(pci_iomap);
>
> As discussed earlier, could you please leave that as EXPORT_SYMBOL_GPL.
> If there's a reason to have these interfaces as EXPORT_SYMBOL, we could
> change all of them in an extra patch.
>
> With this change integrated you can add
> Acked-by: Sebastian Ott <sebott@linux.vnet.ibm.com>

OK, I've gone back and rebased virtio-next to fix this (I don't really
want to think too hard about the legal consequences of having a version
which isn't EXPORT_SYMBOL_GPL).

Thanks,
Rusty.
