Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaC3X31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:29:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36587 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbaC3XZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Martijn de Gouw" <martijn.de.gouw@prodrive.nl>,
        "Steve French" <sfrench@us.ibm.com>,
        "Jeff Layton" <jlayton@redhat.com>,
        "Joseph Salisbury" <joseph.salisbury@canonical.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.242588925@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 192/200] cifs: set MAY_SIGN when sec=krb5
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Martijn de Gouw <martijn.de.gouw@prodrive.nl>

commit 0b7bc84000d71f3647ca33ab1bf5bd928535c846 upstream.

Setting this secFlg allows usage of dfs where some servers require
signing and others don't.

Signed-off-by: Martijn de Gouw <martijn.de.gouw@prodrive.nl>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
[Joseph Salisbury: This backport was done so including mainline commit
8830d7e07a5e38bc47650a7554b7c1cfd49902bf is not needed.]
BugLink: http://bugs.launchpad.net/bugs/1285723
Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/connect.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 56c152d..49d6e21 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1113,7 +1113,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				cERROR(1, "Krb5 cifs privacy not supported");
 				goto cifs_parse_mount_err;
 			} else if (strnicmp(value, "krb5", 4) == 0) {
-				vol->secFlg |= CIFSSEC_MAY_KRB5;
+				vol->secFlg |= CIFSSEC_MAY_KRB5 | 
+					CIFSSEC_MAY_SIGN;
 			} else if (strnicmp(value, "ntlmsspi", 8) == 0) {
 				vol->secFlg |= CIFSSEC_MAY_NTLMSSP |
 					CIFSSEC_MUST_SIGN;

