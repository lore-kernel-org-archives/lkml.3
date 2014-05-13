Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbaEMQI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:08:58 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:49469 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbaEMQIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:08:49 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoXAExCclNbtADP/2dsb2JhbABZgwasdgQBAQEBAQEFAZoXAgKBIhd0glMTHCMYM08kE4hFAdB1hVaIfB+EKAEDjyWKIgGLBIgDgzg7gTAk
Date: Tue, 13 May 2014 18:08:44 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Steve French <sfrench@samba.org>
Subject: [PATCH 1/1] fs/cifs/connect.c: convert printk to pr_foo()
Message-Id: <20140513180844.1d362537031d5363b8a86063@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Define pr_fmt with module name
note that prefix is now cifs: instead of CIFS:

-Fixing some checkpatch warnings.mainly
"braces {} are not necessary for single statement blocks"

Cc: Steve French <sfrench@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/cifs/connect.c | 81 ++++++++++++++++++++++++-------------------------------
 1 file changed, 35 insertions(+), 46 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8813ff7..321bf58 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -18,6 +18,8 @@
  *   along with this library; if not, write to the Free Software
  *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/fs.h>
 #include <linux/net.h>
 #include <linux/string.h>
@@ -1447,9 +1449,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			vol->seal = 1;
 			break;
 		case Opt_noac:
-			printk(KERN_WARNING "CIFS: Mount option noac not "
-				"supported. Instead set "
-				"/proc/fs/cifs/LookupCacheEnabled to 0\n");
+			pr_warn("Mount option noac not supported. Instead set /proc/fs/cifs/LookupCacheEnabled to 0\n");
 			break;
 		case Opt_fsc:
 #ifndef CONFIG_CIFS_FSCACHE
@@ -1579,7 +1579,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 
 			if (strnlen(string, CIFS_MAX_USERNAME_LEN) >
 							CIFS_MAX_USERNAME_LEN) {
-				printk(KERN_WARNING "CIFS: username too long\n");
+				pr_warn("username too long\n");
 				goto cifs_parse_mount_err;
 			}
 			vol->username = kstrdup(string, GFP_KERNEL);
@@ -1641,8 +1641,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			temp_len = strlen(value);
 			vol->password = kzalloc(temp_len+1, GFP_KERNEL);
 			if (vol->password == NULL) {
-				printk(KERN_WARNING "CIFS: no memory "
-						    "for password\n");
+				pr_warn("no memory for password\n");
 				goto cifs_parse_mount_err;
 			}
 
@@ -1666,8 +1665,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 
 			if (!cifs_convert_address(dstaddr, string,
 					strlen(string))) {
-				printk(KERN_ERR "CIFS: bad ip= option (%s).\n",
-					string);
+				pr_err("bad ip= option (%s).\n", string);
 				goto cifs_parse_mount_err;
 			}
 			got_ip = true;
@@ -1679,15 +1677,13 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 
 			if (strnlen(string, CIFS_MAX_DOMAINNAME_LEN)
 					== CIFS_MAX_DOMAINNAME_LEN) {
-				printk(KERN_WARNING "CIFS: domain name too"
-						    " long\n");
+				pr_warn("domain name too long\n");
 				goto cifs_parse_mount_err;
 			}
 
 			vol->domainname = kstrdup(string, GFP_KERNEL);
 			if (!vol->domainname) {
-				printk(KERN_WARNING "CIFS: no memory "
-						    "for domainname\n");
+				pr_warn("no memory for domainname\n");
 				goto cifs_parse_mount_err;
 			}
 			cifs_dbg(FYI, "Domain name set\n");
@@ -1700,8 +1696,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			if (!cifs_convert_address(
 					(struct sockaddr *)&vol->srcaddr,
 					string, strlen(string))) {
-				printk(KERN_WARNING "CIFS:  Could not parse"
-						    " srcaddr: %s\n", string);
+				pr_warn("  Could not parse srcaddr: %s\n",
+					string);
 				goto cifs_parse_mount_err;
 			}
 			break;
@@ -1711,8 +1707,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				goto out_nomem;
 
 			if (strnlen(string, 1024) >= 65) {
-				printk(KERN_WARNING "CIFS: iocharset name "
-						    "too long.\n");
+				pr_warn("iocharset name too long.\n");
 				goto cifs_parse_mount_err;
 			}
 
@@ -1720,8 +1715,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				vol->iocharset = kstrdup(string,
 							 GFP_KERNEL);
 				if (!vol->iocharset) {
-					printk(KERN_WARNING "CIFS: no memory"
-							    "for charset\n");
+					pr_warn("no memory for charset\n");
 					goto cifs_parse_mount_err;
 				}
 			}
@@ -1752,8 +1746,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			 * set at top of the function
 			 */
 			if (i == RFC1001_NAME_LEN && string[i] != 0)
-				printk(KERN_WARNING "CIFS: netbiosname"
-				       " longer than 15 truncated.\n");
+				pr_warn("netbiosname longer than 15 truncated.\n");
 
 			break;
 		case Opt_servern:
@@ -1780,8 +1773,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			/* The string has 16th byte zero still from
 			   set at top of the function  */
 			if (i == RFC1001_NAME_LEN && string[i] != 0)
-				printk(KERN_WARNING "CIFS: server net"
-				       "biosname longer than 15 truncated.\n");
+				pr_warn("server net biosname longer than 15 truncated.\n");
 			break;
 		case Opt_ver:
 			string = match_strdup(args);
@@ -1793,8 +1785,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				break;
 			}
 			/* For all other value, error */
