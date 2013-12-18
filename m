Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3LRVuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:50:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3LRVMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@redhat.com>,
        Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH 3.12 002/118] udl: fix issue with imported prime buffers
Date: Wed, 18 Dec 2013 13:10:39 -0800
Message-Id: <20131218211219.534447174@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@gmail.com>

commit 1d507b3af40a60e03a3bbc4c897fc2709c075d24 upstream.

5dc9e1e8 was a bit over-ambitious, and accidentially removed handling
for imported prime buffers.

Signed-off-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/udl/udl_gem.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/udl/udl_gem.c
+++ b/drivers/gpu/drm/udl/udl_gem.c
@@ -132,6 +132,12 @@ static int udl_gem_get_pages(struct udl_
 
 static void udl_gem_put_pages(struct udl_gem_object *obj)
 {
+	if (obj->base.import_attach) {
+		drm_free_large(obj->pages);
+		obj->pages = NULL;
+		return;
+	}
+
 	drm_gem_put_pages(&obj->base, obj->pages, false, false);
 	obj->pages = NULL;
 }


