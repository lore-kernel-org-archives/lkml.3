Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbbAGVSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:18:49 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:53848 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbbAGVSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:18:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Murali Karicheri <m-karicheri2@ti.com>, joro@8bytes.org,
        grant.likely@linaro.org, robh+dt@kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, bhelgaas@google.com,
        linux-pci@vger.kernel.org, will.deacon@arm.com, linux@arm.linux.org.uk
Subject: Re: [PATCH v3 0/4] PCI: get DMA configuration from parent device
Date: Wed, 07 Jan 2015 22:18:35 +0100
Message-ID: <4057859.4ynbgz66iN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com>
References: <1420656594-8908-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:7JaVfOUHT91BZsXuP6EBlWkpGPpwz25bAI0aduYO2NS1XuHoSJ+
 xZAl0lqbBxorIAYRl/74pmJoNDJYsa5WJL7JkEZefVGh1EANszWEUaYLojt1KpOd7LKiVWV
 Z77M0YAyFtWHvL9Z3eMRFV3E39TLe8MFt2ogVLmAkmubBaqpdYduBCr6NT0XPEhNI1CEQY5
 pp4V6aMsedHSGkCxIjZpg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 January 2015 13:49:50 Murali Karicheri wrote:
> PCI devices on Keystone doesn't have correct dma_pfn_offset set. This patch
> add capability to set the dma configuration such as dma-mask, dma_pfn_offset,
> and dma ops etc using the information from DT. The prior RFCs and discussions
> are available at [1] and [2] below.
> 
> [2] : https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg790244.html
> [1] : http://www.gossamer-threads.com/lists/linux/kernel/2024591

Looks all good to me in this version, I'm just unsure about one thing:

>                - Limit the of_iommu_configure to non pci devices

My last recommendation was to pass the b/d/f number into
of_pci_dma_configure to handle this correctly. What was your
reason for not doing it in the end?

We will likely have to change this again if we take your current version,
but that can be a follow-up patch. I believe AMD requires it to use
PCI on their their Seattle platform.

	Arnd
