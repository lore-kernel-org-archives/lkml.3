Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaKEJsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:48:15 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25736 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaKEJsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:48:09 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-c9-5459f257715b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 0/3] regulator: max77686/802: Cleanup
Date: Wed, 05 Nov 2014 10:47:48 +0100
Message-id: <1415180871-25293-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t/xa7rhnyJDDG7/FrPYOGM9q8XUh0/Y
	LI7+LrB4/cLQ4mzTG3aL+1+PMlp8u9LBZHF51xw2i7VH7rJbnO5mdeDy+Pv8OovHzll32T02
	repk87hzbQ+bx7yTgR59W1YxenzeJBfAHsVlk5Kak1mWWqRvl8CV8erDC8aCvTwV/08uYG1g
	fMrZxcjJISFgIrFjwhs2CFtM4sK99UA2F4eQwFJGiTVTtjBBOH1MEtN797ODVLEJGEtsXr4E
	rEpEYBOjxKT+K6wgCWaBZiaJ0+9zuhg5OIQFLCTuX4oACbMIqEr82v+CBcTmFXCXOLBjNgvE
	NjmJk8cms05g5F7AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cTIySgvuxgXHzM6hCjAAej
	Eg+vR1NkiBBrYllxZe4hRgkOZiURXs5LQCHelMTKqtSi/Pii0pzU4kOMTBycUg2M8hMyJpit
	uDx7XZzg3R6lo6uqza5Mumi3ME3n9p+PMqf1I1L5P0mZ+sesevNKvb8u7WhHToRGscTpC2sl
	Oq6t1v1a/VnpRcQmyXQtzmtv1ntWn+uuPcN4O37TRuM3aYlW9YHTLabuP/Fl8o3TRz/cjb+4
	aJvj9SnFD9dVhu2fNSnx7RSZt1t0ziqxFGckGmoxFxUnAgAxmFGQBgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


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
Rebased on next-20141105.

The changes on max77802 were not tested.
I am kindly asking for testing it because I don't have the board
with Maxim 77802.


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

