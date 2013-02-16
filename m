Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3BPIh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 03:37:26 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61111 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3BPIhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 03:37:19 -0500
From: Robert Berger <git.rber@gmail.com>
To: devel@driverdev.osuosl.org, konrad.wilk@oracle.com
Cc: gregkh@linuxfoundation.org, sjenning@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, minchan@kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com, git.rber@gmail.com,
        Robert Berger <rber.git@ReliableEmbeddedSystems.com>
Subject: [PATCH 4/4] staging/zcache KBUILD_MODNAME instead of "ramster: "
Date: Sat, 16 Feb 2013 10:35:54 +0200
Message-Id: <1361003754-22512-5-git-send-email-rber.git@ReliableEmbeddedSystems.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361003754-22512-1-git-send-email-rber.git@ReliableEmbeddedSystems.com>
References: <git.rber@gmail.com>
 <1361003754-22512-1-git-send-email-rber.git@ReliableEmbeddedSystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert Berger <rber.git@ReliableEmbeddedSystems.com>
---
 drivers/staging/zcache/ramster/tcp.c |   36 ++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/zcache/ramster/tcp.c b/drivers/staging/zcache/ramster/tcp.c
index aa2a1a7..9ba279a 100644
--- a/drivers/staging/zcache/ramster/tcp.c
+++ b/drivers/staging/zcache/ramster/tcp.c
@@ -53,6 +53,8 @@
  * and only accepts the connection if the higher numbered node is heartbeating.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
 #include <linux/slab.h>
