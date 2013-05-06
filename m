Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab3EFVGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:06:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab3EFUq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Olaf Hering <olh@suse.de>
Subject: [ 048/115] Drivers: hv: vmbus: Fix a bug in hv_need_to_signal()
Date: Mon,  6 May 2013 13:44:44 -0700
Message-Id: <20130506203100.485848515@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 288fa3e022eb85fa151e0f9bcd15caeb81679af6 upstream.

As part of updating the vmbus protocol, the function hv_need_to_signal()
was introduced. This functions helps optimize signalling from guest to
host. The newly added memory barrier is needed to ensure that we correctly
decide when to signal the host.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Olaf Hering <olh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/ring_buffer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -71,6 +71,7 @@ u32 hv_end_read(struct hv_ring_buffer_in
 
 static bool hv_need_to_signal(u32 old_write, struct hv_ring_buffer_info *rbi)
 {
+	smp_mb();
 	if (rbi->ring_buffer->interrupt_mask)
 		return false;
 


