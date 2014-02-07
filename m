Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751682AbaBGHy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 02:54:28 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18467 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaBGHy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 02:54:27 -0500
X-AuditID: cbfee68e-b7f566d000002344-08-52f4913153f9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 0/4] rtc: Use devm_ioremap_resource()
Date: Fri, 07 Feb 2014 16:54:25 +0900
Message-id: <000401cf23d9$d1df6e30$759e4a90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2dGo+e7pmAi4QKyN7t2QoeNN8w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zA13DiV+CDE69VbRYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY29nUcF31oqzrRoNjJ9Zuhg5OSQETCR+TtnPBmGLSVy4tx7I5uIQEljGKLGi7zwr
	TNHdg5eYIBKLGCXmfeiAqvrFKLFk5zNGkCo2ATWJL18Os3cxcnCICOhLtLVogNQwC/QySpzp
	3c0OUiMsYCrR2L+dGcRmEVCVONHfANbLK2Arsfb/NChbUOLH5Htg5zELaEms33mcCcKWl9i8
	5i0zyHwJAXWJR391QcIiAnoSHw4sY4YoEZHY9+IdI8TRx9glbp3gglglIPFt8iEWiFZZiU0H
	mCFKJCUOrrjBMoFRbBaSxbOQLJ6FZPEsJBsWMLKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/d
	xAiJur4djDcPWB9iTAZaP5FZSjQ5Hxi1eSXxhsZmRhamJqbGRuaWZqQJK4nzLnqYFCQkkJ5Y
	kpqdmlqQWhRfVJqTWnyIkYmDU6qBsVLw4dTTC1guTDHdEpkiNW/ps/Ni7Iz/S6S8FbMOufA3
	RFqv4vl/8vFOg6OaaofFoo+u8DQ6UPNafa6sxGcj1ukr8/O+r10sPF0+7bOsWt+xrblr18rU
	FP+aHxEkIKtwS/Vz+pQn+/6Vff32YMaNXNHYd8+m3zpwSSfObodgQummDbfaghkOpiuxFGck
	GmoxFxUnAgCXzILr0AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAV3DiV+CDL48kbVYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWNvZ1HBd9aKs60aDYyfWboYOTkkBEwk7h68
	xARhi0lcuLeerYuRi0NIYBGjxLwPHVDOL0aJJTufMYJUsQmoSXz5cpi9i5GDQ0RAX6KtRQOk
	hlmgl1HiTO9udpAaYQFTicb+7cwgNouAqsSJ/gawXl4BW4m1/6dB2YISPybfA7uCWUBLYv3O
	40wQtrzE5jVvmUHmSwioSzz6qwsSFhHQk/hwYBkzRImIxL4X7xgnMArMQjJpFpJJs5BMmoWk
	ZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Kh+JrWDcWWDxSFGAQ5GJR7eE0s/Bwmx
	JpYVV+YeYpTgYFYS4f3Z8CVIiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OBCSevJN7Q2MTM
	yNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhgVzpTHsrue2BKcw+dy3GHZ
	zCyjs8dFLbPm5yv//L7zs32VyW/pnVZpTwtVK45lP1q15NWRhOV8Ql8NH+hOnrpl+75fDbGv
	U09dDn8RdUxS9X7q2/bI8GhPqd1reb85n+ItV1d8p7V8gfvGKazbb+29YW2uKrQzaUmKom69
	1SLjOd1bGmeIeYQqsRRnJBpqMRcVJwIAs0yx6i4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource() in order to make the code simpler,
because devm_ioremap_resource() includes devm_request_mem_region()
and devm_ioremap(). Also, it checks the return value of
platform_get_resource().

Jingoo Han (4):
      rtc: rtc-coh901331: Use devm_ioremap_resource()
      rtc: rtc-davinci: Use devm_ioremap_resource()
      rtc: rtc-jz4740: Use devm_ioremap_resource()
      rtc: rtc-vt8500: Use devm_ioremap_resource()

---
 drivers/rtc/rtc-coh901331.c |   18 +++---------------
 drivers/rtc/rtc-davinci.c   |   29 ++++-------------------------
 drivers/rtc/rtc-jz4740.c    |   24 +++++++-----------------
 drivers/rtc/rtc-vt8500.c    |   28 +++++-----------------------
 4 files changed, 19 insertions(+), 80 deletions(-)

