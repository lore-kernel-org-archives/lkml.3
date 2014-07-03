Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbaGCIeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:34:05 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39289 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaGCIeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:34:01 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-3f-53b51572fabb
Message-id: <1404376434.27983.22.camel@AMDC1943>
Subject: drm: Possible NULL ptr exceptions in other DRM drivers
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: David Airlie <airlied@linux.ie>, Thomas Hellstrom <thellstrom@vmware.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, BenSkeggs <bskeggs@redhat.com>,
        RobClark <robdclark@gmail.com>, GerdHoffmann <kraxel@redhat.com>
Date: Thu, 03 Jul 2014 10:33:54 +0200
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t/xq7pFoluDDSaeYrLoPXeSyeLl8g5G
	i4UP7zJbXPn6ns3i2a2TzBaXd81hs3i+8AezxedTx9gcODz2flvA4rFz1l12j+3fHrB63O8+
	zuTxft9VNo/Pm+Q83s1/yxbAHsVlk5Kak1mWWqRvl8CV0bb7PHPBLfaK4z/OMDcwbmXrYuTk
	kBAwkfj8dQ8LhC0mceHeerC4kMBSRonHB8S6GLmA7M+MEu27LzOCJHgFDCRmfD3PBGILC9hL
	NDxcAWazCRhLbF6+hA2kQURgDpPEjw2N7CAJFgFViXsd78CmMguoS0yat4gZYpuyxLz9x5gg
	hgpK/Jh8jwWiRl5i85q3zBMYeWchaZmFpGwWkrIFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS
	83M3MUKC98sOxsXHrA4xCnAwKvHwNq7YECzEmlhWXJl7iFGCg1lJhHf65i3BQrwpiZVVqUX5
	8UWlOanFhxiZODilGhi7tu85uVHmWqVWgv15q+CES69U6v/fPpvBdCinMnudlcj1O4UGXnyL
	Y1+Gbd+lxtNqeE1iw7bTmtYnX8h2Le+eXSOdmx90ZOFM3oKU29KGH6zCM25w3Zw098C6nd2F
	jSeuKD6sytklclzROv3L0e0NAbe7th/xktu1K/Gd4ca+HY+s1xzQ/tmtxFKckWioxVxUnAgA
	asB/2DwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In Exynos DRM driver I found a NULL pointer exception when there were no
components set for DRM driver:
https://lkml.org/lkml/2014/6/30/331

The NULL pointer will happen during driver suspend if drm_driver.load()
is not called. The load() won't be called if no components are added.

After looking at other DRM drivers it seems that they may also be
affected by this issue. Some possible candidates (for my amateur's eyes)
are:
1. vmwgfx/vmwgfx_drv.c (vmw_pci_suspend: dereference of 'dev_priv')
2. qxl/qxl_drv.c (qxl_drm_freeze: dereference of 'qdev')
3. nouveau/nouveau_drm.c (nouveau_do_suspend: dereference of 'drm')
4. msm/msm_drv.c (msm_pm_suspend: dereference of 'ddev')
5. cirrus/cirrus_drv.c (cirrus_pm_suspend: dereference of 'cdev')
6. bochs/bochs_drv.c (bochs_pm_suspend: dereference of 'bochs')

Unfortunately I am not familiar with DRM drivers and I do not have
hardware to test it.

Maybe it is worth looking at?

Best regards,
Krzysztof

