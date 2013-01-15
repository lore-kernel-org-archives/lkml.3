Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933716Ab3AOWwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:52:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:46934 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab3AOWwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>,
        Yehuda Sadeh <yehuda@inktank.com>
Subject: [ 132/171] ceph: close old con before reopening on mds reconnect
Date: Tue, 15 Jan 2013 14:44:57 -0800
Message-Id: <20130115224322.857116461@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Sage Weil <sage@inktank.com>

When we detect a mds session reset, close the old ceph_connection before
reopening it.  This ensures we clean up the old socket properly and keep
the ceph_connection state correct.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
(cherry picked from commit a53aab645c82f0146e35684b34692c69b5118121)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/mds_client.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2528,6 +2528,7 @@ static void send_mds_reconnect(struct ce
 	session->s_state = CEPH_MDS_SESSION_RECONNECTING;
 	session->s_seq = 0;
 
+	ceph_con_close(&session->s_con);
 	ceph_con_open(&session->s_con,
 		      CEPH_ENTITY_TYPE_MDS, mds,
 		      ceph_mdsmap_get_addr(mdsc->mdsmap, mds));


