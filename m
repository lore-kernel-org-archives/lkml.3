Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaIIVwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:52:47 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57760 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbaIIVwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:52:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bhelgaas@google.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 2/2] PCI: keystone: update to support multiple pci ports
Date: Tue, 09 Sep 2014 23:52:34 +0200
Message-ID: <3967092.l9bxcqMaSa@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <540F75DF.5050904@ti.com>
References: <1410293835-13050-1-git-send-email-m-karicheri2@ti.com> <9042477.aRbAhpkfQ5@wuerfel> <540F75DF.5050904@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Bn9UuzQE1QUyWMVCC6t5A1+3F1zbU3928xvx/cxA+Sd
 sDSdhDz7sZY+L3XgCQNKTtU6d1WNPlUyrOgIOauGC+BB7oA6Bv
 k4Td/2CkS7FNp8vEAfNnCtnn67S4hZAfe3rc8pZZUYXpgqTOl3
 MF4pd/7H6yL4UzzpEVekxm3eItVZJTyLTZILEyEStU7OLBauzP
 ubaNhzcOei5rKsHg3YW/7v/u1juJD5qzc47JO9HXd4D6BVtdWg
 x+oquwAv5cD8tlu2dZXpTFbKyEAzCNb30CjaP+M5ajBn6p90wf
 fOObqqWnAaymprcE0d0RgFz4Xa2NhowrNOvQvbsg5KKrDliS3P
 FbNYWnJd3GaqGfwX8+ok=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 17:49:19 Murali Karicheri wrote:
> Actually this is an inteded. The vendor ID is in a register indicated by
> reg offset and as per the device spec, it needs to be read and updated 
> by the software. Now since multiple instances of PCI device needs to be 
> read the same register, the reading happens in the probe() and same is 
> unmapped after that.
> 
> +       ks_pcie->device_id = readl(reg_p) >> 16;
> +       devm_iounmap(dev, reg_p);
> +       devm_release_mem_region(dev, res->start, resource_size(res));
> 
> Afetr that in ks_pcie_host_init(), it update the device_id in the RC's 
> config space.

I'm not sure I understand the purpose of this. Do you mean you read
the vendor/device ID of whichever device happens to get probed first
and then program the same ID into all other devices as well?

What if the order changes between two boots? Why does the vendor/device
ID of the host bridge even matter at all?

	Arnd
