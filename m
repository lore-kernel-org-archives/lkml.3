Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3HOK6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:58:11 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:34175
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078Ab3HOK6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:58:09 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de097hz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Dong Aisheng <b29396@freescale.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 0/3] of: add update device node status via cmdline feature
Date: Thu, 15 Aug 2013 18:55:30 +0800
Message-ID: <1376564133-11286-1-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We meet some boards having a lot of pin conflicts between different devices,
only one of them can be enabled to run at one time.

e.g. imx6q sabreauto board, i2c, spi, weim, flexcan, uart and etc involved
with pin conflict.

Instead of changing dts manually or adding a lot dts files according to
different device availability, we provide feature to dynamically update the
device node status via command line, then those devices involved with
pin conflict can be enabled or disabled dynamically.

It's conveniently to use and can save a lot dts board files, also can
permenantly fix the pin conflicts issue.

The patch series is based on v3.11-rc5.

Dong Aisheng (3):
  of: add device node status update APIs
  of: add update device node status via cmdline feature
  of: add node status update via name format with cmdline

 Documentation/kernel-parameters.txt |   10 +++
 drivers/of/base.c                   |  107 +++++++++++++++++++++++++++++++++
 drivers/of/fdt.c                    |  111 +++++++++++++++++++++++++++++++++++
 include/linux/of.h                  |   13 ++++
 4 files changed, 241 insertions(+), 0 deletions(-)


