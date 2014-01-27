Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460AbaA0D7s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 22:59:48 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:49936 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbaA0D7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 22:59:46 -0500
From: Max Filippov <jcmvbkbc@gmail.com>
To: linux-xtensa@linux-xtensa.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Chris Zankel <chris@zankel.net>, Marc Gauthier <marc@cadence.com>,
        "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 0/3] OpenCores 10/100 MAC fixes for gigabit environment
Date: Mon, 27 Jan 2014 07:59:24 +0400
Message-Id: <1390795167-6677-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David, Grant, Rob, Chris and everybody,

this series improves ethoc behavior in gigabit environment:
- first patch disables gigabit advertisement in the attached PHY making
  possible to use gigabit link without any additional setup;
- second patch adds support to set up MII management bus frequency, adding
  new fields to platform data and to OF bindings;
- third patch documents existing and newly added OF bindings.

These changes allow to use KC-705 board with 50MHz xtensa core and OpenCores
10/100 Mbps MAC connected to gigabit network without any additional setup.

Max Filippov (3):
  net: ethoc: don't advertise gigabit speed on attached PHY
  net: ethoc: set up MII management bus clock
  net: ethoc: document OF bindings

 .../devicetree/bindings/net/opencores-ethoc.txt    | 25 +++++++++++++++++++
 drivers/net/ethernet/ethoc.c                       | 29 ++++++++++++++++++++--
 include/net/ethoc.h                                |  2 ++
 3 files changed, 54 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/opencores-ethoc.txt

-- 
1.8.1.4

