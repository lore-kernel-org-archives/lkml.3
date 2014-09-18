Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbaIRP2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:28:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29133 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbaIRP2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:28:11 -0400
X-AuditID: cbfee61a-f79e46d00000134f-ea-541afa08f2ee
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 00/33] thermal: exynos: convert the driver to use per-SoC type
 operations
Date: Thu, 18 Sep 2014 17:27:17 +0200
Message-id: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjluLIzCtJLcpLzFFi42I5/e+xgC7nL6kQg5WbWCwaroZYbJyxntXi
	7vPDjBbzr1xjtTjb9Ibd4s3DzYwWl3fNYbP43HuE0WLG+X1MFk8e9rE5cHnsnHWX3WPxnpdM
	Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXxcFIje8FCmYqJCy+yNTDuFu9i5OSQEDCRuH5u
	FSuELSZx4d56ti5GLg4hgUWMEtsWv2GEcLqYJLa9u8wOUsUmYCUxsX0VI4gtIqAlceLSdiaQ
	ImaBW0wSr29MBksIC0RLnLneCWazCKhKHLh3kwXE5hXwkHj77BELxDpFie5nE9gmMHIvYGRY
	xSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcOs+kdjCubLA4xCjAwajEw3uAVypEiDWxrLgy
	9xCjBAezkgjvn49AId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJM
	HJxSDYyCb77V6Aml7E2fY1aYsXmBZ3J3J9cV4dq/sotmVIS/XMDe8//8X66c1Qt+5yn88/fx
	u/Bj7RzOj/+aaqcsS/+jsemlXEip/RLdBhaHXbPEDJZwnO6Ruu3GY7P6ynHOtReUzvMfijF/
	URnAVlzYvrZb+0ai+69ozpLNN14F8gW2T916ckL/5hIlluKMREMt5qLiRABymVWqGQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series replaces the hardware registers abstractions in
the Exynos thermal driver by the usage of per-SoC type operations.
Such solution provides simpler, easier to understand code and
allows removal of ~250 LOCs (~11% of the whole source code) from
the driver.  Some other driver improvements are now also possible
thanks to these changes but are scheduled at later time (like
consolidating code for clearing IRQs using INTCLEAR register).

The patchset should not cause any functionality changes.  This
means that unless there are some bugs in the patches itself there
should be no behavior changes for the driver (this also includes
lack of changes in the way hardware is accessed by the driver).

All testing was done on (Exynos4412 SoC based) ODROID U3 board
(some additional patches are needed to make the Exynos thermal
driver work on this hardware).

Depends on:
- 'next' branch of linux-soc-thermal.git kernel tree from Eduardo
- [PATCH] thermal: exynos: use correct offset for TMU_CONTROL
  register on Exynos5260
  (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg36529.html)

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (33):
  thermal: exynos: remove needless triminfo_data abstraction
  thermal: exynos: remove needless tmu_status abstraction
  thermal: exynos: remove needless threshold_temp abstraction
  thermal: exynos: remove needless triminfo_ctrl abstraction
  thermal: exynos: remove needless test_mux_addr_shift abstraction
  thermal: exynos: remove needless therm_trip_[mode,mask]_shift
    abstractions
  thermal: exynos: remove needless therm_trip_en_shift abstraction
  thermal: exynos: remove needless emul_temp_shift abstraction
  thermal: exynos: remove needless emul_time_shift abstraction
  thermal: exynos: replace tmu_irqstatus check by Exynos5440 one
  thermal: exynos: replace tmu_pmin check by Exynos5440 one
  thermal: exynos: simplify HW_TRIP level setting
  thermal: exynos: replace threshold_falling check by Exynos SoC type
    one
  thermal: exynos: remove TMU_SUPPORT_READY_STATUS flag
  thermal: exynos: remove TMU_SUPPORT_TRIM_RELOAD flag
  thermal: exynos: add sanitize_temp_error() helper
  thermal: exynos: add get_th_reg() helper
  thermal: exynos: add ->tmu_initialize method
  thermal: exynos: add get_con_reg() helper
  thermal: exynos: add ->tmu_control method
  thermal: exynos: add ->tmu_read method
  thermal: exynos: add get_emul_con_reg() helper
  thermal: exynos: add ->tmu_set_emulation method
  thermal: exynos: add ->tmu_clear_irqs method
  thermal: exynos: remove TMU_SUPPORT_FALLING_TRIP flag
  thermal: exynos: remove TMU_SUPPORT_EMUL_TIME flag
  thermal: exynos: remove TMU_SUPPORT_EMULATION flag
  thermal: exynos: remove TMU_SUPPORT_ADDRESS_MULTIPLE flag
  thermal: exynos: remove TMU_SUPPORT_MULTI_INST flag
  thermal: exynos: remove test_mux pdata field
  thermal: exynos: remove SoC type ifdefs
  thermal: exynos: remove __EXYNOS5420_TMU_DATA macro
  thermal: exynos: remove exynos_tmu_data.h include

 drivers/thermal/samsung/exynos_thermal_common.h |   1 -
 drivers/thermal/samsung/exynos_tmu.c            | 706 +++++++++++++++++-------
 drivers/thermal/samsung/exynos_tmu.h            | 131 +----
 drivers/thermal/samsung/exynos_tmu_data.c       | 260 +--------
 drivers/thermal/samsung/exynos_tmu_data.h       | 174 ------
 5 files changed, 509 insertions(+), 763 deletions(-)
 delete mode 100644 drivers/thermal/samsung/exynos_tmu_data.h

-- 
1.8.2.3

