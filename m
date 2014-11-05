Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbaKEIdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:33:49 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58068 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaKEIdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:33:44 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-81-5459e0e612ef
Message-id: <1415176420.15850.5.camel@AMDC1943>
Subject: Re: [PATCH 5/6] regulator: max77686: Remove support for board files
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Date: Wed, 05 Nov 2014 09:33:40 +0100
In-reply-to: <20141104204647.GE3815@sirena.org.uk>
References: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
 <1415090986-30623-6-git-send-email-k.kozlowski@samsung.com>
 <20141104204647.GE3815@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xq7rPHkSGGDSs5LDYOGM9q8XUh0/Y
	LI7+LrA42/SG3eL+16OMFt+udDBZXN41h81i7ZG77Banu1kdOD3+Pr/O4rFz1l12j02rOtk8
	7lzbw+Yx72SgR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGUcPNTGVrCUu2LJBusGxj8cXYyc
	HBICJhKndzczQ9hiEhfurWfrYuTiEBJYyihx4N4xFgjnM6PEqrN9LCBVvAL6ElMufWYFsYUF
	fCROnvnLBmKzCRhLbF6+BMwWEVCWuPp9L1g9s8BDJokHm2pBbBYBVYmXvV/BtnEKGElsurwI
	asFaRomFk3exQTSoS0yatwioiAPoJGWJxn43iL2CEj8m34OaKS+xec1b5gmMArOQdMxCUjYL
	SdkCRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCFx8GUH4+JjVocYBTgYlXh4PZoiQ4RY
	E8uKK3MPMUpwMCuJ8HJeAgrxpiRWVqUW5ccXleakFh9iZOLglGpgnLYhq/MAf8BKMc1qxRdf
	DFY6ysye+8y7cMbcV0Zr6kuTRLO19vlozjyowhn09Fvstp//DR59mxHSdy7po2Tvtza1pYeu
	GejsWnaAz+Zgx6acVLuF0Rt36uwPOjvhC1PJ0Wf9C1pFuI9uD9QT+puy4H6AyPkK9q3ljCxF
	/wIZNFmF+3W3XxFrVWIpzkg01GIuKk4EAPqYq0ZhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-11-04 at 20:46 +0000, Mark Brown wrote:
> On Tue, Nov 04, 2014 at 09:49:45AM +0100, Krzysztof Kozlowski wrote:
> > The driver is used only on Exynos based boards with DTS support.
> > Simplify the driver and remove dead (unused) entries in platform_data
> > structure.
> 
> This mostly isn't actually removing platform data support as far as I
> can see?  It's removing some spurious error checks for missing platform
> data (which is good) and converting to use the core DT parsing (which is
> also good) but just leaving this:
> 
> > -       struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
> 
> > -               config.init_data = pdata->regulators[i].initdata;
> 
> would keep platform data support there.  What problem is removing
> platform data support solving?

There isn't specific problem to solve. The purpose here is to remove
legacy and old code which really is not used. On Samsung boards with
mainline kernel the platform data is not used for a long, long time.

On our vendor kernels (for example these published on
opensource.samsung.com for Android and Tizen devices) this driver is not
used... because whole kernel is different and all drivers for Samsung
specific stuff (SoC, PMIC, sensors, LCD etc.) are developed by vendor.

In my humble opinion there aren't any users of this code. Removing it
helps in maintaining the driver.

Best regards,
Krzysztof


