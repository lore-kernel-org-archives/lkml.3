Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaD1IfC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 04:35:02 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:59261 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbaD1Iex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 04:34:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, prathyush.k@samsung.com, grundler@chromium.org,
        joro@8bytes.org, supash.ramaswamy@linaro.org, tomasz.figa@gmail.com,
        joshi@samsung.com, sachin.kamat@linaro.org, s.nawrocki@samsung.com,
        Varun.Sethi@freescale.com, a.motakis@virtualopensystems.com,
        pullip.cho@samsung.com, t.figa@samsung.com, rahul.sharma@samsung.com
Subject: Re: [PATCH v12 00/31] iommu/exynos: Fixes and Enhancements of System MMU driver with DT
Date: Mon, 28 Apr 2014 10:34:41 +0200
Message-ID: <26065037.GxQQuIURPg@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:d/PX0db28SRE+8CsKXH5zubyKubifUXPm6yHFUuSweW
 9EXZ+FwUcoWAQ0lY04ShnW/PsELaxQTn+icygqylz61ERW3oB5
 /FKYPBkCkrIAgMNw+KDvTKK4zQDIfCl7f6tX2WYW+Ov3Z6KtZi
 X9r8/+kJJHasEXizj0qyWMJsMy8NmkwdjXkEJEwFggrL8Y5jAm
 d2o3POsMh+m0VMLRlIcTlXbAeg0zt+T7M+ymrt87G88+stQjUC
 2eDFp55ekuh1SdISicR5B8fMdTRq5rhyDW9dpdQxzJh6ucHdPv
 hqT17Wf44GsN+0RdS8aPZTYEbnUQMc8O0L2xS0LMIGbtnZYVqs
 39KMFvWxQr8ksZoRKnqI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 April 2014 13:07:32 Shaik Ameer Basha wrote:
> The current exynos-iommu(System MMU) driver does not work autonomously
> since it is lack of support for power management of peripheral blocks.
> For example, MFC device driver must ensure that its System MMU is disabled
> before MFC block is power-down not to invalidate IOTLB in the System MMU
> when I/O memory mapping is changed. Because a System MMU resides in the
> same H/W block, access to control registers of System MMU while the H/W
> block is turned off must be prohibited.
> 
> This set of changes solves the above problem with setting each System MMUs
> as the parent of the device which owns the System MMU to receive the
> information when the device is turned off or turned on.
> 
> Another big change to the driver is the support for devicetree.
> The bindings for System MMU is described in
> Documentation/devicetree/bindings/arm/samsung/system-mmu.txt

Sorry I've been absent from the review so far. Most of the patches
seem entirely reasonable to me, but I'm worried about the DT binding
aspect. We are going to see more systems shipping with IOMMUs now,
and we are seeing an increasing number of submissions for 64-bit
systems. We really have to work out what the DT representation for
IOMMUs should look like in general before adding another ad-hod
implementation that is private to one driver.

	Arnd
