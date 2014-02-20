Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbaBTLIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:08:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35956 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbaBTLIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:08:34 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH v2 0/2] regulator: core: Fix ops->enable/disable usage
Date: Thu, 20 Feb 2014 12:07:50 +0100
Message-Id: <1392894472-11956-1-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These two patches replace all ops->enable/disable by
_regulator_do_disable/enable function calls. These wrappers also handle gpio
regulators.

v2 enables all regulators with delays and I added a patch to fix all direct
disable calls.

Regards,

Markus


Markus Pargmann (2):
  regulator: core: Replace direct ops->enable usage
  regulator: core: Replace direct ops->disable usage

 drivers/regulator/core.c | 44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

-- 
1.8.5.3

