Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaKKTAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 14:00:53 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:33126 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaKKTAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 14:00:46 -0500
From: Johan Hovold <johan@kernel.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 0/9] net: phy: micrel: refactoring and KSZ8081/KSZ8091 features
Date: Tue, 11 Nov 2014 20:00:06 +0100
Message-Id: <1415732415-10363-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series cleans up and refactors parts of the micrel PHY driver, and
adds support for broadcast-address-disable and led-mode configuration
for KSZ8081 and KSZ8091 PHYs.

Specifically, this enables dual KSZ8081 setups (which are limited to
using address 0 and 3).

A follow up series will add device-type abstraction which will allow for
further refactoring and shared initialisation code.

Johan


Johan Hovold (9):
  dt/bindings: fix documentation of ethernet-phy compatible property
  net: phy: micrel: fix config_intr error handling
  net: phy: micrel: use BIT macro
  net: phy: micrel: refactor broadcast disable
  net: phy: micrel: disable broadcast for KSZ8081/KSZ8091
  net: phy: micrel: add led-mode sanity check
  net: phy: micrel: refactor led-mode error handling
  net: phy: micrel: clean up led-mode setup
  net: phy: micrel: enable led-mode for KSZ8081/KSZ8091

 Documentation/devicetree/bindings/net/micrel.txt |   2 +
 Documentation/devicetree/bindings/net/phy.txt    |   3 +-
 drivers/net/phy/micrel.c                         | 125 ++++++++++++++++-------
 3 files changed, 93 insertions(+), 37 deletions(-)

-- 
2.0.4

