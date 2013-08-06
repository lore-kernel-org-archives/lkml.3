Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756086Ab3HFM7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 08:59:18 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15122 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab3HFM7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 08:59:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 06 Aug 2013 05:57:35 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linus.walleij@linaro.org>
CC: <ian.campbell@citrix.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <rob@landley.net>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, <grant.likely@linaro.org>,
        <broonie@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 0/3] pinctrl: add pincontrol driver for palmas device.
Date: Tue, 6 Aug 2013 18:42:32 +0530
Message-ID: <1375794755-6246-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V1: 
- Split the additon of common code into pinctrl-utils and pinconf-generic.
- Use the pinconf-generic APIs for mapping node.
- Use pinconf generic properties to define the Palmas pincontrol nodes.
- Nit and cleanups, typo fixes, rephrasing the sentences etc.
- Use pin specific APIs for setting pin configuration rather than group
  specific.

Changes from V2:
- Rebased the  DT binding document on top of Stephen's cleanup.
- Convert name of propery "pinctrl-pins" to "pins" and "pinctrl-function" to
  function.

Laxman Dewangan (3):
  pinctrl: add utility functions for add map/configs
  pinctrl: pinconf-generic: add generic APIs for mapping pinctrl node
  pinctrl: palmas: add pincontrol driver

 .../bindings/pinctrl/pinctrl-bindings.txt          |    3 +
 .../devicetree/bindings/pinctrl/pinctrl-palmas.txt |   96 ++
 drivers/pinctrl/Kconfig                            |   10 +
 drivers/pinctrl/Makefile                           |    3 +-
 drivers/pinctrl/pinconf-generic.c                  |   96 ++
 drivers/pinctrl/pinctrl-palmas.c                   | 1085 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-utils.c                    |  135 +++
 drivers/pinctrl/pinctrl-utils.h                    |   42 +
 include/linux/mfd/palmas.h                         |   35 +-
 include/linux/pinctrl/pinconf-generic.h            |    6 +
 10 files changed, 1499 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-palmas.txt
 create mode 100644 drivers/pinctrl/pinctrl-palmas.c
 create mode 100644 drivers/pinctrl/pinctrl-utils.c
 create mode 100644 drivers/pinctrl/pinctrl-utils.h

