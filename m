Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaEORyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:54:11 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:64528 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaEORyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:54:08 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org
Cc: bergwolf@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: socklnd: Remove unnecessary return brackets
Date: Thu, 15 May 2014 18:54:05 +0100
Message-Id: <1400176445-4564-1-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary brackets from return statements in socklnd.c,
socklnd.h, socklnd_cb.c and socklnd_lib-linux.c to meet
kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |    6 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd.h    |    4 +-
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |   82 ++++++++++----------
 .../lustre/lnet/klnds/socklnd/socklnd_lib-linux.c  |   26 +++----
 4 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
index a391d13..1fb1f8e 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.c
@@ -459,7 +459,7 @@ ksocknal_add_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ipaddr, int port)
 
 	if (id.nid == LNET_NID_ANY ||
 	    id.pid == LNET_PID_ANY)
-		return (-EINVAL);
+		return -EINVAL;
 
 	/* Have a brand new peer ready... */
 	rc = ksocknal_create_peer(&peer, ni, id);
@@ -469,7 +469,7 @@ ksocknal_add_peer (lnet_ni_t *ni, lnet_process_id_t id, __u32 ipaddr, int port)
 	route = ksocknal_create_route (ipaddr, port);
 	if (route == NULL) {
 		ksocknal_peer_decref(peer);
-		return (-ENOMEM);
+		return -ENOMEM;
 	}
 
 	write_lock_bh(&ksocknal_data.ksnd_global_lock);
@@ -1951,7 +1951,7 @@ ksocknal_add_interface(lnet_ni_t *ni, __u32 ipaddress, __u32 netmask)
 
 	if (ipaddress == 0 ||
 	    netmask == 0)
-		return (-EINVAL);
+		return -EINVAL;
 
 	write_lock_bh(&ksocknal_data.ksnd_global_lock);
 
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h
index df2be7a..109a239 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd.h
@@ -418,7 +418,7 @@ ksocknal_nid2peerlist (lnet_nid_t nid)
 {
 	unsigned int hash = ((unsigned int)nid) % ksocknal_data.ksnd_peer_hash_size;
 
-	return (&ksocknal_data.ksnd_peers [hash]);
+	return &ksocknal_data.ksnd_peers[hash];
 }
 
 static inline void
@@ -452,7 +452,7 @@ ksocknal_connsock_addref (ksock_conn_t *conn)
 	}
 	read_unlock(&ksocknal_data.ksnd_global_lock);
 
-	return (rc);
+	return rc;
 }
 
 static inline void
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index bdf95ea..75bd658 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -120,7 +120,7 @@ ksocknal_send_iov (ksock_conn_t *conn, ksock_tx_t *tx)
 	rc = ksocknal_lib_send_iov(conn, tx);
 
 	if (rc <= 0)			    /* sent nothing? */
-		return (rc);
+		return rc;
 
 	nob = rc;
 	LASSERT (nob <= tx->tx_resid);
@@ -133,7 +133,7 @@ ksocknal_send_iov (ksock_conn_t *conn, ksock_tx_t *tx)
 		if (nob < (int) iov->iov_len) {
 			iov->iov_base = (void *)((char *)iov->iov_base + nob);
 			iov->iov_len -= nob;
-			return (rc);
+			return rc;
 		}
 
 		nob -= iov->iov_len;
@@ -141,7 +141,7 @@ ksocknal_send_iov (ksock_conn_t *conn, ksock_tx_t *tx)
 		tx->tx_niov--;
 	} while (nob != 0);
 
-	return (rc);
+	return rc;
 }
 
 int
@@ -158,7 +158,7 @@ ksocknal_send_kiov (ksock_conn_t *conn, ksock_tx_t *tx)
 	rc = ksocknal_lib_send_kiov(conn, tx);
 
 	if (rc <= 0)			    /* sent nothing? */
-		return (rc);
+		return rc;
 
 	nob = rc;
 	LASSERT (nob <= tx->tx_resid);
@@ -179,7 +179,7 @@ ksocknal_send_kiov (ksock_conn_t *conn, ksock_tx_t *tx)
 		tx->tx_nkiov--;
 	} while (nob != 0);
 
-	return (rc);
+	return rc;
 }
 
 int
@@ -198,7 +198,7 @@ ksocknal_transmit (ksock_conn_t *conn, ksock_tx_t *tx)
 	rc = ksocknal_connsock_addref(conn);
 	if (rc != 0) {
 		LASSERT (conn->ksnc_closing);
-		return (-ESHUTDOWN);
+		return -ESHUTDOWN;
 	}
 
 	do {
@@ -245,7 +245,7 @@ ksocknal_transmit (ksock_conn_t *conn, ksock_tx_t *tx)
 	} while (tx->tx_resid != 0);
 
 	ksocknal_connsock_decref(conn);
