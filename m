Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaB1VHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:07:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38782 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaB1VHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:07:42 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: ben@decadent.org.uk
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [v3.2.y][PATCH 1/1] cifs: set MAY_SIGN when sec=krb5
Date: Fri, 28 Feb 2014 16:07:35 -0500
Message-Id: <4f795fd099859c91c56b7a05996bc38a040bc9c0.1393535604.git.joseph.salisbury@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1393535604.git.joseph.salisbury@canonical.com>
References: <cover.1393535604.git.joseph.salisbury@canonical.com>
In-Reply-To: <cover.1393535604.git.joseph.salisbury@canonical.com>
References: <cover.1393535604.git.joseph.salisbury@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backport from mainline commit: 0b7bc84000d71f3647ca33ab1bf5bd928535c846.
This backport was done so including mainline commit
8830d7e07a5e38bc47650a7554b7c1cfd49902bf is not needed.

BugLink: http://bugs.launchpad.net/bugs/1285723

Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
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
-- 
1.7.9.5

