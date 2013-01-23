Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3AWHUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 02:20:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:37864 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab3AWHTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 02:19:40 -0500
X-IronPort-AV: E=Sophos;i="4.84,521,1355068800"; 
   d="scan'208";a="6634053"
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
Subject: [PATCH v12 rebased 8/8] pv event: add document to describe the usage
Date: Wed, 23 Jan 2013 15:19:29 +0800
Message-Id: <0820809186232c03f3ce8187d587cfd8f14f16b8.1358920534.git.hutao@cn.fujitsu.com>
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

Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 docs/pv-event.txt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 docs/pv-event.txt

diff --git a/docs/pv-event.txt b/docs/pv-event.txt
new file mode 100644
index 0000000..ac9e7fa
--- /dev/null
+++ b/docs/pv-event.txt
@@ -0,0 +1,17 @@
+KVM PV EVENT
+============
+
+kvm pv event allows guest OS to notify host OS of some events, for
+example, guest panic. Currently, there is one event supported, that
+is, guest panic. More events can be added later.
+
+By default, kvm pv event is disabled. In order to enable it, you have
+to specify enable_pv_event=on for -machine command line option, along
+with -global kvm_pv_event.panicked_action to specify the action taken
+when panic event has occurred. Aviable panic actions are: "none",
+"pause", "poweroff" and "reset". Following is example:
+
+  qemu-system-x86_64 -enable-kvm -machine pc-0.12,enable_pv_event=on \
+    -global kvm_pv_event.panicked_action=pause <other options>
+
+kvm pv event needs kvm support.
-- 
1.8.0.1.240.ge8a1f5a