-	return (rc);
+	return rc;
 }
 
 int
@@ -262,7 +262,7 @@ ksocknal_recv_iov (ksock_conn_t *conn)
 	rc = ksocknal_lib_recv_iov(conn);
 
 	if (rc <= 0)
-		return (rc);
+		return rc;
 
 	/* received something... */
 	nob = rc;
@@ -282,7 +282,7 @@ ksocknal_recv_iov (ksock_conn_t *conn)
 		if (nob < (int)iov->iov_len) {
 			iov->iov_len -= nob;
 			iov->iov_base = (void *)((char *)iov->iov_base + nob);
-			return (-EAGAIN);
+			return -EAGAIN;
 		}
 
 		nob -= iov->iov_len;
@@ -290,7 +290,7 @@ ksocknal_recv_iov (ksock_conn_t *conn)
 		conn->ksnc_rx_niov--;
 	} while (nob != 0);
 
-	return (rc);
+	return rc;
 }
 
 int
@@ -306,7 +306,7 @@ ksocknal_recv_kiov (ksock_conn_t *conn)
 	rc = ksocknal_lib_recv_kiov(conn);
 
 	if (rc <= 0)
-		return (rc);
+		return rc;
 
 	/* received something... */
 	nob = rc;
@@ -353,7 +353,7 @@ ksocknal_receive (ksock_conn_t *conn)
 	rc = ksocknal_connsock_addref(conn);
 	if (rc != 0) {
 		LASSERT (conn->ksnc_closing);
-		return (-ESHUTDOWN);
+		return -ESHUTDOWN;
 	}
 
 	for (;;) {
@@ -515,11 +515,11 @@ ksocknal_process_transmit (ksock_conn_t *conn, ksock_tx_t *tx)
 		/* Sent everything OK */
 		LASSERT (rc == 0);
 
-		return (0);
+		return 0;
 	}
 
 	if (rc == -EAGAIN)
-		return (rc);
+		return rc;
 
 	if (rc == -ENOMEM) {
 		static int counter;
@@ -542,7 +542,7 @@ ksocknal_process_transmit (ksock_conn_t *conn, ksock_tx_t *tx)
 			wake_up (&ksocknal_data.ksnd_reaper_waitq);
 
 		spin_unlock_bh(&ksocknal_data.ksnd_reaper_lock);
-		return (rc);
+		return rc;
 	}
 
 	/* Actual error */
@@ -576,7 +576,7 @@ ksocknal_process_transmit (ksock_conn_t *conn, ksock_tx_t *tx)
 	ksocknal_close_conn_and_siblings (conn,
 					  (conn->ksnc_closing) ? 0 : rc);
 
-	return (rc);
+	return rc;
 }
 
 void
@@ -808,10 +808,10 @@ ksocknal_find_connectable_route_locked (ksock_peer_t *peer)
 			continue;
 		}
 
-		return (route);
+		return route;
 	}
 
-	return (NULL);
+	return NULL;
 }
 
 ksock_route_t *
@@ -826,10 +826,10 @@ ksocknal_find_connecting_route_locked (ksock_peer_t *peer)
 		LASSERT (!route->ksnr_connecting || route->ksnr_scheduled);
 
 		if (route->ksnr_scheduled)
-			return (route);
+			return route;
 	}
 
-	return (NULL);
+	return NULL;
 }
 
 int
@@ -857,7 +857,7 @@ ksocknal_launch_packet (lnet_ni_t *ni, ksock_tx_t *tx, lnet_process_id_t id)
 					 * connection... */
 					ksocknal_queue_tx_locked (tx, conn);
 					read_unlock(g_lock);
-					return (0);
+					return 0;
 				}
 			}
 		}
@@ -901,7 +901,7 @@ ksocknal_launch_packet (lnet_ni_t *ni, ksock_tx_t *tx, lnet_process_id_t id)
 		/* Connection exists; queue message on it */
 		ksocknal_queue_tx_locked (tx, conn);
 		write_unlock_bh(g_lock);
-		return (0);
+		return 0;
 	}
 
 	if (peer->ksnp_accepting > 0 ||
@@ -920,7 +920,7 @@ ksocknal_launch_packet (lnet_ni_t *ni, ksock_tx_t *tx, lnet_process_id_t id)
 
 	/* NB Routes may be ignored if connections to them failed recently */
 	CNETERR("No usable routes to %s\n", libcfs_id2str(id));
-	return (-EHOSTUNREACH);
+	return -EHOSTUNREACH;
 }
 
 int
@@ -965,7 +965,7 @@ ksocknal_send(lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg)
 		       type, desc_size);
 		if (lntmsg->msg_vmflush)
 			cfs_memory_pressure_restore(mpflag);
