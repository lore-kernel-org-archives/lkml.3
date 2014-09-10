Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaIJIWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:22:47 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:53040 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaIJIWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:22:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        bhelgaas@google.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 2/2] PCI: keystone: update to support multiple pci ports
Date: Wed, 10 Sep 2014 10:22:36 +0200
Message-ID: <3814561.AbrslYBNjb@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <540F8425.70304@ti.com>
References: <1410293835-13050-1-git-send-email-m-karicheri2@ti.com> <3967092.l9bxcqMaSa@wuerfel> <540F8425.70304@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:2AXh9JVxY7IDGQe3xiZX9Hxkt1Cko88vQunvDG3yuHh
 IDD1Q1QVooVSkzrAeAS+Q6GtwGIKPnvMceHwgjvp08616VWfFY
 uRA/K3dEgKGO8YTsWj4lTqK0z3i6lwEMn4dHqYAlMISDKatYfP
 lhuIo3Az4+Cl4R7O3/4bf5C13hWquTlG+xT+flxDO9ZLVrybn8
 kAOkj8Bv/zWDL+p/Lh3vAGV86JnGh6Hc6hrlp3Zmt9/tFzPrq/
 +uiQtpFuwmfL0S66tZ7ANk3i6elpPU7m1vXJWyG3w77wer1NMP
 inX8dselA8doNrJP1VmiED8Gx6soqIZa2ceLRDthhzw1B2WAvl
 RabRQ1bkJ8CDgF/y7IPY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 18:50:13 Murali Karicheri wrote:
> My mistake. It is the device ID, not vendor ID. The PCI driver supports 
> PCI h/w on K2HK, K2E and K2L SoCs for which PCI device IDs are assigned as
> 
> +#define PCIE_RC_K2HK           0xb008
> +#define PCIE_RC_K2E            0xb009
> +#define PCIE_RC_K2L            0xb00a
> +
> 
> and the same driver code runs on all these h/w. The device ID is not 
> filled in by default by the h/w, in the config space of the RC at offset 
> 1000h "VENDOR_DEVICE_ID Vendor and Device Identification Register". 
> Same is available in a seperate SoC register whose offset is specified 
> by index 2. This is read by driver and updated in the config space. The 
> Vendor ID is however set by default.
> 
> There is a mrrs PCI quirk required for Keystone PCI which depends on 
> this vendor ID to be filled correctly as it match vendor id/ device id 
> of the bridge device to apply the quirk.
> 
> Hope this clarify your question.

Ok, I understand now. Yes, this makes sense, though I wonder if it would
have been easier to handle the quirk in a different way based on the
driver rather than the PCI ID. It's probably not worth revisiting though,
unless Bjorn wants to see it done differently now.

	Arnd
