Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3G2GYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 02:24:21 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53178 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab3G2GYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 02:24:20 -0400
Date: Mon, 29 Jul 2013 14:24:12 +0800
From: Shaohua Li <shli@kernel.org>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch]workqueue: copy attr with all fields.
Message-ID: <20130729062412.GA6448@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_workqueue_attrs() forgets to copy no_numa field.

Signed-off-by: Shaohua Li <shli@fuisonio.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0b72e81..a988f54 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3411,6 +3411,7 @@ static void copy_workqueue_attrs(struct workqueue_attrs *to,
 {
 	to->nice = from->nice;
 	cpumask_copy(to->cpumask, from->cpumask);
+	to->no_numa = from->no_numa;
 }
 
 /* hash value of the content of @attr */
