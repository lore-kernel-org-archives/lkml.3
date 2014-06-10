Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaFJQ5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:57:06 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60618 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbaFJQ5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:57:05 -0400
Date: Tue, 10 Jun 2014 09:57:00 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH] of: avoid format string parsing in kobject names
Message-ID: <20140610165700.GA3453@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure a format string cannot leak into the kobject name that
is constructed. (And splits the >80 character line.)

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/of/base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 8368d96ae7b4..f27d922eaece 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -227,7 +227,8 @@ static int __of_node_add(struct device_node *np)
 	np->kobj.kset = of_kset;
 	if (!np->parent) {
 		/* Nodes without parents are new top level trees */
-		rc = kobject_add(&np->kobj, NULL, safe_name(&of_kset->kobj, "base"));
+		rc = kobject_add(&np->kobj, NULL, "%s",
+				 safe_name(&of_kset->kobj, "base"));
 	} else {
 		name = safe_name(&np->parent->kobj, kbasename(np->full_name));
 		if (!name || !name[0])
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
