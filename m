Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaB0LO5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:14:57 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:64763 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaB0LOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:14:55 -0500
Date: Thu, 27 Feb 2014 16:44:46 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Chen Gong <gong.chen@linux.intel.com>, Kevin Hao <haokexin@gmail.com>,
        josh@joshtriplett.org
Subject: [PATCH 04/46] kernel: Mark function as static in kernel/resource.c
Message-ID: <c216e1f98b80cff1736617fbf1474ea4dbaa4b4f.1393493276.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function as static in kernel/resource.c because it is not used
outside this file.

This eliminates the following warning in kernel/resource.c:
kernel/resource.c:518:5: warning: no previous prototype for ‘reallocate_resource’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/resource.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 3f285dc..ede7db2 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -515,9 +515,9 @@ static int find_resource(struct resource *root, struct resource *new,
  * @newsize: new size of the resource descriptor
  * @constraint: the size and alignment constraints to be met.
  */
-int reallocate_resource(struct resource *root, struct resource *old,
-			resource_size_t newsize,
-			struct resource_constraint  *constraint)
+static int reallocate_resource(struct resource *root, struct resource *old,
+			      resource_size_t newsize,
+			      struct resource_constraint  *constraint)
 {
 	int err=0;
 	struct resource new = *old;
-- 
1.7.9.5

