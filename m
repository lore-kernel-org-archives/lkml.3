Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaG1S2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:28:42 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48321 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaG1S2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:28:36 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org
Cc: tiwai@suse.de, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 0/4] driver core: allow explicit deferred probe preference
Date: Mon, 28 Jul 2014 11:28:26 -0700
Message-Id: <1406572110-26823-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This adds support to let device drivers explicitly request to be
probed on the deferred workqueue. Note that another ideal solution
on top of this would be if we could detect somehow if kthread_create()
was SIGKILL'd for a modprobe, and also driver_deferred_probe_add() the
device there proactively. This would enable us to not have to be hunting
for these device drivers as a fix after a problem popped up. That would
allow us to look for device drivers that need this change in a proactive
way but without failing them first -- I just can't think of a way to do
this yet.

Luis R. Rodriguez (4):
  driver core: move deferred probe add / remove helpers down a bit
  driver core: enable drivers to use deferred probe from init
  cxgb4: ask for deferred probe
  mptsas: ask for deferred probe

 drivers/base/dd.c                               | 58 ++++++++++++++++---------
 drivers/message/fusion/mptsas.c                 |  3 ++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |  3 ++
 include/linux/device.h                          |  7 +++
 4 files changed, 50 insertions(+), 21 deletions(-)

-- 
2.0.1

