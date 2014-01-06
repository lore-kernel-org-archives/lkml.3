Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329AbaAFXJ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:09:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48464 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933100AbaAFWlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Sage Weil <sage@inktank.com>
Subject: [PATCH 3.10 107/129] libceph: potential NULL dereference in ceph_osdc_handle_map()
Date: Mon,  6 Jan 2014 14:38:56 -0800
Message-Id: <20140106223902.661155175@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b72e19b9225d4297a18715b0998093d843d170fa upstream.

There are two places where we read "nr_maps" if both of them are set to
zero then we would hit a NULL dereference here.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/osd_client.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1786,6 +1786,8 @@ void ceph_osdc_handle_map(struct ceph_os
 		nr_maps--;
 	}
 
+	if (!osdc->osdmap)
+		goto bad;
 done:
 	downgrade_write(&osdc->map_sem);
 	ceph_monc_got_osdmap(&osdc->client->monc, osdc->osdmap->epoch);


