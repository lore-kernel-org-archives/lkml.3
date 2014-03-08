Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaCHS6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 13:58:20 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:35998 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaCHS6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 13:58:19 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/4] Fix some spurious errors at bootup
Date: Sat,  8 Mar 2014 10:58:11 -0800
Message-Id: <cover.1394304585.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bunch of drivers that my system loads spew out KERN_ERR or
severity-less messages at startup.  These message are not errors.  Fix
them.

Andy Lutomirski (4):
  mei: Don't log an error when the MEI device is quirked off
  megaraid: Downgrade success messages from KERN_ERR to dev_dbg
  sr: Add a missing KERN_INFO
  raid6: Add severity levels to raid6 initialization messages

 drivers/misc/mei/pci-me.c                   |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  2 +-
 drivers/scsi/sr.c                           |  3 ++-
 lib/raid6/algos.c                           | 13 +++++++------
 5 files changed, 12 insertions(+), 10 deletions(-)

-- 
1.8.5.3

