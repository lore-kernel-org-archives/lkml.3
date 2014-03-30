Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaC3Ne3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 09:34:29 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:53321 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaC3Ne2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 09:34:28 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        PaX Team <pageexec@freemail.hu>, Felipe Balbi <balbi@ti.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: [PATCH 0/2] pda_power: USB notifier fixes
Date: Sun, 30 Mar 2014 15:34:13 +0200
Message-Id: <1396186455-3276-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The notifier block can and should be initialized statically. Fixed in
patch 1.

While doing patch 1 I noticed, that the USB notifier that gets registered
in pda_power_probe() never gets unregistered. Fixed in patch 2.

Beware: The patches are compile tested only, as I have no such hardware!

Please apply!

Mathias Krause (2):
  pda_power: Statically initialize notifier block
  pda_power: Unregister USB notifier in pda_power_remove()

 drivers/power/pda_power.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

-- 
1.7.10.4

