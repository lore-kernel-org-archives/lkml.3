Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaHLW2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 18:28:35 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43115 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbaHLW2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 18:28:33 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org
Cc: tiwai@suse.de, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 0/3] module loading: add module_long_probe_init()
Date: Tue, 12 Aug 2014 15:28:24 -0700
Message-Id: <1407882507-325-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

systemd-udevd will cause a driver to fail to load if it doesn't load
within the set default timeout, right now 30 seconds. Although we now
have a way to increase the timeout at run time we need a way to both
annotate drivers that need fixing and a way to enable drivers's whose
probe takes long time while they are fixed. Using deferred probe works
but it was recently agreed that we'd instead use kthreads for drivers
that have long probes.

Luis R. Rodriguez (3):
  init / kthread: add module_long_probe_init() and
    module_long_probe_exit()
  cxgb4: use module_long_probe_init()
  mptsas: use module_long_probe_init()

 drivers/message/fusion/mptsas.c                 |  5 ++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |  5 ++--
 include/linux/kthread.h                         | 35 +++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 4 deletions(-)

-- 
2.0.3

