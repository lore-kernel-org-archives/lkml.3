Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbaCAIPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 03:15:35 -0500
Received: from mout.gmx.net ([212.227.15.15]:65204 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbaCAIPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 03:15:34 -0500
From: xypron.glpk@gmx.de
To: grant.likely@linaro.org, robh+dt@kernel.org
Cc: devicetree-compiler@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] Remove dead code in util.c
Date: Sat,  1 Mar 2014 09:11:47 +0100
Message-Id: <1393661507-7197-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CAL_JsqK9Wquv6kgefyPvy0JqXNO7Cx2+iN_ss=CtgXnKEjrF-Q@mail.gmail.com>
References: <CAL_JsqK9Wquv6kgefyPvy0JqXNO7Cx2+iN_ss=CtgXnKEjrF-Q@mail.gmail.com>
X-Provags-ID: V03:K0:KyJ7AZaAIrv2YfDv4pPTg/Ln9f1mpnVnByN62EkZVpFIFvlEg6A
 MBQqxbMl2S3x9qHeto9KIpn1IaPiveCAXtmTwxP/Ya3BCoT0G2CQeO0+FZngcx7am9dnfe/
 HVwqei1YwBnOCVtTiDd1pYJbBPpjaLyt/Ixkm8CRa3bqW+OoTcGLF4fWcHbfz94GGATnXgu
 zwQpwmSsAX661WneDTV4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

xrealloc never returns null

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 util.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/util.c b/util.c
index be67836..1ce8b97 100644
--- a/util.c
+++ b/util.c
@@ -219,10 +219,6 @@ int utilfdt_read_err_len(const char *filename, char **buffp, off_t *len)
 		if (offset == bufsize) {
 			bufsize *= 2;
 			buf = xrealloc(buf, bufsize);
-			if (!buf) {
-				ret = ENOMEM;
-				break;
-			}
 		}
 
 		ret = read(fd, &buf[offset], bufsize - offset);
-- 
1.7.10.4

