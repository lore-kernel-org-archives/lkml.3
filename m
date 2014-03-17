Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbaCQScS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 14:32:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:19937 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbaCQScO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 14:32:14 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-91-53273facdcf0
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com, b.zolnierkie@samsung.com
Subject: [PATCH 0/4] ata: add remaining new-style AHCI platform drivers
Date: Mon, 17 Mar 2014 19:31:54 +0100
Message-id: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t9jQd019urBBt0LlS02zljPanHuVgOr
	xZ0VzBabHl9jtTi24xGTxeVdc9gs9vduYLJo6O5ht5gzYzOrxa/lRxktVl78y+zA7XH91X8m
	j52z7rJ7bFrVyeYxZ1oTi8fJCydZPDYvqffo27KK0ePpj73MHsdvbGfy+LxJLoArissmJTUn
	syy1SN8ugStj0/rqgpvcFYeXT2JtYDzC2cXIySEhYCLROO8KM4QtJnHh3nq2LkYuDiGB6YwS
	J3raWCGcLiaJNbM+soJUsQlYSUxsX8UIYosIyEpcmfaQEaSIWeAxk8TOlVPYQRLCAu4Svz/u
	ZAOxWQRUJRacfwrWwCvgITHv9TkWiHWKEt3PJrBNYORewMiwilE0tSC5oDgpPddIrzgxt7g0
	L10vOT93EyM4+J5J72Bc1WBxiFGAg1GJh/cFm3qwEGtiWXFl7iFGCQ5mJRFeCROgEG9KYmVV
	alF+fFFpTmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBsatvV45cm4LLSq4Dv+K
	YzO5KfLrcMvNyYrn7pbPljx7LmZtBddT33kxq51ndu15lrH6q+eH0hTZuJs8VzUC097OSfZ9
	ufTtt/VFch4aOf+m7tjodOGNg/S0zxJtv8yv6Bc6nfy4cOve1iMN9X1WSXOvb7N+4nMvdlf2
	yjPMilc3CVReOiUjnXVLiaU4I9FQi7moOBEAvdcKNjoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series adds new-style AHCI platform drivers for DaVinci DA850
AHCI controller and ST SPEAr1340 AHCI controller.  As a preparation for
adding these drivers it also fixes ahci_platform_data->suspend() handling
(patch #1) and moves library AHCI platform code to its own file (patch #2).
The new AHCI platform drivers are only compile tested (they are marked as
experimental because of this) and I would ask somebody with the hardware
to verify them (thanks!).

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics


Bartlomiej Zolnierkiewicz (4):
  ata: ahci_platform: fix ahci_platform_data->suspend method handling
  ata: move library code from ahci_platform.c to libahci_platform.c
  ata: add new-style AHCI platform driver for DaVinci DA850 AHCI
    controller
  ata: add new-style AHCI platform driver for ST SPEAr1340 AHCI
    controller

 drivers/ata/Kconfig            |  23 +-
 drivers/ata/Makefile           |  10 +-
 drivers/ata/ahci_da850.c       | 178 ++++++++++++++
 drivers/ata/ahci_platform.c    | 508 --------------------------------------
 drivers/ata/ahci_spear1340.c   | 222 +++++++++++++++++
 drivers/ata/libahci_platform.c | 541 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 967 insertions(+), 515 deletions(-)
 create mode 100644 drivers/ata/ahci_da850.c
 create mode 100644 drivers/ata/ahci_spear1340.c
 create mode 100644 drivers/ata/libahci_platform.c

-- 
1.8.2.3

