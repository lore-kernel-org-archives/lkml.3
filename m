Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373AbaBKT5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:57:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbaBKTHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.12 091/107] drm: ast,cirrus,mgag200: use drm_can_sleep
Date: Tue, 11 Feb 2014 11:05:57 -0800
Message-Id: <20140211184750.793693250@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit f4b4718b61d1d5a7442a4fd6863ea80c3a10e508 upstream.

these 3 were checking in_interrupt but we have situations where
calling vunmap under this could cause a BUG to be hit in
smp_call_function_many. Use the drm_can_sleep macro instead,
which should stop this path from been taken in this case.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/ast/ast_fb.c          |    2 +-
 drivers/gpu/drm/cirrus/cirrus_fbdev.c |    2 +-
 drivers/gpu/drm/mgag200/mgag200_fb.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/ast/ast_fb.c
+++ b/drivers/gpu/drm/ast/ast_fb.c
@@ -65,7 +65,7 @@ static void ast_dirty_update(struct ast_
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	if (!in_interrupt())
+	if (!drm_can_sleep())
 		ret = ast_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)
--- a/drivers/gpu/drm/cirrus/cirrus_fbdev.c
+++ b/drivers/gpu/drm/cirrus/cirrus_fbdev.c
@@ -39,7 +39,7 @@ static void cirrus_dirty_update(struct c
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	if (!in_interrupt())
+	if (!drm_can_sleep())
 		ret = cirrus_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)
--- a/drivers/gpu/drm/mgag200/mgag200_fb.c
+++ b/drivers/gpu/drm/mgag200/mgag200_fb.c
@@ -41,7 +41,7 @@ static void mga_dirty_update(struct mga_
 	 * then the BO is being moved and we should
 	 * store up the damage until later.
 	 */
-	if (!in_interrupt())
+	if (!drm_can_sleep())
 		ret = mgag200_bo_reserve(bo, true);
 	if (ret) {
 		if (ret != -EBUSY)


