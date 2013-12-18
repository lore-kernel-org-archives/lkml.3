Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab3LRWDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:03:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab3LRVMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ujjal Roy <royujjal@gmail.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 43/78] mwifiex: fix memory leak issue for ibss join
Date: Wed, 18 Dec 2013 13:11:11 -0800
Message-Id: <20131218211113.118915095@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ujjal Roy <royujjal@gmail.com>

commit 517543fd72d577dde2ebd9505dc4abf26d589f9a upstream.

For IBSS join if the requested SSID matches current SSID,
it returns without freeing the allocated beacon IE buffer.

Signed-off-by: Ujjal Roy <royujjal@gmail.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/sta_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -309,8 +309,8 @@ int mwifiex_bss_start(struct mwifiex_pri
 		if (bss_desc && bss_desc->ssid.ssid_len &&
 		    (!mwifiex_ssid_cmp(&priv->curr_bss_params.bss_descriptor.
 				       ssid, &bss_desc->ssid))) {
-			kfree(bss_desc);
-			return 0;
+			ret = 0;
+			goto done;
 		}
 
 		/* Exit Adhoc mode first */


