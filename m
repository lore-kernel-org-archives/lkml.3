Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab3CTJZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:25:08 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:47043 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135Ab3CTJZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:25:03 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: ben@decadent.org.uk, noelamac@gmail.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, andi@firstfloor.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFC 29/30] compat: embrace LINUX_BACKPORT() for uidgid
Date: Wed, 20 Mar 2013 02:22:54 -0700
Message-Id: <1363771375-31715-30-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
References: <1363771375-31715-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

1   2.6.24              [  OK  ]
2   2.6.25              [  OK  ]
3   2.6.26              [  OK  ]
4   2.6.27              [  OK  ]
5   2.6.28              [  OK  ]
6   2.6.29              [  OK  ]
7   2.6.30              [  OK  ]
8   2.6.31              [  OK  ]
9   2.6.32              [  OK  ]
10  2.6.33              [  OK  ]
11  2.6.34              [  OK  ]
12  2.6.35              [  OK  ]
13  2.6.36              [  OK  ]
14  2.6.37              [  OK  ]
15  2.6.38              [  OK  ]
16  2.6.39              [  OK  ]
17  3.0.65              [  OK  ]
18  3.1.10              [  OK  ]
19  3.2.38              [  OK  ]
20  3.3.8               [  OK  ]
21  3.4.32              [  OK  ]
22  3.5.7               [  OK  ]
23  3.6.11              [  OK  ]
24  3.7.9               [  OK  ]
25  3.8.0               [  OK  ]
26  3.9-rc1             [  OK  ]

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 include/linux/uidgid.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
index d9e4224..ae1ed80 100644
--- a/include/linux/uidgid.h
+++ b/include/linux/uidgid.h
@@ -133,19 +133,27 @@ static inline bool gid_valid(kgid_t gid)
 
 #ifdef CONFIG_USER_NS
 
+#define make_kuid LINUX_BACKPORT(make_kuid)
 extern kuid_t make_kuid(struct user_namespace *from, uid_t uid);
+#define make_kgid LINUX_BACKPORT(make_kgid)
 extern kgid_t make_kgid(struct user_namespace *from, gid_t gid);
 
+#define from_kuid LINUX_BACKPORT(from_kuid)
 extern uid_t from_kuid(struct user_namespace *to, kuid_t uid);
+#define from_kgid LINUX_BACKPORT(from_kgid)
 extern gid_t from_kgid(struct user_namespace *to, kgid_t gid);
+#define from_kuid_munged LINUX_BACKPORT(from_kuid_munged)
 extern uid_t from_kuid_munged(struct user_namespace *to, kuid_t uid);
+#define from_kgid_munged LINUX_BACKPORT(from_kgid_munged)
 extern gid_t from_kgid_munged(struct user_namespace *to, kgid_t gid);
 
+#define kuid_has_mapping LINUX_BACKPORT(kuid_has_mapping)
 static inline bool kuid_has_mapping(struct user_namespace *ns, kuid_t uid)
 {
 	return from_kuid(ns, uid) != (uid_t) -1;
 }
 
+#define kgid_has_mapping LINUX_BACKPORT(kgid_has_mapping)
 static inline bool kgid_has_mapping(struct user_namespace *ns, kgid_t gid)
 {
 	return from_kgid(ns, gid) != (gid_t) -1;
@@ -153,26 +161,31 @@ static inline bool kgid_has_mapping(struct user_namespace *ns, kgid_t gid)
 
 #else
 
+#define make_kuid LINUX_BACKPORT(make_kuid)
 static inline kuid_t make_kuid(struct user_namespace *from, uid_t uid)
 {
 	return KUIDT_INIT(uid);
 }
 
+#define make_kgid LINUX_BACKPORT(make_kgid)
 static inline kgid_t make_kgid(struct user_namespace *from, gid_t gid)
 {
 	return KGIDT_INIT(gid);
 }
 
+#define from_kuid LINUX_BACKPORT(from_kuid)
 static inline uid_t from_kuid(struct user_namespace *to, kuid_t kuid)
 {
 	return __kuid_val(kuid);
 }
 
+#define from_kgid LINUX_BACKPORT(from_kgid)
 static inline gid_t from_kgid(struct user_namespace *to, kgid_t kgid)
 {
 	return __kgid_val(kgid);
 }
 
+#define from_kuid_munged LINUX_BACKPORT(from_kuid_munged)
 static inline uid_t from_kuid_munged(struct user_namespace *to, kuid_t kuid)
 {
 	uid_t uid = from_kuid(to, kuid);
@@ -181,6 +194,7 @@ static inline uid_t from_kuid_munged(struct user_namespace *to, kuid_t kuid)
 	return uid;
 }
 
+#define from_kgid_munged LINUX_BACKPORT(from_kgid_munged)
 static inline gid_t from_kgid_munged(struct user_namespace *to, kgid_t kgid)
 {
 	gid_t gid = from_kgid(to, kgid);
@@ -189,11 +203,13 @@ static inline gid_t from_kgid_munged(struct user_namespace *to, kgid_t kgid)
 	return gid;
 }
 
+#define kuid_has_mapping LINUX_BACKPORT(kuid_has_mapping)
 static inline bool kuid_has_mapping(struct user_namespace *ns, kuid_t uid)
 {
 	return true;
 }
 
+#define kgid_has_mapping LINUX_BACKPORT(kgid_has_mapping)
 static inline bool kgid_has_mapping(struct user_namespace *ns, kgid_t gid)
 {
 	return true;
-- 
1.7.10.4

