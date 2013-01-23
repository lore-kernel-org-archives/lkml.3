Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab3AWHVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 02:21:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:37864 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab3AWHTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 02:19:39 -0500
X-IronPort-AV: E=Sophos;i="4.84,521,1355068800"; 
   d="scan'208";a="6634049"
From: Hu Tao <hutao@cn.fujitsu.com>
To: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Subject: [PATCH v12 rebased 5/8] add a new qevent: QEVENT_GUEST_PANICKED
Date: Wed, 23 Jan 2013 15:19:26 +0800
Message-Id: <08fa928e5ef2dc3d16b4dc93a337fe84c78e3772.1358920534.git.hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.0.1.240.ge8a1f5a
In-Reply-To: <cover.1358920534.git.hutao@cn.fujitsu.com>
References: <cover.1358920534.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/23 15:18:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/23 15:18:39,
	Serialize complete at 2013/01/23 15:18:39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This event will be emited when the guest is panicked.

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 include/monitor/monitor.h | 1 +
 monitor.c                 | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/monitor/monitor.h b/include/monitor/monitor.h
index 87fb49c..4006905 100644
--- a/include/monitor/monitor.h
+++ b/include/monitor/monitor.h
@@ -45,6 +45,7 @@ typedef enum MonitorEvent {
     QEVENT_WAKEUP,
     QEVENT_BALLOON_CHANGE,
     QEVENT_SPICE_MIGRATE_COMPLETED,
+    QEVENT_GUEST_PANICKED,
 
     /* Add to 'monitor_event_names' array in monitor.c when
      * defining new events here */
diff --git a/monitor.c b/monitor.c
index 9381ed0..61beeb4 100644
--- a/monitor.c
+++ b/monitor.c
@@ -463,6 +463,7 @@ static const char *monitor_event_names[] = {
     [QEVENT_WAKEUP] = "WAKEUP",
     [QEVENT_BALLOON_CHANGE] = "BALLOON_CHANGE",
     [QEVENT_SPICE_MIGRATE_COMPLETED] = "SPICE_MIGRATE_COMPLETED",
+    [QEVENT_GUEST_PANICKED] = "GUEST_PANICKED",
 };
 QEMU_BUILD_BUG_ON(ARRAY_SIZE(monitor_event_names) != QEVENT_MAX)
 
-- 
1.8.0.1.240.ge8a1f5a

