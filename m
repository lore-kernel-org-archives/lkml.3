Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbbARCE4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 21:04:56 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:65091 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbARCEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 21:04:54 -0500
From: mathieu.poirier@linaro.org
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH 0/4] staging: vt6655: fixing various sparse problems
Date: Sat, 17 Jan 2015 19:04:22 -0700
Message-Id: <1421546666-21461-1-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

>From a v3.19-rc4 baseline sparse finds the following errors:

  LD      drivers/staging/vt6655/built-in.o
  CHECK   drivers/staging/vt6655/device_main.c
drivers/staging/vt6655/device_main.c:1503:25: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/device_main.c:1503:25:    expected void [noderef] <asn:2>*<noident>
drivers/staging/vt6655/device_main.c:1503:25:    got struct vnt_private *
drivers/staging/vt6655/device_main.c:1503:25: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/device_main.c:1503:25:    expected void [noderef] <asn:2>*<noident>
drivers/staging/vt6655/device_main.c:1503:25:    got struct vnt_private *
drivers/staging/vt6655/device_main.c:1505:25: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/device_main.c:1505:25:    expected void [noderef] <asn:2>*<noident>
drivers/staging/vt6655/device_main.c:1505:25:    got struct vnt_private *
drivers/staging/vt6655/device_main.c:1505:25: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/device_main.c:1505:25:    expected void [noderef] <asn:2>*<noident>
drivers/staging/vt6655/device_main.c:1505:25:    got struct vnt_private *
drivers/staging/vt6655/device_main.c:1672:5: warning: symbol 'vnt_init' was not declared. Should it be static?
  CC [M]  drivers/staging/vt6655/device_main.o
  CHECK   drivers/staging/vt6655/card.c
  CC [M]  drivers/staging/vt6655/card.o
  CHECK   drivers/staging/vt6655/channel.c
  CC [M]  drivers/staging/vt6655/channel.o
  CHECK   drivers/staging/vt6655/mac.c
drivers/staging/vt6655/mac.c:162:6: warning: symbol 'MACvGetShortRetryLimit' was not declared. Should it be static?
  CC [M]  drivers/staging/vt6655/mac.o
  CHECK   drivers/staging/vt6655/baseband.c
drivers/staging/vt6655/baseband.c:2180:45: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/baseband.c:2180:45:    expected struct vnt_private *priv
drivers/staging/vt6655/baseband.c:2180:45:    got void [noderef] <asn:2>*dwIoBase
  CC [M]  drivers/staging/vt6655/baseband.o
  CHECK   drivers/staging/vt6655/rxtx.c


The following pachset provides a fix for the above.

Mathieu Poirier (4):
  staging: vt6655: correcting function declaration sparse error
  staging: vt6655: removing dead function as reported by sparse
  staging: vt6655: fix wrong parameter as reported by sparse
  staging: vt6655: correcting parameter related sparse error

 drivers/staging/vt6655/baseband.c    |  2 +-
 drivers/staging/vt6655/device_main.c |  8 +++++---
 drivers/staging/vt6655/mac.c         | 19 -------------------
 3 files changed, 6 insertions(+), 23 deletions(-)

-- 
1.9.1

