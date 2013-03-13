Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab3CMJCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:02:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29028 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833Ab3CMJCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:02:32 -0400
X-AuditID: cbfee68e-b7f946d000001e37-63-514040a70541
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, cw00.choi@samsung.com
Subject: [PATCH 0/3] extcon: max8997/max77693: Fix bug and set default value to
 bring up
Date: Wed, 13 Mar 2013 18:02:15 +0900
Message-id: <1363165338-989-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t8zXd3lDg6BBm3TJC2uf3nOanG26Q27
	xeVdc9gsbjeuYHNg8ejbsorR4/MmuQCmKC6blNSczLLUIn27BK6MuSe3sBY8ZKu40XqRvYFx
	P2sXIyeHhICJxPYTj5khbDGJC/fWs3UxcnEICSxjlJh+4DYTTFHzq4eMEInpjBIHdx1ih3D+
	M0osufacBaSKTUBLYv+LG2wgtoiAgsTm3mdgK5gF/CTebP4K1M3BISwQJbFzZh1ImEVAVWLq
	xxdgm3kFnCUOHN/IBrFMTuLDnkdg8yUErrNJnFw0nw2iQUDi2+RDLCBzJARkJTYdgLpaUuLg
	ihssExgFFzAyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQICb2+HYw3D1gfYkwGGjeRWUo0
	OR8Yunkl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YGxSZvjMdf2bbk9Qv7te/qczu50P5xSc3hzLr5XAxdygfyf9kE/1qySe7YvWFd7cxZd2ifeX
	YfYGa7VFj8QrbSKWu8+d//9Yo659OPuST3qzclL2LimKelBj/vPESd6KuMPu0vO8Pxcq/rrZ
	w66kKMh6PMSP01to421H441nvjPdKTLpWLeOWYmlOCPRUIu5qDgRAGynjoFTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t9jQd3lDg6BBpN6RSyuf3nOanG26Q27
	xeVdc9gsbjeuYHNg8ejbsorR4/MmuQCmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwjrGjLknt7AWPGSruNF6kb2BcT9rFyMnh4SAiUTzq4eMELaYxIV769m6GLk4hASmM0oc
	3HWIHcL5zyix5NpzFpAqNgEtif0vbrCB2CICChKbe5+BTWIW8JN4s/kr0CQODmGBKImdM+tA
	wiwCqhJTP75gBrF5BZwlDhzfyAaxTE7iw55H7BMYuRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L
	10vOz93ECA7sZ9I7GFc1WBxiFOBgVOLhlUizDxRiTSwrrsw9xCjBwawkwvvNxiFQiDclsbIq
	tSg/vqg0J7X4EGMy0PaJzFKiyfnAqMsriTc0NjEzsjQyMzYxNzYmTVhJnPdgq3WgkEB6Yklq
	dmpqQWoRzBYmDk6pBsYWLpm7q1+1Rm1vv6OhmilSbzJVSz2fTcDN87bI030mKvvvvOk2F75r
	sCfA2eqE5QQFw9dl9f8fWItrZHXeCT9Ys95ML78zII35S/iHhIu7tz49++Hs9ahQx4gH7buD
	nke16MQt3iIeqN0lGeXml/hDa+nj4jyGOvMl3pzPd1Y+eFZbmxyYoMRSnJFoqMVcVJwIAHYH
	l3mwAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is small fixes of extcon-max8997/max77693 driver.

Fix to max77693 extcon driver:
- Set default value of MUIC register to bring up it.
when user don't pass specific initial data for MUIC device.
Fix to max8997/max77693 extcon driver:
- Fix wrong pointer on probe() when platform data isn't used.

Chanwoo Choi (3):
  extcon: max8997: Check the pointer of platform data to protect null pointer error
  extcon: max77693: Fix bug of wrong pointer when platform data is not used
  extcon: max77693: Initialize register of MUIC device to bring up it without platform data

 drivers/extcon/extcon-max77693.c     | 103 +++++++++++++++++++++++++++--------
 drivers/extcon/extcon-max8997.c      |  56 +++++++++++--------
 include/linux/mfd/max77693-private.h |  23 ++++++++
 3 files changed, 137 insertions(+), 45 deletions(-)

-- 
1.8.0

