Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaKQJE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 04:04:29 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34733 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaKQJE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 04:04:27 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-16-5469ba19598d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH v2 0/3] regulator: max77686/802: Cleanup
Date: Mon, 17 Nov 2014 10:04:12 +0100
Message-id: <1416215055-20223-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t/xq7qSuzJDDM7Pk7bYOGM9q8XUh0/Y
	LI7+LrB4/cLQ4mzTG3aL+1+PMlp8u9LBZHF51xw2i7VH7rJbnO5mdeDy+Pv8OovHzll32T02
	repk87hzbQ+bx7yTgR59W1YxenzeJBfAHsVlk5Kak1mWWqRvl8CVsXnTd/aCaTwVDV9lGxjP
	cHYxcnJICJhI3JpzjgXCFpO4cG89WxcjF4eQwFJGiVVLT7NCOH1MEt1zrrGCVLEJGEtsXr4E
	rEpEYBOjxKT+K2AJZoFmJonT73NAbGEBe4ne0x+YQWwWAVWJ2wumsYHYvALuEmuOrmGDWCcn
	cfLYZNYJjNwLGBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoQE1NcdjEuPWR1iFOBgVOLh
	PVCUGSLEmlhWXJl7iFGCg1lJhFd5G1CINyWxsiq1KD++qDQntfgQIxMHp1QD40z/RibttG9M
	We8e2sc9PuRR86xu2qnSsjcbtgtWvOIMSJ3l+voPg1DX/k/8rw+62Z4zfcBmJXP14o5tnBzb
	VPanyKQ8ypqcyDytK2SV6kHTbXWJyknva5al5azIzvOw6Ah5euOd0cvjGr+c2wJcJ77cbJ/0
	9OXJSOHDSvkXDdzXbF+lIz1lqhJLcUaioRZzUXEiAPSABmoGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

No changes, resending with new acks/tests from Javier
and after rebasing on current next.

Changes since v1
================
1. Rebase on next-20141105, now it should apply cleanly to regulator
   tree.
2. Remove first 3 patches, applied by Mark.


Description
===========
Previously this patchset was part of adding GPIO to max77686
regulator driver [1]. I split it but the goal is the same:
cleanup and simplify the regulator drivers by removing obsolete
board file support so adding new features would be easier.

The patchset removes board file support from regulator drivers
incrementally and in a bisect-friendly way. Thus MFD driver is
updated at the end.

Everything should be pulled at once (preferrably regulator tree).
Rebased on next-20141114.


[1] [PATCH v3 00/14] regulator: max77686: Add GPIO control
    https://lkml.org/lkml/2014/10/30/270


Best regards,
Krzysztof Kozlowski

Krzysztof Kozlowski (3):
  regulator: max77802: Remove support for board files
  regulator: max77686: Remove support for board files
  mfd: max77686/802: Remove support for board files

 drivers/mfd/Kconfig                  |  1 +
 drivers/mfd/max77686.c               | 23 ---------
 drivers/regulator/max77686.c         | 91 ++++++++---------------------------
 drivers/regulator/max77802.c         | 92 ++++++++----------------------------
 include/linux/mfd/max77686-private.h |  1 -
 include/linux/mfd/max77686.h         | 28 -----------
 6 files changed, 39 insertions(+), 197 deletions(-)

-- 
1.9.1

