Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaBETrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 14:47:40 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54459 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbaBETrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:47:37 -0500
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
To: <santosh.shilimkar@ti.com>, <rob@landley.net>, <linux@arm.linux.org.uk>,
        <galak@kernel.crashing.org>
CC: <devicetree@vger.kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <rob.herring@calxeda.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <grygorii.strashko@ti.com>,
        <gregkh@linuxfoundation.org>, <dwmw2@infradead.org>, <nsekhar@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Subject: [PATCH v4 0/2] Introduce AEMIF driver for Davinci/Keystone archs
Date: Wed, 5 Feb 2014 21:46:12 +0200
Message-ID: <1391629574-18955-1-git-send-email-ivan.khoronzhuk@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches introduce Async External Memory Interface (EMIF16/AEMIF)
controller driver for Davinci/Keystone archs.

For more informations see documentation:
Davinci DM646x - http://www.ti.com/lit/ug/sprueq7c/sprueq7c.pdf
OMAP-L138 - http://www.ti.com/lit/ug/spruh77a/spruh77a.pdf
Kestone - http://www.ti.com/lit/ug/sprugz3a/sprugz3a.pdf

Based on
git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
keystone/master

v3..v4:
	rebased on latest of linux-keystone.git keystone/master

v2..v3 (https://lkml.org/lkml/2013/12/11/148):
- memory: ti-aemif: introduce AEMIF driver
	changed to work with multiple AEMIF controllers
	corrected "copyright" to "authors" in header
	changed compatible "ti,omap-L138-aemif" to "ti,da850-aeimf"
	used NULL in clk_get() instead of "aemif" name
	driver can be build as loadable module
	treat all child nodes as cs nodes, it makes code simpler

- memory: ti-aemif: add bindings for AEMIF driver
	deleted direct link driver/memory/ti-aemif.c
	clarified description of controller ranges property
	changed compatible "ti,omap-L138-aemif" to "ti,da850-aeimf"
	added cs number information in commit log
	removed compatible property from cs node, it makes code simpler

v1..v2 (https://lkml.org/lkml/2013/11/21/170):
- memory: ti-aemif: introduce AEMIF driver
- memory: ti-aemif: add bindings for AEMIF driver
	added ti.cs-chipselect property instead of representing chipselect
	number in cs node name.

Ivan Khoronzhuk (2):
  memory: ti-aemif: introduce AEMIF driver
  memory: ti-aemif: add bindings for AEMIF driver

 .../bindings/memory-controllers/ti-aemif.txt       | 210 ++++++++++
 drivers/memory/Kconfig                             |  11 +
 drivers/memory/Makefile                            |   1 +
 drivers/memory/ti-aemif.c                          | 429 +++++++++++++++++++++
 4 files changed, 651 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/ti-aemif.txt
 create mode 100644 drivers/memory/ti-aemif.c

-- 
1.8.3.2

