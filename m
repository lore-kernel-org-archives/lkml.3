Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbaCTS1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:27:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:8610 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaCTS1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:27:31 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-c9-532b33115d5b
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com, b.zolnierkie@samsung.com
Subject: [PATCH v2 0/3] ata: ahci_platform related cleanups
Date: Thu, 20 Mar 2014 19:27:03 +0100
Message-id: <1395340026-3969-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jQV0hY+1gg/utTBYbZ6xntTh3q4HV
	4s3x6UwWd1YwW2x6fI3V4tiOR0wWl3fNYbPY37uByaKhu4fdYs6MzawWv5YfZbRYefEvswOP
	x/VX/5k8ds66y+6xaVUnm8ecaU0sHicvnGTx2Lyk3uP9vqtsHn1bVjF6PP2xl9nj+I3tTB6f
	N8kFcEdx2aSk5mSWpRbp2yVwZXReXMBYsIm74tufK8wNjN85uhg5OCQETCSOnc/sYuQEMsUk
	Ltxbz9bFyMUhJDCdUeLW6bUsIAkhgS4mif43aSA2m4CVxMT2VYwgtoiArMSVaQ8ZQRqYBbqY
	JZbM3sIIMlRYwFpi7oY4kBoWAVWJppmn2EBsXgF3iQ3zTrNCLFOU6H42gW0CI/cCRoZVjKKp
	BckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHB+Ex6B+OqBotDjAIcjEo8vBWc2sFCrIllxZW5hxgl
	OJiVRHiv6QKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0tSC2CyTJxcEo1
	MHox2K/bn/3E7/WNg6F79LXtd4UunZb8ZfLV/q1J9h8nXn2wp3rF9iXRJ3MO75rhWLNnFyeb
	0zr9d8HLLuSGC2mZVSefFxXLOsdgxts4xezn/ckT+1dKZSZE/daemOZ0xtY0NSTek0FP2WDt
	ZuOulrjDTjNXn05zuTNlpnR10PrFczjCbtfzKiuxFGckGmoxFxUnAgD10ptQQgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ v1 was named "ata: add remaining new-style AHCI platform drivers"
  but we are down from 2 drivers to 1 driver so the title of the patch
  series no longer was valid :) ]

Hi,

This patch series:
- fixes ahci_platform_data->suspend() handling
- moves library AHCI platform code to its own file
- adds a new-style AHCI platform driver for DaVinci DA850 AHCI controller

Changes since v1:
- dropped no longer needed patch #4 (ST SPEAr1340 AHCI controller driver)
- adressed review comments for patch #3 from Sekhar Nori
- updated patch descriptions

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

Bartlomiej Zolnierkiewicz (3):
  ata: ahci_platform: fix ahci_platform_data->suspend method handling
  ata: move library code from ahci_platform.c to libahci_platform.c
  ata: add new-style AHCI platform driver for DaVinci DA850 AHCI
    controller

 arch/arm/mach-davinci/devices-da8xx.c |  99 +------
 drivers/ata/Kconfig                   |  14 +-
 drivers/ata/Makefile                  |   9 +-
 drivers/ata/ahci_da850.c              | 116 ++++++++
 drivers/ata/ahci_platform.c           | 508 -------------------------------
 drivers/ata/libahci_platform.c        | 541 ++++++++++++++++++++++++++++++++++
 6 files changed, 681 insertions(+), 606 deletions(-)
 create mode 100644 drivers/ata/ahci_da850.c
 create mode 100644 drivers/ata/libahci_platform.c

-- 
1.8.2.3