-		return (-ENOMEM);
+		return -ENOMEM;
 	}
 
 	tx->tx_conn = NULL;		     /* set when assigned a conn */
@@ -999,10 +999,10 @@ ksocknal_send(lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg)
 		cfs_memory_pressure_restore(mpflag);
 
 	if (rc == 0)
-		return (0);
+		return 0;
 
 	ksocknal_free_tx(tx);
-	return (-EIO);
+	return -EIO;
 }
 
 int
@@ -1078,7 +1078,7 @@ ksocknal_new_packet (ksock_conn_t *conn, int nob_to_skip)
 		conn->ksnc_rx_kiov = NULL;
 		conn->ksnc_rx_nkiov = 0;
 		conn->ksnc_rx_csum = ~0;
-		return (1);
+		return 1;
 	}
 
 	/* Set up to skip as much as possible now.  If there's more left
@@ -1106,7 +1106,7 @@ ksocknal_new_packet (ksock_conn_t *conn, int nob_to_skip)
 	conn->ksnc_rx_kiov = NULL;
 	conn->ksnc_rx_nkiov = 0;
 	conn->ksnc_rx_nob_wanted = skipped;
-	return (0);
+	return 0;
 }
 
 int
@@ -1153,7 +1153,7 @@ ksocknal_process_receive (ksock_conn_t *conn)
 
 		if (conn->ksnc_rx_nob_wanted != 0) {
 			/* short read */
-			return (-EAGAIN);
+			return -EAGAIN;
 		}
 	}
 	switch (conn->ksnc_rx_state) {
@@ -1172,7 +1172,7 @@ ksocknal_process_receive (ksock_conn_t *conn)
 			       conn->ksnc_msg.ksm_type);
 			ksocknal_new_packet(conn, 0);
 			ksocknal_close_conn_and_siblings(conn, -EPROTO);
-			return (-EPROTO);
+			return -EPROTO;
 		}
 
 		if (conn->ksnc_msg.ksm_type == KSOCK_MSG_NOOP &&
@@ -1184,7 +1184,7 @@ ksocknal_process_receive (ksock_conn_t *conn)
 			       conn->ksnc_msg.ksm_csum, conn->ksnc_rx_csum);
 			ksocknal_new_packet(conn, 0);
 			ksocknal_close_conn_and_siblings(conn, -EPROTO);
-			return (-EIO);
+			return -EIO;
 		}
 
 		if (conn->ksnc_msg.ksm_zc_cookies[1] != 0) {
@@ -1204,7 +1204,7 @@ ksocknal_process_receive (ksock_conn_t *conn)
 				       cookie, conn->ksnc_msg.ksm_zc_cookies[1]);
 				ksocknal_new_packet(conn, 0);
 				ksocknal_close_conn_and_siblings(conn, -EPROTO);
-				return (rc);
+				return rc;
 			}
 		}
 
@@ -1252,7 +1252,7 @@ ksocknal_process_receive (ksock_conn_t *conn)
 			ksocknal_new_packet(conn, 0);
 			ksocknal_close_conn_and_siblings (conn, rc);
 			ksocknal_conn_decref(conn);
-			return (-EPROTO);
+			return -EPROTO;
 		}
 
 		/* I'm racing with ksocknal_recv() */
@@ -1295,7 +1295,7 @@ ksocknal_process_receive (ksock_conn_t *conn)
 		if (rc != 0) {
 			ksocknal_new_packet(conn, 0);
 			ksocknal_close_conn_and_siblings (conn, rc);
-			return (-EPROTO);
+			return -EPROTO;
 		}
 		/* Fall through */
 
@@ -1311,7 +1311,7 @@ ksocknal_process_receive (ksock_conn_t *conn)
 
 	/* Not Reached */
 	LBUG ();
-	return (-EINVAL);		       /* keep gcc happy */
+	return -EINVAL;		       /* keep gcc happy */
 }
 
 int
@@ -1679,13 +1679,13 @@ ksocknal_invert_type(int type)
 	{
 	case SOCKLND_CONN_ANY:
 	case SOCKLND_CONN_CONTROL:
-		return (type);
+		return type;
 	case SOCKLND_CONN_BULK_IN:
 		return SOCKLND_CONN_BULK_OUT;
 	case SOCKLND_CONN_BULK_OUT:
 		return SOCKLND_CONN_BULK_IN;
 	default:
-		return (SOCKLND_CONN_NONE);
+		return SOCKLND_CONN_NONE;
 	}
 }
 
@@ -2291,7 +2291,7 @@ ksocknal_find_timed_out_conn (ksock_peer_t *peer)
 				break;
 			}
 
