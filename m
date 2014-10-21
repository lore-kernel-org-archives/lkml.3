Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbaJULtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:49:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167AbaJULtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:49:09 -0400
Message-ID: <5446482C.1000003@redhat.com>
Date: Tue, 21 Oct 2014 13:49:00 +0200
From: =?windows-1252?Q?Matej_Mu=9Eila?= <mmuzila@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: kys@microsoft.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] tools: hv: fcopy_daemon: Check buffer limits
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matej Mužila <mmuzila@redhat.com>

Check if cpmsg->size is in limits of DATA_FRAGMENT

Signed-off-by: Matej Mužila <mmuzila@redhat.com>
Acked-by:  K. Y. Srinivasan <kys@microsoft.com>
---
If corrupted data are read from /dev/vmbus/hv_fcopy, pwrite can
read from memory outside of the buffer (defined at line 138).
Added check. 
---
@@ -104,6 +104,10 @@ static int hv_copy_data(struct hv_do_fcopy *cpmsg)
 {
 	ssize_t bytes_written;
 
+	// Check if the cpmsg->size is in limits of DATA_FRAGMENT
+	if (cpmsg->size > DATA_FRAGMENT * sizeof(__u8))
+		return HV_E_FAIL;
+
 	bytes_written = pwrite(target_fd, cpmsg->data, cpmsg->size,
 				cpmsg->offset);

