Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935132AbaBDWKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:10:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56777 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934067AbaBDVI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.12 091/133] vfs: Remove second variable named error in __dentry_path
Date: Tue,  4 Feb 2014 13:08:12 -0800
Message-Id: <20140204210739.606240185@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit a8323da0366d3398eda62741d2ac1130c8a172ed upstream.

In commit  232d2d60aa5469bb097f55728f65146bd49c1d25
Author: Waiman Long <Waiman.Long@hp.com>
Date:   Mon Sep 9 12:18:13 2013 -0400

    dcache: Translating dentry into pathname without taking rename_lock

The __dentry_path locking was changed and the variable error was
intended to be moved outside of the loop.  Unfortunately the inner
declaration of error was not removed. Resulting in a version of
__dentry_path that will never return an error.

Remove the problematic inner declaration of error and allow
__dentry_path to return errors once again.

Cc: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dcache.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3140,7 +3140,6 @@ restart:
 	read_seqbegin_or_lock(&rename_lock, &seq);
 	while (!IS_ROOT(dentry)) {
 		struct dentry *parent = dentry->d_parent;
-		int error;
 
 		prefetch(parent);
 		error = prepend_name(&end, &len, &dentry->d_name);


