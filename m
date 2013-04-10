Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965086Ab3DJXEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:04:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937383Ab3DJWrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 61/64] NFSv4: Doh! Typo in the fix to nfs41_walk_client_list
Date: Wed, 10 Apr 2013 15:46:58 -0700
Message-Id: <20130410224347.825093150@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit eb04e0ac198cec3bab407ad220438dfa65c19c67 upstream.

Make sure that we set the status to 0 on success. Missed in testing
because it never appears when doing multiple mounts to _different_
servers.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4client.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nfs/nfs4client.c
+++ b/fs/nfs/nfs4client.c
@@ -482,6 +482,7 @@ int nfs41_walk_client_list(struct nfs_cl
 
 		atomic_inc(&pos->cl_count);
 		*result = pos;
+		status = 0;
 		dprintk("NFS: <-- %s using nfs_client = %p ({%d})\n",
 			__func__, pos, atomic_read(&pos->cl_count));
 		break;


