Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab3EWGDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 02:03:50 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:58291 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3EWGDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 02:03:48 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: monstr@monstr.eu, Al Viro <viro@zeniv.linux.org.uk>,
        Eric Paris <eparis@redhat.com>
Subject: [PATCH] audit: Fix decimal constant description
Date: Thu, 23 May 2013 08:03:35 +0200
Message-Id: <f0df7e546368dbf705bd302cfe7f834476d00e3e.1369288979.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-21252-1369289015-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-21252-1369289015-0001

Use proper decimal type for comparison with u32.

Compilation warning was introduced by:
"audit: Make testing for a valid loginuid explicit."
(sha1: 780a7654cee8d61819512385e778e4827db4bfbc)

Warning:
kernel/auditfilter.c: In function 'audit_data_to_entry':
kernel/auditfilter.c:426:3: warning: this decimal constant
is unsigned only in ISO C90 [enabled by default]
   if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
CC: Al Viro <viro@zeniv.linux.org.uk>
CC: Eric Paris <eparis@redhat.com>
---
 kernel/auditfilter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index 83a2970..cfa1f73 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -423,7 +423,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 		f->lsm_rule = NULL;

 		/* Support legacy tests for a valid loginuid */
-		if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {
+		if ((f->type == AUDIT_LOGINUID) && (f->val == ~0U)) {
 			f->type = AUDIT_LOGINUID_SET;
 			f->val = 0;
 		}
--
1.8.2.3


--=_mimegpg-monstr-desktop-21252-1369289015-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlGdsTcACgkQykllyylKDCFUJgCdH6CkRlCu2z4nb9O3IGyQM9Rx
onIAoItrzEE6ZKlLHPQF60rDLmxb0diS
=Kftm
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-21252-1369289015-0001--
