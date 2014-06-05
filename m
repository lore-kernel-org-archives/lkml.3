Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaFEE2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:28:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610AbaFEEWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 194/214] speakup: lower default software speech rate
Date: Wed,  4 Jun 2014 21:19:17 -0700
Message-Id: <20140605041705.498500005@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Thibault <samuel.thibault@ens-lyon.org>

commit cfd757010691eae4e17acc246f74e7622c3a2f05 upstream.

Speech synthesis beginners need a low speech rate, and trained people
want a high speech rate.  A medium speech rate is thus actually not a
good default for neither.  Since trained people will typically know how
to change the rate, better default for a low speech rate, which
beginners can grasp and learn how to increase it afterwards

This was agreed with users on the speakup mailing list.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/speakup/speakup_soft.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/speakup/speakup_soft.c
+++ b/drivers/staging/speakup/speakup_soft.c
@@ -46,7 +46,7 @@ static int misc_registered;
 static struct var_t vars[] = {
 	{ CAPS_START, .u.s = {"\x01+3p" } },
 	{ CAPS_STOP, .u.s = {"\x01-3p" } },
-	{ RATE, .u.n = {"\x01%ds", 5, 0, 9, 0, 0, NULL } },
+	{ RATE, .u.n = {"\x01%ds", 2, 0, 9, 0, 0, NULL } },
 	{ PITCH, .u.n = {"\x01%dp", 5, 0, 9, 0, 0, NULL } },
 	{ VOL, .u.n = {"\x01%dv", 5, 0, 9, 0, 0, NULL } },
 	{ TONE, .u.n = {"\x01%dx", 1, 0, 2, 0, 0, NULL } },


