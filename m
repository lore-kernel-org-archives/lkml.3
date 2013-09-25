Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198Ab3IYARO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:17:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab3IYARI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:17:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jianpeng Ma <majianpeng@gmail.com>, Sage Weil <sage@inktank.com>
Subject: [ 101/110] ceph: Dont forget the up_read(&osdc->map_sem) if met error.
Date: Tue, 24 Sep 2013 17:15:39 -0700
Message-Id: <20130925001334.366458001@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 494ddd11be3e2621096bb425eed2886f8e8446d4 upstream.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ceph/ioctl.c
+++ b/fs/ceph/ioctl.c
@@ -196,8 +196,10 @@ static long ceph_ioctl_get_dataloc(struc
 	r = ceph_calc_file_object_mapping(&ci->i_layout, dl.file_offset, len,
 					  &dl.object_no, &dl.object_offset,
 					  &olen);
-	if (r < 0)
+	if (r < 0) {
+		up_read(&osdc->map_sem);
 		return -EIO;
+	}
 	dl.file_offset -= dl.object_offset;
 	dl.object_size = ceph_file_layout_object_size(ci->i_layout);
 	dl.block_size = ceph_file_layout_su(ci->i_layout);


