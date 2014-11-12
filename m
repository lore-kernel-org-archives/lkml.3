Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965781AbaKLBtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:49:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964953AbaKLBtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:49:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Honggang Li <enjoymindful@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.10 007/123] Revert "percpu: free percpu allocation info for uniprocessor system"
Date: Wed, 12 Nov 2014 10:16:13 +0900
Message-Id: <20141112011719.323360282@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit bb2e226b3bef596dd56be97df655d857b4603923 upstream.

This reverts commit 3189eddbcafc ("percpu: free percpu allocation info for
uniprocessor system").

The commit causes a hang with a crisv32 image. This may be an architecture
problem, but at least for now the revert is necessary to be able to boot a
crisv32 image.

Cc: Tejun Heo <tj@kernel.org>
Cc: Honggang Li <enjoymindful@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 3189eddbcafc ("percpu: free percpu allocation info for uniprocessor system")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/percpu.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1910,8 +1910,6 @@ void __init setup_per_cpu_areas(void)
 
 	if (pcpu_setup_first_chunk(ai, fc) < 0)
 		panic("Failed to initialize percpu areas.");
-
-	pcpu_free_alloc_info(ai);
 }
 
 #endif	/* CONFIG_SMP */


