Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3ISWCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 18:02:05 -0400
Received: from www17.your-server.de ([213.133.104.17]:57498 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3ISWBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 18:01:32 -0400
Subject: [PATCH 5/10] staging: lustre: Cocci spatch "noderef"
From: Thomas Meyer <thomas@m3y3r.de>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-ID: <1379604755852-1078753665-5-diffsplit-thomas@m3y3r.de>
References: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
In-Reply-To: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
Date: Thu, 19 Sep 2013 23:45:46 +0200
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof when applied to a pointer typed expression gives the size of the
pointer.
Found by coccinelle spatch "misc/noderef.cocci"

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/staging/lustre/lustre/obdecho/echo_client.c b/drivers/staging/lustre/lustre/obdecho/echo_client.c
--- a/drivers/staging/lustre/lustre/obdecho/echo_client.c
+++ b/drivers/staging/lustre/lustre/obdecho/echo_client.c
@@ -1387,7 +1387,7 @@ echo_copyout_lsm (struct lov_stripe_md *
 	if (nob > ulsm_nob)
 		return (-EINVAL);
 
-	if (copy_to_user (ulsm, lsm, sizeof(ulsm)))
+	if (copy_to_user (ulsm, lsm, sizeof(*ulsm)))
 		return (-EFAULT);
 
 	for (i = 0; i < lsm->lsm_stripe_count; i++) {
