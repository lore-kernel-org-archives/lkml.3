Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab3LOSa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 13:30:58 -0500
Received: from 3.mo1.mail-out.ovh.net ([46.105.60.232]:54613 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751717Ab3LOSa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 13:30:57 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH 0/2] pinctrl: at91: fix clk handling in suspend/resume funcs
Date: Sun, 15 Dec 2013 19:30:50 +0100
Message-Id: <1387132252-2584-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 17699709485987952812
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrleehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series replaces clk_prepare + clk_enable or
clk_disable + clk_unprepare calls by single clk_prepapre_enable and
clk_disable_unprepare calls.

It also fixes the clk disable + unprepare order in the suspend function of the
pinctrl driver (unprepare must be called after disable).

Best Regards,

Boris

Boris BREZILLON (2):
  pinctrl: at91: fix clk_unprepare and clk_disable order
  pinctrl: at91: replace clk_prepare + clk_enable by clk_prepare_enable

 drivers/pinctrl/pinctrl-at91.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

-- 
1.7.9.5