-			return (conn);
+			return conn;
 		}
 
 		if (conn->ksnc_rx_started &&
@@ -2307,7 +2307,7 @@ ksocknal_find_timed_out_conn (ksock_peer_t *peer)
 				conn->ksnc_rx_state,
 				conn->ksnc_rx_nob_wanted,
 				conn->ksnc_rx_nob_left);
-			return (conn);
+			return conn;
 		}
 
 		if ((!list_empty(&conn->ksnc_tx_queue) ||
@@ -2322,11 +2322,11 @@ ksocknal_find_timed_out_conn (ksock_peer_t *peer)
 				libcfs_id2str(peer->ksnp_id),
 				&conn->ksnc_ipaddr,
 				conn->ksnc_port);
-			return (conn);
+			return conn;
 		}
 	}
 
-	return (NULL);
+	return NULL;
 }
 
 static inline void
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
index 82b7d9f..d18bab1 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.c
@@ -380,7 +380,7 @@ ksocknal_lib_recv_kiov (ksock_conn_t *conn)
 			kunmap(kiov[i].kiov_page);
 	}
 
-	return (rc);
+	return rc;
 }
 
 void
@@ -433,7 +433,7 @@ ksocknal_lib_get_conn_tunables (ksock_conn_t *conn, int *txmem, int *rxmem, int
 	if (rc != 0) {
 		LASSERT (conn->ksnc_closing);
 		*txmem = *rxmem = *nagle = 0;
-		return (-ESHUTDOWN);
+		return -ESHUTDOWN;
 	}
 
 	rc = libcfs_sock_getbuf(sock, txmem, rxmem);
@@ -450,7 +450,7 @@ ksocknal_lib_get_conn_tunables (ksock_conn_t *conn, int *txmem, int *rxmem, int
 	else
 		*txmem = *rxmem = *nagle = 0;
 
-	return (rc);
+	return rc;
 }
 
 int
@@ -476,7 +476,7 @@ ksocknal_lib_setup_sock (struct socket *sock)
 			      (char *)&linger, sizeof (linger));
 	if (rc != 0) {
 		CERROR ("Can't set SO_LINGER: %d\n", rc);
-		return (rc);
+		return rc;
 	}
 
 	option = -1;
@@ -484,7 +484,7 @@ ksocknal_lib_setup_sock (struct socket *sock)
 				    (char *)&option, sizeof (option));
 	if (rc != 0) {
 		CERROR ("Can't set SO_LINGER2: %d\n", rc);
-		return (rc);
+		return rc;
 	}
 
 	if (!*ksocknal_tunables.ksnd_nagle) {
@@ -494,7 +494,7 @@ ksocknal_lib_setup_sock (struct socket *sock)
 					    (char *)&option, sizeof (option));
 		if (rc != 0) {
 			CERROR ("Can't disable nagle: %d\n", rc);
-			return (rc);
+			return rc;
 		}
 	}
 
@@ -505,7 +505,7 @@ ksocknal_lib_setup_sock (struct socket *sock)
 		CERROR ("Can't set buffer tx %d, rx %d buffers: %d\n",
 			*ksocknal_tunables.ksnd_tx_buffer_size,
 			*ksocknal_tunables.ksnd_rx_buffer_size, rc);
-		return (rc);
+		return rc;
 	}
 
 /* TCP_BACKOFF_* sockopt tunables unsupported in stock kernels */
@@ -522,34 +522,34 @@ ksocknal_lib_setup_sock (struct socket *sock)
 			      (char *)&option, sizeof (option));
 	if (rc != 0) {
 		CERROR ("Can't set SO_KEEPALIVE: %d\n", rc);
-		return (rc);
+		return rc;
 	}
 
 	if (!do_keepalive)
-		return (0);
+		return 0;
 
 	rc = kernel_setsockopt(sock, SOL_TCP, TCP_KEEPIDLE,
 				    (char *)&keep_idle, sizeof (keep_idle));
 	if (rc != 0) {
 		CERROR ("Can't set TCP_KEEPIDLE: %d\n", rc);
-		return (rc);
+		return rc;
 	}
 
 	rc = kernel_setsockopt(sock, SOL_TCP, TCP_KEEPINTVL,
 				    (char *)&keep_intvl, sizeof (keep_intvl));
 	if (rc != 0) {
 		CERROR ("Can't set TCP_KEEPINTVL: %d\n", rc);
-		return (rc);
+		return rc;
 	}
 
 	rc = kernel_setsockopt(sock, SOL_TCP, TCP_KEEPCNT,
 				    (char *)&keep_count, sizeof (keep_count));
 	if (rc != 0) {
 		CERROR ("Can't set TCP_KEEPCNT: %d\n", rc);
-		return (rc);
+		return rc;
 	}
 
-	return (0);
+	return 0;
 }
 
 void
-- 
1.7.9.5

