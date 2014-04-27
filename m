Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbaD0SXY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 14:23:24 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:57178 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaD0SXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 14:23:22 -0400
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
Subject: Re: [PATCH v12 11/31] documentation: iommu: add binding document of Exynos System MMU
Date: Sun, 27 Apr 2014 20:23:06 +0200
Message-ID: <4447051.OnJtcFSqFV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1398584283-22846-12-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com> <1398584283-22846-12-git-send-email-shaik.ameer@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:EeCaOzy/He0jUxd3FawbK3sQk7JfoiSbNPEoIvQqmLd
 Yn6ZGMLW6PuIjveDV+LsaaBj0xC5hZko3U77LKg2vJedbKaDEP
 AAGtUw+mV2gr0nCiZSZgsolCZoLCuEULv6ryk+RT+oSNxgG+Np
 bEp1JdQTzSpBZRdb3V/hlwi2DPVFujSKn8L9v1GPIoO9q+nV8D
 Cir9/EPHYYpKe7h3R5x13qyNLObmZPEpGGpUp/lxpOIvM5eUN8
 UU2iZeIAjtEz4IzyisMSzXgwZO4fYSY9g3zuEGJi9DZaWFNlC5
 1gMydKgbuhmmXlPKY2N+yD+JBJKyLrN6qi17RoWVFYfwsbzmTI
 4Jg8w8zDFvk2F7c8gDrQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 April 2014 13:07:43 Shaik Ameer Basha wrote:
> +- mmu-masters: A phandle to device nodes representing the master for which
> +               the System MMU can provide a translation. Any additional values
> +              after the phandle will be ignored because a System MMU never
> +              have two or more masters. "#stream-id-cells" specified in the
> +              master's node will be also ignored.
> +              If more than one phandle is specified, only the first phandle
> +              will be treated.

This seems completely backwards: Why would you list the masters for an IOMMU
in the IOMMU node?

The master should have a standard property pointing to the IOMMU instead.

We don't have a generic binding for IOMMUs yet it seems, but the time is
overdue to make one.

Consider this NAKed until there is a generic binding for IOMMUs that all
relevant developers have agreed to.

	Arnd
