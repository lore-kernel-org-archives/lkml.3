Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab3AUMQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:16:15 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:41316
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964Ab3AUMDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:03:11 -0500
X-IronPort-AV: E=Sophos;i="4.84,506,1355094000"; 
   d="scan'208";a="169187830"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Paul Mundt <lethal@linux-sh.org>
Cc: kernel-janitors@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/15] drivers/sh/intc/of_intc.c: adjust duplicate test
Date: Mon, 21 Jan 2013 14:02:45 +0100
Message-Id: <1358773378-4700-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive tests to the same location.  In this case intc_node has
already been tested for being NULL, and calling of_find_node_by_name will
not make it NULL.  On the other hand, of_find_node_by_name can return NULL
on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@s exists@
local idexpression y;
expression x,e;
@@

*if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
 { ... when forall
   return ...; }
... when != \(y = e\|y += e\|y -= e\|y |= e\|y &= e\|y++\|y--\|&y\)
    when != \(XT_GETPAGE(...,y)\|WMI_CMD_BUF(...)\)
*if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
 { ... when forall
   return ...; }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/sh/intc/of_intc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/sh/intc/of_intc.c b/drivers/sh/intc/of_intc.c
index 1d5f47e..8dfded3 100644
--- a/drivers/sh/intc/of_intc.c
+++ b/drivers/sh/intc/of_intc.c
@@ -330,7 +330,7 @@ static int __init of_sh_intc_get_prio(struct device_node *np,
 
 		reg_node = of_find_node_by_name(intc_node, node_name);
 
-		if (!intc_node) {
+		if (!reg_node) {
 			pr_err("INTC prio register not found\n");
 			ret = -EINVAL;
 			goto error;
@@ -386,7 +386,7 @@ static int __init of_sh_intc_get_sense(struct device_node *np,
 
 		reg_node = of_find_node_by_name(intc_node, node_name);
 
-		if (!intc_node) {
+		if (!reg_node) {
 			pr_err("INTC senses register not found\n");
 			ret = -EINVAL;
 			goto error;