@@ -541,7 +543,7 @@ static void r2net_set_nn_state(struct r2net_node *nn,
 	}
 
 	if (was_valid && !valid) {
-		pr_notice("ramster: No longer connected to " SC_NODEF_FMT "\n",
+		pr_notice("No longer connected to " SC_NODEF_FMT "\n",
 			old_sc->sc_node->nd_name, old_sc->sc_node->nd_num,
 			&old_sc->sc_node->nd_ipv4_address,
 			ntohs(old_sc->sc_node->nd_ipv4_port));
@@ -550,7 +552,7 @@ static void r2net_set_nn_state(struct r2net_node *nn,
 
 	if (!was_valid && valid) {
 		cancel_delayed_work(&nn->nn_connect_expired);
-		pr_notice("ramster: %s " SC_NODEF_FMT "\n",
+		pr_notice("%s " SC_NODEF_FMT "\n",
 		       r2nm_this_node() > sc->sc_node->nd_num ?
 		       "Connected to" : "Accepted connection from",
 		       sc->sc_node->nd_name, sc->sc_node->nd_num,
@@ -643,7 +645,7 @@ static void r2net_state_change(struct sock *sk)
 		r2net_sc_queue_work(sc, &sc->sc_connect_work);
 		break;
 	default:
-		pr_info("ramster: Connection to "
+		pr_info("Connection to "
 			SC_NODEF_FMT " shutdown, state %d\n",
 			sc->sc_node->nd_name, sc->sc_node->nd_num,
 			&sc->sc_node->nd_ipv4_address,
@@ -1395,7 +1397,7 @@ static int r2net_check_handshake(struct r2net_sock_container *sc)
 	struct r2net_node *nn = r2net_nn_from_num(sc->sc_node->nd_num);
 
 	if (hand->protocol_version != cpu_to_be64(R2NET_PROTOCOL_VERSION)) {
-		pr_notice("ramster: " SC_NODEF_FMT " Advertised net "
+		pr_notice(" " SC_NODEF_FMT " Advertised net "
 		       "protocol version %llu but %llu is required. "
 		       "Disconnecting.\n", sc->sc_node->nd_name,
 			sc->sc_node->nd_num, &sc->sc_node->nd_ipv4_address,
@@ -1415,7 +1417,7 @@ static int r2net_check_handshake(struct r2net_sock_container *sc)
 	 */
 	if (be32_to_cpu(hand->r2net_idle_timeout_ms) !=
 				r2net_idle_timeout()) {
-		pr_notice("ramster: " SC_NODEF_FMT " uses a network "
+		pr_notice(" " SC_NODEF_FMT " uses a network "
 		       "idle timeout of %u ms, but we use %u ms locally. "
 		       "Disconnecting.\n", sc->sc_node->nd_name,
 			sc->sc_node->nd_num, &sc->sc_node->nd_ipv4_address,
@@ -1428,7 +1430,7 @@ static int r2net_check_handshake(struct r2net_sock_container *sc)
 
 	if (be32_to_cpu(hand->r2net_keepalive_delay_ms) !=
 			r2net_keepalive_delay()) {
-		pr_notice("ramster: " SC_NODEF_FMT " uses a keepalive "
+		pr_notice(" " SC_NODEF_FMT " uses a keepalive "
 		       "delay of %u ms, but we use %u ms locally. "
 		       "Disconnecting.\n", sc->sc_node->nd_name,
 			sc->sc_node->nd_num, &sc->sc_node->nd_ipv4_address,
@@ -1441,7 +1443,7 @@ static int r2net_check_handshake(struct r2net_sock_container *sc)
 
 	if (be32_to_cpu(hand->r2hb_heartbeat_timeout_ms) !=
 			R2HB_MAX_WRITE_TIMEOUT_MS) {
-		pr_notice("ramster: " SC_NODEF_FMT " uses a heartbeat "
+		pr_notice(" " SC_NODEF_FMT " uses a heartbeat "
 		       "timeout of %u ms, but we use %u ms locally. "
 		       "Disconnecting.\n", sc->sc_node->nd_name,
 			sc->sc_node->nd_num, &sc->sc_node->nd_ipv4_address,
@@ -1669,7 +1671,7 @@ static void r2net_idle_timer(unsigned long data)
 	unsigned long msecs = r2net_idle_timeout();
 #endif
 
-	pr_notice("ramster: Connection to " SC_NODEF_FMT " has been "
+	pr_notice("Connection to " SC_NODEF_FMT " has been "
 	       "idle for %lu.%lu secs, shutting it down.\n",
 		sc->sc_node->nd_name, sc->sc_node->nd_num,
 		&sc->sc_node->nd_ipv4_address, ntohs(sc->sc_node->nd_ipv4_port),
@@ -1805,7 +1807,7 @@ static void r2net_start_connect(struct work_struct *work)
 
 out:
 	if (ret) {
-		pr_notice("ramster: Connect attempt to " SC_NODEF_FMT
+		pr_notice("Connect attempt to " SC_NODEF_FMT
 		       " failed with errno %d\n", sc->sc_node->nd_name,
 			sc->sc_node->nd_num, &sc->sc_node->nd_ipv4_address,
 			ntohs(sc->sc_node->nd_ipv4_port), ret);
@@ -1831,7 +1833,7 @@ static void r2net_connect_expired(struct work_struct *work)
 
 	spin_lock(&nn->nn_lock);
 	if (!nn->nn_sc_valid) {
-		pr_notice("ramster: No connection established with "
+		pr_notice("No connection established with "
 		       "node %u after %u.%u seconds, giving up.\n",
 		     r2net_num_from_nn(nn),
 		     r2net_idle_timeout() / 1000,
@@ -1967,7 +1969,7 @@ static int r2net_accept_one(struct socket *sock)
 
 	node = r2nm_get_node_by_ip(sin.sin_addr.s_addr);
 	if (node == NULL) {
-		pr_notice("ramster: Attempt to connect from unknown "
+		pr_notice("Attempt to connect from unknown "
 		       "node at %pI4:%d\n", &sin.sin_addr.s_addr,
 		       ntohs(sin.sin_port));
 		ret = -EINVAL;
@@ -1976,7 +1978,7 @@ static int r2net_accept_one(struct socket *sock)
 
 	if (r2nm_this_node() >= node->nd_num) {
 		local_node = r2nm_get_node_by_num(r2nm_this_node());
-		pr_notice("ramster: Unexpected connect attempt seen "
+		pr_notice("Unexpected connect attempt seen "
 		       "at node '%s' (%u, %pI4:%d) from node '%s' (%u, "
 		       "%pI4:%d)\n", local_node->nd_name, local_node->nd_num,
 		       &(local_node->nd_ipv4_address),
@@ -2006,7 +2008,7 @@ static int r2net_accept_one(struct socket *sock)
 		ret = 0;
 	spin_unlock(&nn->nn_lock);
 	if (ret) {
-		pr_notice("ramster: Attempt to connect from node '%s' "
+		pr_notice("Attempt to connect from node '%s' "
 		       "at %pI4:%d but it already has an open connection\n",
 		       node->nd_name, &sin.sin_addr.s_addr,
 		       ntohs(sin.sin_port));
@@ -2089,7 +2091,7 @@ static int r2net_open_listening_sock(__be32 addr, __be16 port)
 
 	ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP, &sock);
 	if (ret < 0) {
-		pr_err("ramster: Error %d while creating socket\n", ret);
+		pr_err("Error %d while creating socket\n", ret);
 		goto out;
 	}
 
@@ -2106,14 +2108,14 @@ static int r2net_open_listening_sock(__be32 addr, __be16 port)
 	sock->sk->sk_reuse = /* SK_CAN_REUSE FIXME FOR 3.4 */ 1;
 	ret = sock->ops->bind(sock, (struct sockaddr *)&sin, sizeof(sin));
 	if (ret < 0) {
-		pr_err("ramster: Error %d while binding socket at %pI4:%u\n",
+		pr_err("Error %d while binding socket at %pI4:%u\n",
 			ret, &addr, ntohs(port));
 		goto out;
 	}
 
 	ret = sock->ops->listen(sock, 64);
 	if (ret < 0)
-		pr_err("ramster: Error %d while listening on %pI4:%u\n",
+		pr_err("Error %d while listening on %pI4:%u\n",
 		       ret, &addr, ntohs(port));
 
 out:
@@ -2193,7 +2195,7 @@ void r2net_hb_node_up_manual(int node_num)
 {
 	struct r2nm_node dummy;
 	if (r2nm_single_cluster == NULL)
-		pr_err("ramster: cluster not alive, node_up_manual ignored\n");
+		pr_err("cluster not alive, node_up_manual ignored\n");
 	else {
 		r2hb_manual_set_node_heartbeating(node_num);
 		r2net_hb_node_up_cb(&dummy, node_num, NULL);
-- 
1.7.9.5

