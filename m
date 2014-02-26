Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaBZNq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:46:56 -0500
Received: from mout.gmx.net ([212.227.17.22]:53193 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaBZNqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:46:53 -0500
MIME-Version: 1.0
Message-ID: <trinity-7e911dab-5097-463a-ba4a-09935acbdc69-1393422407694@3capp-gmx-bs33>
From: "Lorenz Bucher" <Lorenz.Bucher@gmx.de>
To: sfrench@samba.org
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, lorenz.bucher@gmx.de
Subject: [PATCH] cifs: connect: added option krb5mi which may allow package
 signing
Content-Type: text/plain; charset=UTF-8
Date: Wed, 26 Feb 2014 14:46:47 +0100
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K0:th8AdLIoV39E1P1LEYr2gQv3NMV2OfXf5X9eLeCZBFj
 JlkEdoy72zOUAX3nnazekHMZVroEiqDvMP9iHVHlrOVr4+jotG
 ePPXrRopE48B6Kv2jfiwVvL1I0f81e4I8O0Ki+AiTUOYJC74z9
 orQB8/eNG0lj3MZIvz94ktxS1Ob7XymkPAAwNG12hy82zMujDs
 0hcgVuaKcnEd6df1iAOn/WS/mcyzEo9sT10RkDEQL37JCWHp+t
 Hv7+xthOF8cc5B1Z7Noke1VhjyuVLNNNMN6/jCY6ZaZs0DAlnh WM0jvk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Solves an issue with dfs where servers using package signing are
mixed with servers which don't use package signing.

Signed-off-by: Lorenz Bucher <lorenz.bucher@gmx.de>
---
 fs/cifs/connect.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 56c152d..9d06dd8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1104,6 +1104,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
                        if (!value || !*value) {
                                cERROR(1, "no security value specified");
                                continue;
+                       } else if (strnicmp(value, "krb5mi", 6) == 0) {
+                               vol->secFlg |= CIFSSEC_MAY_KRB5 | 
+                                       CIFSSEC_MAY_SIGN;
                        } else if (strnicmp(value, "krb5i", 5) == 0) {
                                vol->secFlg |= CIFSSEC_MAY_KRB5 |
                                        CIFSSEC_MUST_SIGN;
-- 
1.7.9.5
