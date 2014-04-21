Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaDUKKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:10:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11066 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaDUKKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:10:18 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-53-5354ee888044
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv4 0/8] Resource-managed extcon device register function
Date: Mon, 21 Apr 2014 19:10:07 +0900
Message-id: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWyRsSkQLfjXUiwwcrL1hbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4MpoffSbrWAb
	b8X1U5/ZGhg/cXUxcnJICJhIdK+cxAJhi0lcuLeerYuRi0NIYCmjxLmNe1lhipafXcMMkVjE
	KLG2+SMThNPGJDHlajsjSBWbgK7EkwOXmUFsEYFgiY6Tx8GKmAWWMEr8O3mLDSQhLOAucbH3
	J1gRi4CqxO1jL8F28wp4SBw61QW0jgNonYLEnEk2IL0SAo/ZJD733WGFqBeQ+Db5EAtEjazE
	pgPMENdJShxccYNlAqPgAkaGVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxiBwXj637P+HYx3
	D1gfYkwGGjeRWUo0OR8YzHkl8YbGZkYWpiamxkbmlmakCSuJ895/mBQkJJCeWJKanZpakFoU
	X1Sak1p8iJGJg1OqgZGl3vXaI9WVTUu3JZzWyJY274u3rpjmu9t51oGjCm/6IkICumJUwjp1
	hb7U7boV5vas4BR/zqZ/by4+NQq6wFts7v1sE+tt4X28/6Z3av9dsk230ld67Q1pSyEH7o+b
	/V5z2q8QlGvitZ0RarU4T/l2V0mPAGfbbnOWYh9jceOTHwRPCZw5o8RSnJFoqMVcVJwIAB44
	F4FcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t9jAd2OdyHBBlMnmFhc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYxo/XRb7aCbbwV1099Zmtg/MTVxcjJISFgIrH87BpmCFtM4sK99Wxd
	jFwcQgKLGCXWNn9kgnDamCSmXG1nBKliE9CVeHLgMliHiECwRMfJ42BFzAJLGCX+nbzFBpIQ
	FnCXuNj7E6yIRUBV4vaxlywgNq+Ah8ShU12sXYwcQOsUJOZMspnAyL2AkWEVo2hqQXJBcVJ6
	rpFecWJucWleul5yfu4mRnCoP5PewbiqweIQowAHoxIP74v8kGAh1sSy4srcQ4wSHMxKIrwR
	64FCvCmJlVWpRfnxRaU5qcWHGJOBlk9klhJNzgfGYV5JvKGxiZmRpZG5oYWRsTlpwkrivAdb
	rQOFBNITS1KzU1MLUotgtjBxcEo1MPb84n+6urxB1n37vLpwqUVGSlUsLjdCxWNUI0OrfK5y
	KHzZzdhQKezdoLKi5q4O09PVJ76ktysyzZNaf23h9f+HH2pouDb9+DShYP8jnujZr6pdS4SV
	Hsnf5A0+tfdE8n3Ruas6Wnfdcd5SxKd6OubAP6E5e7qLWCce3e8rFafTcyxiR5HoNyWW4oxE
	Qy3mouJEAGssA1y5AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add resource-managed extcon device register functions for
developers' convenience and apply them to related device driver files.
This work can make the code more tidy since extcon device is automatically
unregistered on driver detach so tiresome managing codes could be removed.


Changelog

v4:
* fix the memory leak bug becuase of single pointer
* clean up the unnecessary code and make proper indentation

v3:
* send the right version instead of previous v1
* add the credit for reviewers according to the review rules

v2:
* modify and clean up all unnecessary code reported by Chanwoo
* fix the bug reported by Seung-Woo
* add the credit for reviewers

v1:
* initial version

Sangjung Woo (8):
  extcon: Add resource-managed extcon register function
  extcon: adc-jack: Use devm_extcon_dev_register()
  extcon: gpio: Use devm_extcon_dev_register()
  extcon: max14577: Use devm_extcon_dev_register()
  extcon: max77693: Use devm_extcon_dev_register()
  extcon: max8997: Use devm_extcon_dev_register()
  extcon: palmas: Use devm_extcon_dev_register()
  extcon: arizona: Use devm_extcon_dev_register()

 drivers/extcon/extcon-adc-jack.c |   30 ++++++------------
 drivers/extcon/extcon-arizona.c  |   12 +++----
 drivers/extcon/extcon-class.c    |   64 ++++++++++++++++++++++++++++++++++++++
 drivers/extcon/extcon-gpio.c     |   16 +++-------
 drivers/extcon/extcon-max14577.c |    9 ++----
 drivers/extcon/extcon-max77693.c |    7 ++---
 drivers/extcon/extcon-max8997.c  |    4 +--
 drivers/extcon/extcon-palmas.c   |   15 +++------
 include/linux/extcon.h           |   17 ++++++++++
 9 files changed, 108 insertions(+), 66 deletions(-)

-- 
1.7.9.5

