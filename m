Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbaEMQE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:04:28 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:55053 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750948AbaEMQEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:04:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoXAItBclNbtADP/2dsb2JhbABZgwasdgQBAQEBAQEFAZoXAgKBIhd0glMTHCMYgQIkE4hFAdBzhVaIfIRHAQOPJYoiAYsEiAODODs
Date: Tue, 13 May 2014 18:04:17 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Steve French <sfrench@samba.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/cifs/cifs.c: replace seq_printf by seq_puts
Message-Id: <20140513180417.74af95e95649ba975d53badb@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace seq_printf where possible

Cc: Steve French <sfrench@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cifs/cifsfs.c | 80 ++++++++++++++++++++++++++++----------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5be1f99..5d0a4eb 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -302,7 +302,7 @@ cifs_show_address(struct seq_file *s, struct TCP_Server_Info *server)
 	struct sockaddr_in *sa = (struct sockaddr_in *) &server->dstaddr;
 	struct sockaddr_in6 *sa6 = (struct sockaddr_in6 *) &server->dstaddr;
 
-	seq_printf(s, ",addr=");
+	seq_puts(s, ",addr=");
 
 	switch (server->dstaddr.ss_family) {
 	case AF_INET:
@@ -314,7 +314,7 @@ cifs_show_address(struct seq_file *s, struct TCP_Server_Info *server)
 			seq_printf(s, "%%%u", sa6->sin6_scope_id);
 		break;
 	default:
-		seq_printf(s, "(unknown)");
+		seq_puts(s, "(unknown)");
 	}
 }
 
@@ -324,45 +324,45 @@ cifs_show_security(struct seq_file *s, struct cifs_ses *ses)
 	if (ses->sectype == Unspecified)
 		return;
 
-	seq_printf(s, ",sec=");
+	seq_puts(s, ",sec=");
 
 	switch (ses->sectype) {
 	case LANMAN:
-		seq_printf(s, "lanman");
+		seq_puts(s, "lanman");
 		break;
 	case NTLMv2:
-		seq_printf(s, "ntlmv2");
+		seq_puts(s, "ntlmv2");
 		break;
 	case NTLM:
-		seq_printf(s, "ntlm");
+		seq_puts(s, "ntlm");
 		break;
 	case Kerberos:
-		seq_printf(s, "krb5");
+		seq_puts(s, "krb5");
 		break;
 	case RawNTLMSSP:
-		seq_printf(s, "ntlmssp");
+		seq_puts(s, "ntlmssp");
 		break;
 	default:
 		/* shouldn't ever happen */
-		seq_printf(s, "unknown");
+		seq_puts(s, "unknown");
 		break;
 	}
 
 	if (ses->sign)
-		seq_printf(s, "i");
+		seq_puts(s, "i");
 }
 
 static void
 cifs_show_cache_flavor(struct seq_file *s, struct cifs_sb_info *cifs_sb)
 {
-	seq_printf(s, ",cache=");
+	seq_puts(s, ",cache=");
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
-		seq_printf(s, "strict");
+		seq_puts(s, "strict");
 	else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO)
-		seq_printf(s, "none");
+		seq_puts(s, "none");
 	else
-		seq_printf(s, "loose");
+		seq_puts(s, "loose");
 }
 
 static void
@@ -395,7 +395,7 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	cifs_show_cache_flavor(s, cifs_sb);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
-		seq_printf(s, ",multiuser");
+		seq_puts(s, ",multiuser");
 	else if (tcon->ses->user_name)
 		seq_printf(s, ",username=%s", tcon->ses->user_name);
 
@@ -421,16 +421,16 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	seq_printf(s, ",uid=%u",
 		   from_kuid_munged(&init_user_ns, cifs_sb->mnt_uid));
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
-		seq_printf(s, ",forceuid");
+		seq_puts(s, ",forceuid");
 	else
-		seq_printf(s, ",noforceuid");
+		seq_puts(s, ",noforceuid");
 
 	seq_printf(s, ",gid=%u",
 		   from_kgid_munged(&init_user_ns, cifs_sb->mnt_gid));
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
-		seq_printf(s, ",forcegid");
+		seq_puts(s, ",forcegid");
 	else
-		seq_printf(s, ",noforcegid");
+		seq_puts(s, ",noforcegid");
 
 	cifs_show_address(s, tcon->ses->server);
 
@@ -442,47 +442,47 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	cifs_show_nls(s, cifs_sb->local_nls);
 
 	if (tcon->seal)
-		seq_printf(s, ",seal");
+		seq_puts(s, ",seal");
 	if (tcon->nocase)
-		seq_printf(s, ",nocase");
+		seq_puts(s, ",nocase");
 	if (tcon->retry)
-		seq_printf(s, ",hard");
+		seq_puts(s, ",hard");
 	if (tcon->unix_ext)
-		seq_printf(s, ",unix");
+		seq_puts(s, ",unix");
 	else
-		seq_printf(s, ",nounix");
+		seq_puts(s, ",nounix");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
-		seq_printf(s, ",posixpaths");
+		seq_puts(s, ",posixpaths");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID)
-		seq_printf(s, ",setuids");
+		seq_puts(s, ",setuids");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
-		seq_printf(s, ",serverino");
+		seq_puts(s, ",serverino");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
-		seq_printf(s, ",rwpidforward");
+		seq_puts(s, ",rwpidforward");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL)
-		seq_printf(s, ",forcemand");
+		seq_puts(s, ",forcemand");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
-		seq_printf(s, ",nouser_xattr");
+		seq_puts(s, ",nouser_xattr");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR)
-		seq_printf(s, ",mapchars");
+		seq_puts(s, ",mapchars");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
-		seq_printf(s, ",sfu");
+		seq_puts(s, ",sfu");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
-		seq_printf(s, ",nobrl");
+		seq_puts(s, ",nobrl");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL)
-		seq_printf(s, ",cifsacl");
+		seq_puts(s, ",cifsacl");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DYNPERM)
-		seq_printf(s, ",dynperm");
+		seq_puts(s, ",dynperm");
 	if (root->d_sb->s_flags & MS_POSIXACL)
-		seq_printf(s, ",acl");
+		seq_puts(s, ",acl");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
-		seq_printf(s, ",mfsymlinks");
+		seq_puts(s, ",mfsymlinks");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
-		seq_printf(s, ",fsc");
+		seq_puts(s, ",fsc");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)
-		seq_printf(s, ",nostrictsync");
+		seq_puts(s, ",nostrictsync");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
-		seq_printf(s, ",noperm");
+		seq_puts(s, ",noperm");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_BACKUPUID)
 		seq_printf(s, ",backupuid=%u",
 			   from_kuid_munged(&init_user_ns,
-- 
1.8.4.5

