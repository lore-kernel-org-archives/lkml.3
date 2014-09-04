Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaIDQde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:33:34 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:35884 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754394AbaIDQbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:31:19 -0400
X-Yandex-Uniq: d039100b-2886-4d04-8167-d67186a168c6
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 13/19] smart: nosmart boot option
Date: Thu,  4 Sep 2014 20:30:59 +0400
Message-Id: <1409848265-17150-13-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

This patch introduces nosmart boot option, that is intended to disable
smart globally at boot time.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 kernel/sched/rt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index a3fd83c..ff7751a 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2319,6 +2319,13 @@ static int cpu_with_number(int number, cpumask_t *mask)
 	return -1;
 }
 
+static int __init nosmart_setup(char *str)
+{
+	static_key_slow_dec(&__smart_enabled);
+	return 0;
+}
+early_param("nosmart", nosmart_setup);
+
 void build_smart_topology(void)
 {
 	int cpu;
-- 
1.9.3

