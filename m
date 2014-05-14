Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaENVdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:33:41 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35873 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaENVdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:33:39 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: socklnd: Remove unnecessary () from return statement
Date: Wed, 14 May 2014 22:33:37 +0100
Message-Id: <1400103217-13413-1-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary brackets from return statements in socklnd.c
to meet kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |   42 ++++++++++----------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index 21d36ee..b42d283 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -58,10 +58,10 @@ ksocknal_ip2iface(lnet_ni_t *ni, __u32 ip)
 		iface = &net->ksnn_interfaces[i];
 
 		if (iface->ksni_ipaddr == ip)
-			return (iface);
+			return iface;
 	}
 
-	return (NULL);
+	return NULL;
 }
 
 ksock_route_t *
@@ -71,7 +71,7 @@ ksocknal_create_route (__u32 ipaddr, int port)
 
 	LIBCFS_ALLOC (route, sizeof (*route));
 	if (route == NULL)
-		return (NULL);
+		return NULL;
 
 	atomic_set (&route->ksnr_refcount, 1);
 	route->ksnr_peer = NULL;
@@ -85,7 +85,7 @@ ksocknal_create_route (__u32 ipaddr, int port)
 	route->ksnr_conn_count = 0;
 	route->ksnr_share_count = 0;
 
-	return (route);
+	return route;
 }
 
 void
@@ -197,9 +197,9 @@ ksocknal_find_peer_locked (lnet_ni_t *ni, lnet_process_id_t id)
 		CDEBUG(D_NET, "got peer [%p] -> %s (%d)\n",
 		       peer, libcfs_id2str(id),
 		       atomic_read(&peer->ksnp_refcount));
-		return (peer);
+		return peer;
 	}
-	return (NULL);
+	return NULL;
 }
 
 ksock_peer_t *
@@ -213,7 +213,7 @@ ksocknal_find_peer (lnet_ni_t *ni, lnet_process_id_t id)
 		ksocknal_peer_addref(peer);
 	read_unlock(&ksocknal_data.ksnd_global_lock);
 
-	return (peer);
+	return peer;
 }
 
 void
@@ -318,7 +318,7 @@ ksocknal_get_peer_info (lnet_ni_t *ni, int index,
 	}
  out:
 	read_unlock(&ksocknal_data.ksnd_global_lock);
-	return (rc);
+	return rc;
 }
 
 void
@@ -506,7 +506,7 @@ ksocknal_add_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ipaddr, int port)
 
 	write_unlock_bh(&ksocknal_data.ksnd_global_lock);
 
-	return (0);
+	return 0;
 }
 
 void
@@ -620,7 +620,7 @@ ksocknal_del_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ip)
 
 	ksocknal_txlist_done(ni, &zombies, 1);
 
-	return (rc);
+	return rc;
 }
 
 ksock_conn_t *
@@ -652,13 +652,13 @@ ksocknal_get_conn_by_idx (lnet_ni_t *ni, int index)
 				ksocknal_conn_addref(conn);
 				read_unlock(&ksocknal_data. \
 						 ksnd_global_lock);
-				return (conn);
+				return conn;
 			}
 		}
 	}
 
 	read_unlock(&ksocknal_data.ksnd_global_lock);
-	return (NULL);
+	return NULL;
 }
 
 ksock_sched_t *
@@ -709,7 +709,7 @@ ksocknal_local_ipvec (lnet_ni_t *ni, __u32 *ipaddrs)
 	}
 
 	read_unlock(&ksocknal_data.ksnd_global_lock);
-	return (nip);
+	return nip;
 }
 
 int
@@ -741,7 +741,7 @@ ksocknal_match_peerip (ksock_interface_t *iface, __u32 *ips, int nips)
 	}
 
 	LASSERT (best >= 0);
-	return (best);
+	return best;
 }
 
 int
@@ -847,7 +847,7 @@ ksocknal_select_ips(ksock_peer_t *peer, __u32 *peerips, int n_peerips)
 
 	write_unlock_bh(global_lock);
 
-	return (n_ips);
+	return n_ips;
 }
 
 void
@@ -1709,7 +1709,7 @@ ksocknal_close_peer_conns_locked (ksock_peer_t *peer, __u32 ipaddr, int why)
 		}
 	}
 
-	return (count);
+	return count;
 }
 
 int
@@ -1725,7 +1725,7 @@ ksocknal_close_conn_and_siblings (ksock_conn_t *conn, int why)
 
 	write_unlock_bh(&ksocknal_data.ksnd_global_lock);
 
-	return (count);
+	return count;
 }
 
 int
@@ -1766,7 +1766,7 @@ ksocknal_close_matching_conns (lnet_process_id_t id, __u32 ipaddr)
 
 	/* wildcards always succeed */
 	if (id.nid == LNET_NID_ANY || id.pid == LNET_PID_ANY || ipaddr == 0)
-		return (0);
+		return 0;
 
 	if (count == 0)
 		return -ENOENT;
@@ -1937,7 +1937,7 @@ ksocknal_push (lnet_ni_t *ni, lnet_process_id_t id)
 
 	}
 
-	return (rc);
+	return rc;
 }
 
 int
@@ -1999,7 +1999,7 @@ ksocknal_add_interface(lnet_ni_t *ni, __u32 ipaddress, __u32 netmask)
 
 	write_unlock_bh(&ksocknal_data.ksnd_global_lock);
 
-	return (rc);
+	return rc;
 }
 
 void
@@ -2088,7 +2088,7 @@ ksocknal_del_interface(lnet_ni_t *ni, __u32 ipaddress)
 
 	write_unlock_bh(&ksocknal_data.ksnd_global_lock);
 
-	return (rc);
+	return rc;
 }
 
 int
-- 
1.7.9.5

