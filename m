Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaAFN0O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 08:26:14 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:64169 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaAFN0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:26:13 -0500
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 0/2] video: mxsfb: fix broken videomode selection
Date: Mon,  6 Jan 2014 14:17:56 +0100
Message-Id: <1389014278-4903-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch in this set converts some messages that are printed
in case of errors to be error messages rather than debug messages.

The second patch fixes a bug in the video selection code that
incorrectly OR's together the 'pixelclk-active' and 'de-active'
flags from all possible video modes specified in DT into one flag.

The current code does not allow selecting one specific mode from a
list of video modes, but always uses the last one of the video modes
listed in the DT.


Since all current dts files only have one entry in their
'display-timings' node, this bug was not apparent and the fix does not
change the driver's behaviour for the current users.

 b/drivers/video/mxsfb.c |    6 +--
 drivers/video/mxsfb.c   |  120 +++++++++++++++++++++++++++++-----------------------------------------
 2 files changed, 53 insertions(+), 73 deletions(-)

