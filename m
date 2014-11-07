Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaKGNyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:54:19 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17574 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaKGNyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:54:15 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-29-545ccf0425f7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Inki Dae <inki.dae@samsung.com>, Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, Kukjin Kim <kgene.kim@samsung.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 0/2] DRM: Add runtime PM to Exynos DSI
Date: Fri, 07 Nov 2014 14:53:57 +0100
Message-id: <1415368439-23642-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xy7os52NCDK5+MbO4te4cq0XvuZNM
	FhtnrGe1uPL1PZvFyiksFpPuT2CxeHHvIovF6xeGFr0LrrJZPN38mMnibNMbdotNj6+xWlze
	NYfNYsb5fUwWa4/cZbeYMfklm4OAx6ZVnWwe2789YPW4332cyWPzknqPvi2rGD2O39jO5PF5
	k1wAexSXTUpqTmZZapG+XQJXxoEpagUd7BV9H1qZGhhPsXYxcnJICJhInPi/AsoWk7hwbz0b
	iC0ksJRR4sJ19i5GLiC7j0niw7tnYEVsAsYSm5cvYQNJiAh8Z5KY8mQ9O0iCWWAKk8TUMxUg
	trCApcSlx/9YQGwWAVWJ3YsWg03lFXCXOLpsJdQ2OYmTxyazTmDkXsDIsIpRNLU0uaA4KT3X
	SK84Mbe4NC9dLzk/dxMjJBi/7mBceszqEKMAB6MSD+8DkZgQIdbEsuLK3EOMEhzMSiK8N44D
	hXhTEiurUovy44tKc1KLDzEycXBKNTBa6lmG+ul4s2yPbZMR9NINmdufYm3I+0gn7+VqKyk2
	q82as3U9nZl3Re25zvxgyZtTzaWNf+Q2Rimy/5VW5AkV/bHbYcnet/v04raFh6/wv8bHtoWh
	2OpY5g5GO74Js56ZiEst4ExPO6t02Pw9V5wF82Lea/OV1h4y3nRAZecxG4NfnzXmMCqxFGck
	GmoxFxUnAgAm6OrZJAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Changes since v1
================
1. Replace patch 1 changing PM core with fix only for DRM exynos driver.

Description
===========
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
  drm/exynos: Fix DSI resuming fail because power domain being off
  drm/exynos/dsi: Add runtime PM so LCD power domain could be turned off

 drivers/gpu/drm/exynos/exynos_drm_drv.c | 2 --
 drivers/gpu/drm/exynos/exynos_drm_dsi.c | 9 +++++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

-- 
1.9.1

