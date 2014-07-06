Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaGFR5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:57:36 -0400
Received: from seketeli.net ([94.23.218.202]:53423 "EHLO ms.seketeli.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbaGFR5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:57:35 -0400
From: Apelete Seketeli <apelete@seketeli.net>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org
Subject: [PATCH v3] Register NOP tranciever driver in JZ4740 musb glue layer
Date: Sun,  6 Jul 2014 19:58:02 +0200
Message-Id: <1404669483-12372-1-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The name of the NOP transceiver driver was changed during v3.16
release cycle from usb_phy_gen_xceiv to usb_phy_generic.

The patch that comes as a follow up of this message registers the NOP
transceiver driver before calling usb_get_phy() to avoid issues
related to accessing its data structure while it was not registered.

Changes since v2: 
  - reword commit message into something clearer.
Changes since v1: 
  - specify commit 4525bee summary line in parens in commit message.

For notice, I updated corresponding platform data to rename NOP
transceiver used for JZ4740 in a patch sent to linux-mips.

Changes were rebased on top of the linux-usb master branch, built and
tested successfully.

The following changes since commit 80235c4:

  Merge tag 'v3.16-rc2'

are available in the git repository at:

  git://git.seketeli.net/~apelete/linux-usb.git register-jz4740-phy

Apelete Seketeli (1):
  usb: musb: register nop transceiver driver for jz4740

 drivers/usb/musb/jz4740.c |    3 +++
 1 file changed, 3 insertions(+)

-- 
1.7.10.4

