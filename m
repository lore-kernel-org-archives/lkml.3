Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab3B1MNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 07:13:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:13757 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753678Ab3B1MNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 07:13:19 -0500
X-IronPort-AV: E=Sophos;i="4.84,755,1355068800"; 
   d="scan'208";a="6787330"
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
        Luiz Capitulino <lcapitulino@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v13 5/8] add a new qevent: QEVENT_GUEST_PANICKED
Date: Thu, 28 Feb 2013 20:13:16 +0800
Message-Id: <664d63ad19ae6ec25a5a7bd6411c8ab7e289f632.1362051582.git.hutao@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <cover.1362051581.git.hutao@cn.fujitsu.com>
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/28 20:12:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/28 20:12:21,
	Serialize complete at 2013/02/28 20:12:21
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
index bf974b4..d65218d 100644
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
1.8.1.4

