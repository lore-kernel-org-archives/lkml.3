Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbaJWNsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:48:45 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40172 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaJWNsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:48:39 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-8e-544907343962
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC 0/2] PM and DRM: Add runtime PM to Exynos DSI
Date: Thu, 23 Oct 2014 15:48:08 +0200
Message-id: <1414072090-11293-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t/xa7om7J4hBp079S1urTvHatF77iST
	xcYZ61ktrnx9z2bRvHg9m8Wk+xNYLF7cu8hi8fqFoUXvgqtsFmeb3rBbzJqyl8li0+NrrBaX
	d81hs/jce4TRYsb5fUwWa4/cZbe4e+oom8WZ05dYLWZMfsnmIOyxeM9LJo/t3x6weuyfu4bd
	4373cSaPzUvqPbZcbWfx6NuyitFjxerv7B6fN8kFcEZx2aSk5mSWpRbp2yVwZXQ0t7IUfGOt
	aPk6j7WB8SRLFyMHh4SAicTCGQ5djJxAppjEhXvr2UBsIYGljBKNbWJdjFxAdh+TxOdbi8ES
	bALGEpuXLwGzRQTWs0hcOugFUsQssJ9R4tfdlawgCWEBa4nT626CFbEIqEqc//6aEcTmFXCX
	6G68xAaxTU7i5LHJrBMYuRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAngLzsYFx+z
	OsQowMGoxMNbkewRIsSaWFZcmXuIUYKDWUmEN57VM0SINyWxsiq1KD++qDQntfgQIxMHp1QD
	46rXno9Y+IRENn/+WZRY98rfJiC/S8KX3WzV87V3eIRKTGWrLFLPT5biZf5VbfAs489tqSAz
	kVXe9ad/Sz0XnpB2dd3MO0HpzjfVo3X2+X5k5El6nDv/rHZzu/cF99SXWv9fzxKx8FKyv3Ru
	88tAR609WfdUNda6BLDvSVxx3TzG6tH5gwH7lViKMxINtZiLihMBdRU6/T4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The goal of the patch 2 is to add runtime PM to the Exynos DSI driver.
This allows LCD power domain to be turned off.

However after adding this patch an interesing issue came in. The DSI
driver could not runtime resume during sustem resume because power
domain was not allowed to power on.

The issue is solved by patch 1.

Tested on Trats2 board.

Comments are welcomed.

Best regards,
Krzysztof

Krzysztof Kozlowski (2):
  PM / Domains: Power on domain early during system resume
  drm/exynos/dsi: Add runtime PM so LCD power domain could be turned off

 drivers/base/power/domain.c             | 3 +--
 drivers/gpu/drm/exynos/exynos_drm_dsi.c | 9 +++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

-- 
1.9.1

