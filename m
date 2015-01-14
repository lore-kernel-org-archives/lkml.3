Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbbANJdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:33:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbbANJdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:33:05 -0500
Subject: [RFC PATCH 4/5] KEYS - rename call_usermodehelper_keys() flags
 parameter
From: Ian Kent <ikent@redhat.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Oleg Nesterov <onestero@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Jeff Layton <jeff.layton@primarydata.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 14 Jan 2015 17:32:49 +0800
Message-ID: <20150114093248.30252.93623.stgit@pluto.fritz.box>
In-Reply-To: <20150114092704.30252.60446.stgit@pluto.fritz.box>
References: <20150114092704.30252.60446.stgit@pluto.fritz.box>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wait parameter of call_usermodehelper_keys() will later be used to
request exec within a namespace.

So change its name to flags.

Signed-off-by: Ian Kent <ikent@redhat.com>
Cc: Benjamin Coddington <bcodding@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Oleg Nesterov <onestero@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jeff Layton <jeff.layton@primarydata.com>
---
 security/keys/request_key.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 0c7aea4..9e79bbf 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -73,7 +73,7 @@ static void umh_keys_cleanup(struct subprocess_info *info)
  * Call a usermode helper with a specific session keyring.
  */
 static int call_usermodehelper_keys(char *path, char **argv, char **envp,
-					struct key *session_keyring, int wait)
+					struct key *session_keyring, int flags)
 {
 	struct subprocess_info *info;
 
@@ -84,7 +84,7 @@ static int call_usermodehelper_keys(char *path, char **argv, char **envp,
 		return -ENOMEM;
 
 	key_get(session_keyring);
-	return call_usermodehelper_exec(info, wait);
+	return call_usermodehelper_exec(info, flags);
 }
 
 /*

