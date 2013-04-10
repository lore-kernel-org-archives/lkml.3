Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763035Ab3DJXKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:10:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937250Ab3DJWra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [ 39/64] remoteproc: fix error path of handle_vdev
Date: Wed, 10 Apr 2013 15:46:36 -0700
Message-Id: <20130410224342.287479200@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

commit cde42e076c1cdd69a1f955d66ff6596bad3d2105 upstream.

Remove the vdev entry from the list before freeing it,
otherwise rproc->vdevs will explode.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
Acked-by: Ido Yariv <ido@wizery.com>
[edit subject, minor commit log edit, cc stable]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/remoteproc_core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -370,10 +370,12 @@ static int rproc_handle_vdev(struct rpro
 	/* it is now safe to add the virtio device */
 	ret = rproc_add_virtio_dev(rvdev, rsc->id);
 	if (ret)
-		goto free_rvdev;
+		goto remove_rvdev;
 
 	return 0;
 
+remove_rvdev:
+	list_del(&rvdev->node);
 free_rvdev:
 	kfree(rvdev);
 	return ret;


