Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaA2PF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 10:05:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62893 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaA2PFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 10:05:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Vinod Koul <vinod.koul@intel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Gross <agross@codeaurora.org>,
        dmaengine@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch v3 2/2] dmaengine: qcom_bam_dma: Add device tree binding
Date: Wed, 29 Jan 2014 16:05:22 +0100
Message-ID: <21038487.ygragjUUsd@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140128121656.GH15937@n2100.arm.linux.org.uk>
References: <1390890471-14882-1-git-send-email-agross@codeaurora.org> <9156959.vu4XdoKglI@wuerfel> <20140128121656.GH15937@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZgA9Ab5RVHj+V/VGScmaTbW1Mc5P7RsBNPGILg1vvHD
 45geW+94fEjDS4zGg7YEZ7GI3+EbGAw3GBfEdfi5i8JKlAYGwU
 bCdEhYr/ZtlsZyRm8Iyo1+Zcu1QBDQq5rVLXa1EmJixdGbFmrP
 DkJeBW8CBQbcXakjVHbtjWmzBgqNr5mlSYiA58d5RaGclGjuFD
 b8TAlGLzlAXK9K82BNRVtRl8jboWk6xtfBz2K+6O0hlMctkLA2
 83abeL3Mzy6kdowvaSIKsVInFo9anDtHh3o+8yNnkCcbVHaIzl
 G6//Hx/zxLI2lJQ+ky4pOMAUAl2PTeEOrk0Bcf3+WALY/7ouOJ
 Nsd8Kpw+3hZA25gVvmMI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 January 2014 12:16:56 Russell King - ARM Linux wrote:
> On Tue, Jan 28, 2014 at 01:08:47PM +0100, Arnd Bergmann wrote:
> 
> On balance, I think the virtual channel approach makes client drivers
> more elegant and simpler, and makes the DMA engine API easier to use,
> and gives greater flexibility for future improvements.  So, I wouldn't
> miss the slave_id being removed.

Ok, good. There are some dmaengine drivers that actually behave
in hardware like the virtual-channel extension, i.e. they have
one physical channel per request line (qcom_bam_dma seems to be
one of them in fact), so they don't really have a choice.

The way that both the DT and ACPI bindings are structured,
the request ID is always known by the time the channel is
allocated to allow this model, and that means supporting both
approaches in the same master or slave driver is a mess.

	Arnd
