Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaIIVK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:10:27 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:50666 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaIIVKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:10:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bhelgaas@google.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 2/2] PCI: keystone: update to support multiple pci ports
Date: Tue, 09 Sep 2014 23:09:36 +0200
Message-ID: <9042477.aRbAhpkfQ5@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <540F6646.3010607@ti.com>
References: <1410293835-13050-1-git-send-email-m-karicheri2@ti.com> <3294679.puV171E8qx@wuerfel> <540F6646.3010607@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:YJ0mfOsINh1q4+cT60smZt6N/9VXf5MGOegWZBIcEFl
 rCDB3P9t4QWNNAgQslMG1bo0m2pkyBB3R9amTS+AJtxO8RGoLD
 DpLjiGOU/HzNTkeziZr6nnjSqjTt1aZzEXtlmxq2PqMKfXZ2FC
 9sRBmBphDRq4qW3sigEQXzTQIFoTktcryM78+T8fVS3CMx9apl
 OtuJnkd5l4YDQy1XgzUzUL6CRzoS6IHTNRxIwoEpwmLeUnAcUt
 GMDjB5/9jNX7MNeGSjcQcvp2rNMxvYzYqa0P0ZkcEOrDVqUbuy
 JNiAWBIrWtiKaVWlJnR4BFxMekKmD891hgm83I54amvkApxTPv
 vTGLLLUsacIZS3KfRZMQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 16:42:46 Murali Karicheri wrote:
> >>
> >>      /* update the Vendor ID */
> >> -    vendor_device_id = readl(ks_pcie->va_reg_pciid);
> >> -    writew((vendor_device_id>>  16), pp->dbi_base + PCI_DEVICE_ID);
> >> +    writew(ks_pcie->device_id, pp->dbi_base + PCI_DEVICE_ID);
> >>
> >>      /* update the DEV_STAT_CTRL to publish right mrrs */
> >>      val = readl(pp->dbi_base + PCIE_CAP_BASE + PCI_EXP_DEVCTL);
> >
> > This change must have slipped in accidentally, at least it's not
> > described in the changelog. Should this be another patch?
> > The change seems useful.
> Are you referring to mrrs or update to device id?  device id is in a SoC 
> register at index2 and is read and updated by the driver here. MRRS 
> update was originally in the code.
> 

I meant the device id change. Maybe you accidentally did 'git commit
--amend' during a rebase and that replaced the real changelog with
the one of the patch in front of it and merged the two patches?

That happened to me a few times and would explain the strange mix
of two changes.

	Arnd
