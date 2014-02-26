Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaBZFIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:08:07 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35735 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaBZFID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:08:03 -0500
X-AuditID: cbfee68f-b7f156d00000276c-1d-530d76b192e0
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 0/3] introduce new config option for samsung common clock
Date: Wed, 26 Feb 2014 14:24:04 +0900
Message-id: <1393392247-6247-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zI92NZbzBBn+PaVtsenyN1eLyrjls
	FjPO72OyWLT1C7sDi8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTH962WWgrtsFY/m
	7GJsYJzL2sXIySEhYCLRf7qPDcIWk7hwbz2YLSSwjFHi4ywbmJqFv5YxdzFyAcUXMUp0zFvB
	COG0MUnMnt/GDlLFJqAr8eT9XGYQW0QgW+LSrFssIDazgLbE5L0tYDXCAp4Svy5tAbNZBFQl
	pu7cDbaNV8BdYsWF3UBDOYC2KUjMmWQDMl9C4D6bxNKjE5kg6gUkvk0+xAJRIyux6QAzxHGS
	EgdX3GCZwCi4gJFhFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZIAPbvYLx7wPoQYzLQuInM
	UqLJ+cAAziuJNzQ2M7IwNTE1NjK3NCNNWEmc9/7DpCAhgfTEktTs1NSC1KL4otKc1OJDjEwc
	nFINjNaPzP5vXl534e+bsykMOwJSovw3aHdJ7D1p3r7oiEfL/+SFFupnjz7wNn/Qttzx0eLS
	N39KTlxd7c19zb2/fL34rIkOHeGcdbvjzskvenLgb9Zz7xN7LC8lrQla78pzLG9KYCXj1P1O
	/S/XiE5JT7AK1Vns08TJP10j0L/LiN3x3t3D4e9UopRYijMSDbWYi4oTAXExYGBWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd2NZbzBBu/Pq1tsenyN1eLyrjls
	FjPO72OyWLT1C7sDi8fmJfUefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5gx/etlloK7bBWP5uxibGCcy9rFyMkhIWAisfDXMmYIW0ziwr31bF2MXBxC
	AosYJTrmrWCEcNqYJGbPb2MHqWIT0JV48n4uWIeIQLbEpVm3WEBsZgFticl7W8BqhAU8JX5d
	2gJmswioSkzduZsNxOYVcJdYcWE30FAOoG0KEnMm2Uxg5F7AyLCKUTS1ILmgOCk910ivODG3
	uDQvXS85P3cTIzjAn0nvYFzVYHGIUYCDUYmHN4CFN1iINbGsuDL3EKMEB7OSCK90NlCINyWx
	siq1KD++qDQntfgQYzLQ8onMUqLJ+cDoyyuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpi
	SWp2ampBahHMFiYOTqkGRulDawvE1rc8mF+Y+0nV5cXDpa8TXG/JvF5x3PZiDU9o11x1oVdB
	agK1VXLKryYwnEs6I9wpGMWyRufhugPVB2b1in463M14yZyhec2iT8c+iudNnP/h1Oetcz+f
	8G8sbU5U3H/9e5bnt+6vtX3bN+dUa0xnX6bynN88d+GduNLfm/Uqkl4fXKfEUpyRaKjFXFSc
	CABOm+3mtAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces a new config option for Samsung
common clock infrastructure as COMMON_CLK_SAMSUNG. As current
samsung common clock gets compiled based on PLAT_SAMSUNG, but moving 
ahead with ARM64 we can not have any more such config options, so 
better we introduce new COMMON_CLK_SAMSUNG and make it dependent
on existing ARCH_XXXX which needs SAMSUNG common clock infrastructure, also
on ARM64.

Pankaj Dubey (3):
  drivers: clk: add samsung common clock config option
  ARM: select COMMON_CLK_SAMSUNG for ARCH_EXYNOS and ARCH_S3C64XX
  ARM: S3C24XX: select COMMON_CLK_SAMSUNG for S3C24XX

 arch/arm/Kconfig              |    2 ++
 arch/arm/mach-s3c24xx/Kconfig |    3 +++
 drivers/clk/Kconfig           |   10 ++++++++++
 drivers/clk/Makefile          |    2 +-
 4 files changed, 16 insertions(+), 1 deletion(-)

-- 
1.7.9.5

