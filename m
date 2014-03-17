Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249AbaCQMoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:44:06 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20499 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201AbaCQMnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:43:55 -0400
X-AuditID: cbfee68f-b7f156d00000276c-7e-5326ee09c8f8
From: Chanwoo Choi <cw00.choi@samsung.com>
To: dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RFC PATCH 0/4] power_supply: Add DT helper function to get
 power-supply dev from dt
Date: Mon, 17 Mar 2014 21:43:43 +0900
Message-id: <1395060227-23378-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWyRsSkWJfznVqwwZ4dChbXvzxntZj05D2z
	xcSVk5ktzja9Ybe4vGsOm8XtxhVsDmweO2fdZffYvELLo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDK2zJnKWDBBrGLusdvMDYz9gl2MnBwSAiYSD67+ZoKwxSQu3FvPBmILCSxllHi8wBem
	5vydD8xdjFxA8emMEtNnbWGHcBqZJN6/X8wOUsUmoCWx/8UNsG4RAV2Jmz2XweLMArUS+641
	sYLYwgLxEhu3/mQEsVkEVCV+7V4HZvMKuEqcblzDDrFNTuLDnkdgCyQE3rNJHLnZzArRICDx
	bfIhli5GDqCErMSmA8wQ9ZISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6kbFecWJucWleul5yfu4m
	RmCAnv73rH8H490D1ocYk4HGTWSWEk3OBwZ4Xkm8obGZkYWpiamxkbmlGWnCSuK89x8mBQkJ
	pCeWpGanphakFsUXleakFh9iZOLglGpgtJJVknTP/NhbbhChezptJhNvrdaXN3wpgapM9224
	3uxbzcjE/efmvnm9D2v1uSc36CicFCkI3r5tIY/DtTi7zmklyWult+8PVee37OVoN8pxmyu1
	7V9bW+WO6SprM7LuJURn2t8ROr+L8ezvey46FwuTMgV0f/DMV4nVePZ/q5tL66LmlOVKLMUZ
	iYZazEXFiQD9yXfEZgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jQV3Od2rBBpe3SFhc//Kc1WLSk/fM
	FhNXTma2ONv0ht3i8q45bBa3G1ewObB57Jx1l91j8wotj74tqxg9Pm+SC2CJamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM2DJnKmPBBLGKucduMzcw9gt2MXJySAiYSJy/
	84EZwhaTuHBvPVsXIxeHkMB0Ronps7awQziNTBLv3y9mB6liE9CS2P/iBhuILSKgK3Gz5zJY
	nFmgVmLftSZWEFtYIF5i49afjCA2i4CqxK/d68BsXgFXidONa9ghtslJfNjziH0CI/cCRoZV
	jKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMER8Ex6B+OqBotDjAIcjEo8vBOU1YKFWBPLiitz
	DzFKcDArifBqvQUK8aYkVlalFuXHF5XmpBYfYkwG2j6RWUo0OR8YnXkl8YbGJmZGlkbmhhZG
	xuakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwLixvX+j/4VnMtlt2y5r7ep0i3snYSj7
	Xnj1XkeHf6uyJb3KxTw+K0aGSyb2z57gVXjaWr3odq5i1c7Jpc/LNj6PDT2ise6d6XfD0hXy
	ZhN2rVqovuq0evSfnLWW2i0NSwPWebyb3CQTfPjNZkkh5uwQi/lSrxcs5J6UGDDH6IR3Vvmn
	WFWRiUosxRmJhlrMRcWJAB6Mq4jEAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add DT helper function to get power-supply device from devicetree.
- of_power_supply_get_dev(struct device *dev, enum power_supply_dev_type type,
			  int index)
Power-supply class provides 'power_supply_get_by_name()' to users who want to
find power-supply device with the name of power-supply device.

If CONFIG_OF is enabled, device drivers which want to get power-supply device
would directly get the power-supply device from devicetree by using of_power_
supply_get_dev(). This function can be used instead of power_supply_get_by_name().

For example,

[After]
	The charger-manager must need the power-supply device of fuelgauge to
	read the battery capacity. The charger-manager dt don't need to consider
	the name of power-supply device for fuelgauge because of only needing
	phandle of fuelgauge power-supply device.

	fuelgauge0: max17047@36 {
		compatible = "maxim,max17047";
		interrupt-parent = <&gpx2>;
		interrputs = <3 2>;
		reg = <0x36>;
	};

	charger-manager@0 {
		compatible = "charger-manager";
		...
		fuel-gauge = <&fuelgauge0>;	/* Need phandle of fuelgauge
						 phandle name is always same. */
		...
	};

[Before]
	Previous way use the name of fuelgauge power-supply device to get
	fuel-gauge device using power_supply_get_by_name(). If change the name
	of fuelgauge device, we have to modify both fuelgauge dt and charger-
	manager dt. The charger-manager has dependency on the name of fuel-gague
	power-supply device.

	max17047@36 {
		compatible = "maxim,max17047";
		interrupt-parent = <&gpx2>;
		interrputs = <3 2>;
		reg = <0x36>;
	};

	charger-manager@0 {
		compatible = "charger-manager";
		...
		cm-fuel-gauge = "max170xx_battery";	/* Need the name of fuel-gauge */
		...
	};


Chanwoo Choi (4):
  power_supply: of: Add an API to get power_supply device from dt node
  charger-manager: Get power_supply device using of_power_supply_get_dev()
  Documentation: dt: charger-manager: Change the way to get fuel-gauge power-supply device
  max17042_battery: Change battery name instead of static name according to device type

 .../bindings/power_supply/charger-manager.txt      |  8 ++-
 drivers/power/Kconfig                              |  4 ++
 drivers/power/Makefile                             |  2 +
 drivers/power/charger-manager.c                    | 22 ++++--
 drivers/power/max17042_battery.c                   |  2 +-
 drivers/power/of_power_supply.c                    | 82 ++++++++++++++++++++++
 include/linux/power/charger-manager.h              |  2 +
 include/linux/power/of_power_supply.h              | 46 ++++++++++++
 8 files changed, 159 insertions(+), 9 deletions(-)
 create mode 100644 drivers/power/of_power_supply.c
 create mode 100644 include/linux/power/of_power_supply.h

-- 
1.8.0

