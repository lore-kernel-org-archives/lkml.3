Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab3DLEvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 00:51:22 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9615 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3DLEvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 00:51:21 -0400
X-Spam-Score: -100.8
Message-ID: <516792A6.9050904@asianux.com>
Date: Fri, 12 Apr 2013 12:50:46 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: audit_watch: resource management: better reset to
 NULL.
References: <516790ED.6060202@asianux.com>
In-Reply-To: <516790ED.6060202@asianux.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  better to set krule->watch = NULL.
  maybe it is not a real issue, but can make code clearer,
  so can help the readers to analyse another issues.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/audit_watch.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
index 22831c4..abd8fdb 100644
--- a/kernel/audit_watch.c
+++ b/kernel/audit_watch.c
@@ -456,6 +456,7 @@ void audit_remove_watch_rule(struct audit_krule *krule)
 
 	if (list_empty(&watch->rules)) {
 		audit_remove_watch(watch);
+		krule->watch = NULL;
 
 		if (list_empty(&parent->watches)) {
 			audit_get_parent(parent);
-- 
1.7.7.6
