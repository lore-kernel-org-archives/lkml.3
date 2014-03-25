Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaCYSv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:51:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:41161 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbaCYSvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:51:54 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-18-5331d0484325
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com, b.zolnierkie@samsung.com
Subject: [PATCH v4 0/4] ata: ahci_platform related cleanups
Date: Tue, 25 Mar 2014 19:51:37 +0100
Message-id: <1395773501-6663-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t9jAV2PC4bBBq0vVCw2zljPanHuVgOr
	xZvj05ks7qxgttj0+BqrxbEdj5gsLu+aw2axv3cDk0VDdw+7xZwZm1ktfi0/ymix8uJfZgce
	j+uv/jN57Jx1l91j06pONo8505pYPE5eOMnisXlJvcf7fVfZPPq2rGL0ePpjL7PH8RvbmTw+
	b5IL4I7isklJzcksSy3St0vgyji1YA57QSNXxZkjV1gbGJ+zdzFyckgImEhsP3iXCcIWk7hw
	bz1bFyMXh5DAIkaJFZd2QDldTBIfv3xmBaliE7CSmNi+ihHEFhGQlbgy7SEjSBGzQBezxJLZ
	W8ASwgLWEgtmfgGzWQRUJfb93cwMYvMKuEu8mNvLBrFOUaL72QS2CYzcCxgZVjGKphYkFxQn
	peca6hUn5haX5qXrJefnbmIEh+QzqR2MKxssDjEKcDAq8fBOmGAYLMSaWFZcmXuIUYKDWUmE
	9+9JoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQbGrrc/
	Pic87o503+uaWhRU9+HCgvKM3wGs5wUq9JSKnp1aN1EzKLvy44E3J/65mCct3Oa5Qzp/dcqi
	zD1qQuWajmuvvk/523RFbk2slsiXT3N6bb4teZb99dKUvrX1Rzoc9ovO9fsa8iftTewt7e43
	P3gmvp3RvnHHmSUCq4R8cme1ffrtwSZpqsRSnJFoqMVcVJwIAJ+e/3tFAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series:
- fixes ahci_platform_data->suspend() handling
- moves library AHCI platform code to its own file
- adds a new-style AHCI platform driver for DaVinci DA850 AHCI controller
- updates DaVinci DA850 platform code

Changes since v3:
- updated for ahci_xgene

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
  ARM: davinci: da850: update SATA AHCI support

 arch/arm/mach-davinci/da850.c         |   2 +-
 arch/arm/mach-davinci/devices-da8xx.c |  99 +------
 drivers/ata/Kconfig                   |  16 +-
 drivers/ata/Makefile                  |  11 +-
 drivers/ata/ahci_da850.c              | 114 +++++++
 drivers/ata/ahci_platform.c           | 508 -------------------------------
 drivers/ata/libahci_platform.c        | 541 ++++++++++++++++++++++++++++++++++
 7 files changed, 682 insertions(+), 609 deletions(-)
 create mode 100644 drivers/ata/ahci_da850.c
 create mode 100644 drivers/ata/libahci_platform.c

-- 
1.8.2.3

