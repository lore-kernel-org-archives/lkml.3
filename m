Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbaJCVdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:33:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbaJCVdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:33:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Y.C. Chen" <yc_chen@aspeedtech.com>, Egbert Eich <eich@suse.de>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.16 080/357] drm/ast: open key before detect chips
Date: Fri,  3 Oct 2014 14:27:46 -0700
Message-Id: <20141003212935.890237329@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Y.C. Chen" <yc_chen@aspeedtech.com>

commit 8f372e250ae5f4a5faf87ca1a629d0ae59db65b6 upstream.

Some config settings like 3rd TX chips will not get correctly
if the extended reg is protected

Signed-off-by: Y.C. Chen <yc_chen@aspeedtech.com>
Reviewed-by: Egbert Eich <eich@suse.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ast/ast_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/ast/ast_main.c
+++ b/drivers/gpu/drm/ast/ast_main.c
@@ -67,6 +67,7 @@ static int ast_detect_chip(struct drm_de
 {
 	struct ast_private *ast = dev->dev_private;
 	uint32_t data, jreg;
+	ast_open_key(ast);
 
 	if (dev->pdev->device == PCI_CHIP_AST1180) {
 		ast->chip = AST1100;


