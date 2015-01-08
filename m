Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbbAHIkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:40:32 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:53085 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbbAHIka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:40:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>, Joerg Roedel <joro@8bytes.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 2/4] of: move of_dma_configure() to device,c to help re-use
Date: Thu, 08 Jan 2015 09:40:10 +0100
Message-ID: <3861625.CJ6m15sZMh@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_Jsq+pKeXuGnZV_NYHn6iZgeOs404OPhcUb0FJs=-7j2P1Ug@mail.gmail.com>
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com> <1420656594-8908-3-git-send-email-m-karicheri2@ti.com> <CAL_Jsq+pKeXuGnZV_NYHn6iZgeOs404OPhcUb0FJs=-7j2P1Ug@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:YzWZA+UNg0FsLtGyh0FgFQtoCvjUvsdQi6Oe3XtQygWwvF7raRN
 p4/BSyQt9zQyQvJrKByJMoyK94o66tVJhCrtIvm5+18lp6xE0wUdAlSPU6x2Jjo4zDc0ulk
 1QLIk/bKXsXfYxPomXAQHOnhJNgAKp6/OIcHZ5o9rEbdXvyJCNKmkUZ7ayoLt4ZdNZwTqjK
 HPaipgX4TvOn1D8NteOPA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2015 17:37:56 Rob Herring wrote:
> On Wed, Jan 7, 2015 at 12:49 PM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> 
> > +       ret = of_dma_get_range(np, &dma_addr, &paddr, &size);
> > +       if (ret < 0) {
> > +               dma_addr = offset = 0;
> > +               size = dev->coherent_dma_mask + 1;
> 
> If coherent_dma_mask is DMA_BIT_MASK(64), then you will overflow and
> have a size of 0. There may also be a problem when the mask is only
> 32-bit type.

The mask is always a 64-bit type, it's not optional. But you are right,
the 64-bit mask case is broken, so I guess we have to fix it differently
by always passing the smaller value into arch_setup_dma_ops and
adapting that function instead.

	Arnd
