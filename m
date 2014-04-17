Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbaDQKKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:10:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63262 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161100AbaDQKKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:10:03 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-73-534fa8798e23
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv2 0/8] Resource-managed extcon device register function
Date: Thu, 17 Apr 2014 19:09:55 +0900
Message-id: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWyRsSkQLdyhX+wQdNfbovrX56zWrx+YWhx
	edccNovbjSvYLBbsKbGYMfklmwObR9+WVYwenzfJBTBFcdmkpOZklqUW6dslcGX8e3eCrWAb
	d8Weh+UNjEs5uxg5OSQETCS2Lv3ICGGLSVy4t56ti5GLQ0hgKaPE1p4tjDBF89euZIVITGeU
	mH3nOjOE08YkcfXSAhaQKjYBXYknBy4zg9giAsESHSePM4EUMQssYZT4d/IWG0hCWMBdYsrW
	P2BjWQRUJZ7c2Qpm8wp4SDx51Q/UzAG0TkFiziQbkF4JgcdsErc6drNC1AtIfJt8iAWiRlZi
	0wFmiOskJQ6uuMEygVFwASPDKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYzAUDz971nvDsbb
	B6wPMSYDjZvILCWanA8M5bySeENjMyMLUxNTYyNzSzPShJXEeZMeJgUJCaQnlqRmp6YWpBbF
	F5XmpBYfYmTi4JRqYNx8rdVz6YOXZmdjD4Weqv6yNNwgc/XafW4/qlL5nNcF6c3wenndT/RI
	9p0Tu+apGq+TPr/OsYzRQur29QMHYmQj4j2PaltUT/mr53c6/FbNwmv7TvOts7n1e4Jox3EJ
	SU1Tvi5vH69lbmuCXyx9cpo31OzNq512jQLXrRp+/Yjvbd3NvnjtTFMlluKMREMt5qLiRADs
	N1eVWwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9jQd3KFf7BBvM/s1hc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx49+7E2wF27gr9jwsb2BcytnFyMkhIWAiMX/tSlYIW0ziwr31bF2M
	XBxCAtMZJWbfuc4M4bQxSVy9tIAFpIpNQFfiyYHLzCC2iECwRMfJ40wgRcwCSxgl/p28xQaS
	EBZwl5iy9Q8jiM0ioCrx5M5WMJtXwEPiyat+oGYOoHUKEnMm2Uxg5F7AyLCKUTS1ILmgOCk9
	11CvODG3uDQvXS85P3cTIzjQn0ntYFzZYHGIUYCDUYmHd4K6f7AQa2JZcWXuIUYJDmYlEd4l
	vUAh3pTEyqrUovz4otKc1OJDjMlAyycyS4km5wOjMK8k3tDYxMzI0sjc0MLI2Jw0YSVx3gOt
	1oFCAumJJanZqakFqUUwW5g4OKUagM4TUNpe9u1Hv4dVfbXs6WiB0I9TSoPj8tl3aisVzXub
	03wys+3ktK60JasLpMUkrXYsqHSed/Syp5pIRM/UHnd3V/70eWW2NuV8T1pVHeR+ezX45E/4
	lsZqb3/uxdqJtekefx+VvZTfOJ9NQO54gseTvvX5Wr9XHV3zQzt6dpF49IPaGD8lluKMREMt
	5qLiRAB07KL/uAIAAA==
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


Changelog:

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

 drivers/extcon/extcon-adc-jack.c |   30 +++++---------
 drivers/extcon/extcon-arizona.c  |   13 ++----
 drivers/extcon/extcon-class.c    |   83 ++++++++++++++++++++++++++++++++++++++
 drivers/extcon/extcon-gpio.c     |   16 ++------
 drivers/extcon/extcon-max14577.c |    9 +----
 drivers/extcon/extcon-max77693.c |    7 +---
 drivers/extcon/extcon-max8997.c  |    4 +-
 drivers/extcon/extcon-palmas.c   |   15 +++----
 include/linux/extcon.h           |    8 ++++
 9 files changed, 118 insertions(+), 67 deletions(-)

-- 
1.7.9.5

