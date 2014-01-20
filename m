Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaATXnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:43:39 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:53338 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaATXng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:43:36 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Waiman Long <Waiman.Long@hp.com>
Date: Mon, 20 Jan 2014 15:43:25 -0800
Message-ID: <87fvoi6wyq.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19EMDHfi2T+Fkpe4EoeLWvLdPHugP8yDoc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3300]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [PATCH] vfs: Remove second variable named error in __dentry_path
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

Cc: stable@vger.kernel.org
Cc: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/dcache.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index cb4a10690868..fdbe23027810 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3135,7 +3135,6 @@ restart:
 	read_seqbegin_or_lock(&rename_lock, &seq);
 	while (!IS_ROOT(dentry)) {
 		struct dentry *parent = dentry->d_parent;
-		int error;
 
 		prefetch(parent);
 		error = prepend_name(&end, &len, &dentry->d_name);
-- 
1.7.5.4

