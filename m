Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaEGUfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:35:19 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:22590 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009AbaEGUfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:35:15 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQXABOYalNXQBiQ/2dsb2JhbABagwaCQXyoawoFAZoKAgKBHRd0gmYcIxiBAiQTiEUB0DOFVoh8hEYBA48bihsBknuDNjs
Date: Wed, 7 May 2014 22:35:08 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/1] kernel/profile.c: use static const char instead of
 static char
Message-Id: <20140507223508.0fd3f59111f3d870859119fd@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

schedstr, sleepstr and kvmstr are only used in strcmp & strlen

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/profile.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index cb980f0..f8132a2 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -52,9 +52,9 @@ static DEFINE_MUTEX(profile_flip_mutex);
 
 int profile_setup(char *str)
 {
-	static char schedstr[] = "schedule";
-	static char sleepstr[] = "sleep";
-	static char kvmstr[] = "kvm";
+	static const char schedstr[] = "schedule";
+	static const char sleepstr[] = "sleep";
+	static const char kvmstr[] = "kvm";
 	int par;
 
 	if (!strncmp(str, sleepstr, strlen(sleepstr))) {
-- 
1.8.4.5