-			printk(KERN_WARNING "CIFS: Invalid version"
-					    " specified\n");
+			pr_warn("Invalid version specified\n");
 			goto cifs_parse_mount_err;
 		case Opt_vers:
 			string = match_strdup(args);
@@ -1835,7 +1826,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	}
 
 	if (!sloppy && invalid) {
-		printk(KERN_ERR "CIFS: Unknown mount option \"%s\"\n", invalid);
+		pr_err("Unknown mount option \"%s\"\n", invalid);
 		goto cifs_parse_mount_err;
 	}
 
@@ -1861,8 +1852,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		/* No ip= option specified? Try to get it from UNC */
 		if (!cifs_convert_address(dstaddr, &vol->UNC[2],
 						strlen(&vol->UNC[2]))) {
-			printk(KERN_ERR "Unable to determine destination "
-					"address.\n");
+			pr_err("Unable to determine destination address.\n");
 			goto cifs_parse_mount_err;
 		}
 	}
@@ -1873,20 +1863,18 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	if (uid_specified)
 		vol->override_uid = override_uid;
 	else if (override_uid == 1)
-		printk(KERN_NOTICE "CIFS: ignoring forceuid mount option "
-				   "specified with no uid= option.\n");
+		pr_notice("ignoring forceuid mount option specified with no uid= option.\n");
 
 	if (gid_specified)
 		vol->override_gid = override_gid;
 	else if (override_gid == 1)
-		printk(KERN_NOTICE "CIFS: ignoring forcegid mount option "
-				   "specified with no gid= option.\n");
+		pr_notice("ignoring forcegid mount option specified with no gid= option.\n");
 
 	kfree(mountdata_copy);
 	return 0;
 
 out_nomem:
-	printk(KERN_WARNING "Could not allocate temporary buffer\n");
+	pr_warn("Could not allocate temporary buffer\n");
 cifs_parse_mount_err:
 	kfree(string);
 	kfree(mountdata_copy);
@@ -2701,7 +2689,8 @@ compare_mount_options(struct super_block *sb, struct cifs_mnt_data *mnt_data)
 	if (new->rsize && new->rsize < old->rsize)
 		return 0;
 
-	if (!uid_eq(old->mnt_uid, new->mnt_uid) || !gid_eq(old->mnt_gid, new->mnt_gid))
+	if (!uid_eq(old->mnt_uid, new->mnt_uid) ||
+	    !gid_eq(old->mnt_gid, new->mnt_gid))
 		return 0;
 
 	if (old->mnt_file_mode != new->mnt_file_mode ||
@@ -3060,8 +3049,9 @@ ip_connect(struct TCP_Server_Info *server)
 	return generic_ip_connect(server);
 }
 
-void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
-			  struct cifs_sb_info *cifs_sb, struct smb_vol *vol_info)
+void
+reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
+		     struct cifs_sb_info *cifs_sb, struct smb_vol *vol_info)
 {
 	/* if we are reconnecting then should we check to see if
 	 * any requested capabilities changed locally e.g. via
@@ -3151,9 +3141,9 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
 			cifs_dbg(FYI, "mandatory transport encryption cap\n");
 #endif /* CIFS_DEBUG2 */
 		if (CIFSSMBSetFSUnixInfo(xid, tcon, cap)) {
-			if (vol_info == NULL) {
+			if (vol_info == NULL)
 				cifs_dbg(FYI, "resetting capabilities failed\n");
-			} else
+			else
 				cifs_dbg(VFS, "Negotiating Unix capabilities with the server failed. Consider mounting with the Unix Extensions disabled if problems are found by specifying the nounix mount option.\n");
 
 		}
@@ -3233,11 +3223,10 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
 	}
 	if (pvolume_info->mfsymlinks) {
-		if (pvolume_info->sfu_emul) {
+		if (pvolume_info->sfu_emul)
 			cifs_dbg(VFS, "mount option mfsymlinks ignored if sfu mount option is used\n");
-		} else {
+		else
 			cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_MF_SYMLINKS;
-		}
 	}
 
 	if ((pvolume_info->cifs_acl) && (pvolume_info->dynperm))
@@ -3571,7 +3560,7 @@ remote_path_check:
 		goto mount_fail_check;
 
 	/* now, hang the tcon off of the superblock */
-	tlink = kzalloc(sizeof *tlink, GFP_KERNEL);
+	tlink = kzalloc(sizeof(*tlink), GFP_KERNEL);
 	if (tlink == NULL) {
 		rc = -ENOMEM;
 		goto mount_fail_check;
@@ -3638,7 +3627,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 	smb_buffer_response = smb_buffer;
 
 	header_assemble(smb_buffer, SMB_COM_TREE_CONNECT_ANDX,
-			NULL /*no tid */ , 4 /*wct */ );
+			NULL /*no tid */ , 4 /*wct */);
 
 	smb_buffer->Mid = get_next_mid(ses->server);
 	smb_buffer->Uid = ses->Suid;
@@ -3684,12 +3673,12 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 	if (ses->server->sign)
 		smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
 
-	if (ses->capabilities & CAP_STATUS32) {
+	if (ses->capabilities & CAP_STATUS32)
 		smb_buffer->Flags2 |= SMBFLG2_ERR_STATUS;
-	}
-	if (ses->capabilities & CAP_DFS) {
+
+	if (ses->capabilities & CAP_DFS)
 		smb_buffer->Flags2 |= SMBFLG2_DFS;
-	}
+
 	if (ses->capabilities & CAP_UNICODE) {
 		smb_buffer->Flags2 |= SMBFLG2_UNICODE;
 		length =
-- 
1.8.4.5

