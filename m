Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031Ab3AOXQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:16:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:47498 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933983Ab3AOWyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:54:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Sage Weil <sage@inktank.com>
Subject: [ 163/171] ceph: Dont update i_max_size when handling non-auth cap
Date: Tue, 15 Jan 2013 14:45:28 -0800
Message-Id: <20130115224325.084820820@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Yan, Zheng" <zheng.z.yan@intel.com>

The cap from non-auth mds doesn't have a meaningful max_size value.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Sage Weil <sage@inktank.com>
(cherry picked from commit 5e62ad30157d0da04cf40c6d1a2f4bc840948b9c)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/caps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2388,7 +2388,7 @@ static void handle_cap_grant(struct inod
 			    &atime);
 
 	/* max size increase? */
-	if (max_size != ci->i_max_size) {
+	if (ci->i_auth_cap == cap && max_size != ci->i_max_size) {
 		dout("max_size %lld -> %llu\n", ci->i_max_size, max_size);
 		ci->i_max_size = max_size;
 		if (max_size >= ci->i_wanted_max_size) {


