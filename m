Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbaFEAXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:23:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbaFDXW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 3.14 128/228] clk: vexpress: NULL dereference on error path
Date: Wed,  4 Jun 2014 16:22:37 -0700
Message-Id: <20140604232352.141066508@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 6b4ed8b00e93bd31f24a25f59ed8d1b808d0cc00 upstream.

If the allocation fails then we dereference the NULL in the error path.
Just return directly.

Fixes: ed27ff1db869 ('clk: Versatile Express clock generators ("osc") driver')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/versatile/clk-vexpress-osc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/versatile/clk-vexpress-osc.c
+++ b/drivers/clk/versatile/clk-vexpress-osc.c
@@ -102,7 +102,7 @@ void __init vexpress_osc_of_setup(struct
 
 	osc = kzalloc(sizeof(*osc), GFP_KERNEL);
 	if (!osc)
-		goto error;
+		return;
 
 	osc->func = vexpress_config_func_get_by_node(node);
 	if (!osc->func) {


