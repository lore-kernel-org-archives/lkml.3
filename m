Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3EIKjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:39:53 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:62181 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab3EIKjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:39:51 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Denis Efremov <yefremov.denis@gmail.com>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 16/21] sparc: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 14:36:54 +0400
Message-Id: <1368095819-11011-5-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL and inline directives are contradictory to each other.
The patch fixes this inconsistency.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 arch/sparc/prom/tree_64.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/sparc/prom/tree_64.c b/arch/sparc/prom/tree_64.c
index 92204c3..75e4c44 100644
--- a/arch/sparc/prom/tree_64.c
+++ b/arch/sparc/prom/tree_64.c
@@ -39,7 +39,7 @@ inline phandle __prom_getchild(phandle node)
 	return prom_node_to_node("child", node);
 }
 
-inline phandle prom_getchild(phandle node)
+phandle prom_getchild(phandle node)
 {
 	phandle cnode;
 
@@ -72,7 +72,7 @@ inline phandle __prom_getsibling(phandle node)
 	return prom_node_to_node(prom_peer_name, node);
 }
 
-inline phandle prom_getsibling(phandle node)
+phandle prom_getsibling(phandle node)
 {
 	phandle sibnode;
 
@@ -89,7 +89,7 @@ EXPORT_SYMBOL(prom_getsibling);
 /* Return the length in bytes of property 'prop' at node 'node'.
  * Return -1 on error.
  */
-inline int prom_getproplen(phandle node, const char *prop)
+int prom_getproplen(phandle node, const char *prop)
 {
 	unsigned long args[6];
 
@@ -113,7 +113,7 @@ EXPORT_SYMBOL(prom_getproplen);
  * 'buffer' which has a size of 'bufsize'.  If the acquisition
  * was successful the length will be returned, else -1 is returned.
  */
-inline int prom_getproperty(phandle node, const char *prop,
+int prom_getproperty(phandle node, const char *prop,
 			    char *buffer, int bufsize)
 {
 	unsigned long args[8];
@@ -141,7 +141,7 @@ EXPORT_SYMBOL(prom_getproperty);
 /* Acquire an integer property and return its value.  Returns -1
  * on failure.
  */
-inline int prom_getint(phandle node, const char *prop)
+int prom_getint(phandle node, const char *prop)
 {
 	int intprop;
 
@@ -235,7 +235,7 @@ static const char *prom_nextprop_name = "nextprop";
 /* Return the first property type for node 'node'.
  * buffer should be at least 32B in length
  */
-inline char *prom_firstprop(phandle node, char *buffer)
+char *prom_firstprop(phandle node, char *buffer)
 {
 	unsigned long args[7];
 
@@ -261,7 +261,7 @@ EXPORT_SYMBOL(prom_firstprop);
  * at node 'node' .  Returns NULL string if no more
  * property types for this node.
  */
-inline char *prom_nextprop(phandle node, const char *oprop, char *buffer)
+char *prom_nextprop(phandle node, const char *oprop, char *buffer)
 {
 	unsigned long args[7];
 	char buf[32];
-- 
1.8.1.4

