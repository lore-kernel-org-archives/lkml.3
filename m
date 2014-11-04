Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaKDIuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:50:04 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14995 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaKDIuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:50:01 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-86-545893368235
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/6] regulator: max77686/802: Cleanup
Date: Tue, 04 Nov 2014 09:49:40 +0100
Message-id: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t/xa7pmkyNCDK7clLPYOGM9q8XUh0/Y
	LI7+LrB4/cLQ4mzTG3aL+1+PMlp8u9LBZHF51xw2i7VH7rJbnO5mdeDy+Pv8OovHzll32T02
	repk87hzbQ+bx7yTgR59W1YxenzeJBfAHsVlk5Kak1mWWqRvl8CV0dT5hr3gFE/Fttk9bA2M
	nzi7GDk5JARMJPY232GGsMUkLtxbz9bFyMUhJLCUUeLJzplMEE4fk8SVN+/AqtgEjCU2L18C
	ViUisIlRYlL/FVaQBLNAM5PE6fc5ILawgKnE5AMLGUFsFgFVifkf1zKB2LwC7hLLH3ZBrZOT
	OHlsMusERu4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUJC6ssOxsXHrA4xCnAwKvHw
	ZqhHhAixJpYVV+YeYpTgYFYS4V1dBRTiTUmsrEotyo8vKs1JLT7EyMTBKdXAaLwgntVp6rpj
	/zWrE2J8lv1vldp7J/JD4OH2yG2frYoftuoX2kdOKcxaV68tnqmdnOrof6JaKPbOOd6Fpjon
	g+KmTFjAc/JmRqJfW2NIm/uRtefv7HjqEvyQfy+XvwLLisCJac+MHTffsImckSafb/H2RUZH
	4o2DOQZME0y3ZGZvaoh8v65fiaU4I9FQi7moOBEAWj1m9QcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Previously this patchset was part of adding GPIO to max77686
regulator driver [1]. I split it but the goal is the same:
cleanup and simplify the regulator drivers by removing obsolete
board file support so adding new features would be easier.

The patchset removes board file support from regulator drivers
incrementally and in a bisect-friendly way. Thus MFD driver is
updated at the end.

Everything should be pulled at once (preferrably regulator tree).
Rebased on next-20141031.

The changes on max77802 were not tested.
I am kindly asking for testing it because I don't have the board
with Maxim 77802.


[1] [PATCH v3 00/14] regulator: max77686: Add GPIO control
    https://lkml.org/lkml/2014/10/30/270


Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (6):
  regulator: max77686: Consistently index opmode array by rdev id
  regulator: max77686: Initialize opmode explicitly to normal mode
  regulator: max77802: Don't ignore return value of current opmode
  regulator: max77802: Remove support for board files
  regulator: max77686: Remove support for board files
  mfd: max77686/802: Remove support for board files

 drivers/mfd/Kconfig                  |   1 +
 drivers/mfd/max77686.c               |  23 --------
 drivers/regulator/max77686.c         |  96 ++++++++-------------------------
 drivers/regulator/max77802.c         | 100 +++++++++--------------------------
 include/linux/mfd/max77686-private.h |   1 -
 include/linux/mfd/max77686.h         |  28 ----------
 6 files changed, 49 insertions(+), 200 deletions(-)

-- 
1.9.1

