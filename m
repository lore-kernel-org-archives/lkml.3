Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbaCYR2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:28:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10665 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153AbaCYR0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:26:38 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-64-5331bc4c2de3
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com, b.zolnierkie@samsung.com
Subject: [PATCH v3 0/4] ata: ahci_platform related cleanups
Date: Tue, 25 Mar 2014 18:26:11 +0100
Message-id: <1395768375-21123-1-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrELMWRmVeSWpSXmKPExsVy+t9jAV2fPYbBBmfniFtsnLGe1eLcrQZW
	izfHpzNZ3FnBbLHp8TVWi2M7HjFZXN41h81if+8GJouG7h52izkzNrNa/Fp+lNFi5cW/zA48
	Htdf/Wfy2DnrLrvHplWdbB5zpjWxeJy8cJLFY/OSeo/3+66yefRtWcXo8fTHXmaP4ze2M3l8
	3iQXwB3FZZOSmpNZllqkb5fAlbFj+TPmghNcFV233zM3MC7k6GLk5JAQMJHo+n2fHcIWk7hw
	bz1bFyMXh5DAIkaJt483MkI4XUwSn+ZeYQKpYhOwkpjYvooRxBYRkJW4Mu0hWBGzQBezxJLZ
	W8ASwgLWEou3fABrYBFQldjYuh8szivgIbH24XYWiHWKEt3PJrBNYORewMiwilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4JJ9J7WBc2WBxiFGAg1GJh3fCBMNgIdbEsuLK3EOMEhzMSiK8
	ChuAQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhizjkW/
	/8XPEnPhiXsUW7vfcjemyKCPmytnyMwI4Jd/etmkwveJDivnV7sMtrpn0ot8vK8ua/u56vK3
	G884JzWv3uee8yKfr2jO80ff2yfsNMvZ7BLMdzJry3d2A1fXrpqj4fEefguK28qlvK6ab97/
	nLfMrHOmy6pZhcK9Js9OW548fe2Ka6wSS3FGoqEWc1FxIgCAK9qcRQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series:
- fixes ahci_platform_data->suspend() handling
- moves library AHCI platform code to its own file
- adds a new-style AHCI platform driver for DaVinci DA850 AHCI controller
- updates DaVinci DA850 platform code

Changes since v2:
- merged changes from Sekhar
- splitted out DaVinci DA850 platform changes into separate patch

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
 drivers/ata/Kconfig                   |  14 +-
 drivers/ata/Makefile                  |   9 +-
 drivers/ata/ahci_da850.c              | 114 +++++++
 drivers/ata/ahci_platform.c           | 508 -------------------------------
 drivers/ata/libahci_platform.c        | 541 ++++++++++++++++++++++++++++++++++
 7 files changed, 680 insertions(+), 607 deletions(-)
 create mode 100644 drivers/ata/ahci_da850.c
 create mode 100644 drivers/ata/libahci_platform.c

-- 
1.8.2.3

