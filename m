Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbaJCVwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:52:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbaJCVpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:45:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alban Crequy <alban.crequy@collabora.co.uk>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.16 206/357] cgroup: reject cgroup names with \n
Date: Fri,  3 Oct 2014 14:29:52 -0700
Message-Id: <20141003212939.725161035@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Crequy <alban.crequy@collabora.co.uk>

commit 71b1fb5c4473a5b1e601d41b109bdfe001ec82e0 upstream.

/proc/<pid>/cgroup contains one cgroup path on each line. If cgroup names are
allowed to contain "\n", applications cannot parse /proc/<pid>/cgroup safely.

Signed-off-by: Alban Crequy <alban.crequy@collabora.co.uk>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4393,6 +4393,11 @@ static int cgroup_mkdir(struct kernfs_no
 	struct kernfs_node *kn;
 	int ssid, ret;
 
+	/* Do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable.
+	 */
+	if (strchr(name, '\n'))
+		return -EINVAL;
+
 	parent = cgroup_kn_lock_live(parent_kn);
 	if (!parent)
 		return -ENODEV;


