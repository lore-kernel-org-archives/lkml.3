Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750AbaGOTsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:48:15 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:11512 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933168AbaGOTsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:48:12 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokRAE6ExVNbsm9N/2dsb2JhbABZgw6BKaw8CwUBbpwAgRAXdYRgI4EaN4hGAco5F4V7iVAdhC0FkB+KeYtZiEyDRjsv
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-cachefs@redhat.com
Subject: [PATCH 1/1] fs/fscache: make ctl_table static
Date: Tue, 15 Jul 2014 21:49:08 +0200
Message-Id: <1405453748-11299-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fscache_sysctls and fscache_sysctls_root
are only used in main.c

Cc: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: linux-cachefs@redhat.com
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---

This is untested.

 fs/fscache/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 63f868e..3248c15 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -67,7 +67,7 @@ static int fscache_max_active_sysctl(struct ctl_table *table, int write,
 	return ret;
 }
 
-struct ctl_table fscache_sysctls[] = {
+static struct ctl_table fscache_sysctls[] = {
 	{
 		.procname	= "object_max_active",
 		.data		= &fscache_object_max_active,
@@ -87,7 +87,7 @@ struct ctl_table fscache_sysctls[] = {
 	{}
 };
 
-struct ctl_table fscache_sysctls_root[] = {
+static struct ctl_table fscache_sysctls_root[] = {
 	{
 		.procname	= "fscache",
 		.mode		= 0555,
-- 
1.8.4.5

