Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbbANH3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:29:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbbANH3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:29:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3.18 101/150] Drivers: hv: util: make struct hv_do_fcopy match Hyper-V host messages
Date: Tue, 13 Jan 2015 23:22:52 -0800
Message-Id: <20150114072100.440961598@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 31d4ea1a093fcf668d5f95af44b8d41488bdb7ec upstream.

An attempt to fix fcopy on i586 (bc5a5b0 Drivers: hv: util: Properly pack the data
for file copy functionality) led to a regression on x86_64 (and actually didn't fix
i586 breakage). Fcopy messages from Hyper-V host come in the following format:

struct do_fcopy_hdr   |   36 bytes
0000                  |    4 bytes
offset                |    8 bytes
size                  |    4 bytes
data                  | 6144 bytes

On x86_64 struct hv_do_fcopy matched this format without ' __attribute__((packed))'
and on i586 adding ' __attribute__((packed))' to it doesn't change anything. Keep
the structure packed and add padding to match re reality. Tested both i586 and x86_64
on Hyper-V Server 2012 R2.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/hyperv.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/uapi/linux/hyperv.h
+++ b/include/uapi/linux/hyperv.h
@@ -134,6 +134,7 @@ struct hv_start_fcopy {
 
 struct hv_do_fcopy {
 	struct hv_fcopy_hdr hdr;
+	__u32   pad;
 	__u64	offset;
 	__u32	size;
 	__u8	data[DATA_FRAGMENT];


