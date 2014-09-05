Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaIETGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 15:06:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16827 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbaIETGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 15:06:03 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-f79e46d00000134f-36-540a0998f1bb
Content-transfer-encoding: 8BIT
From: Karol Lewandowski <k.lewandowsk@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: lmctlx@gmail.com, Karol Lewandowski <k.lewandowsk@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 3.14-stable] usb: gadget: f_fs: drop duplicate
 usb_functionfs_descs_head declaration
Date: Fri, 05 Sep 2014 21:04:44 +0200
Message-id: <1409943884-13823-1-git-send-email-k.lewandowsk@samsung.com>
X-Mailer: git-send-email 2.0.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t9jQd0ZnFwhBruWmFkcvF9v0bx4PZtF
	46e5zBaXd81hs1h44BG7xYLjLawWCzY+YnRg99g56y67x/65a9g91v15xeTRt2UVo8fxG9uZ
	PD5vkgtgi+KySUnNySxLLdK3S+DKOHRlJ1PBC4GKW9d+sDQwfuPtYuTkkBAwkbj46QIjhC0m
	ceHeerYuRi4OIYHpjBKr9x5iAUnwCghK/Jh8D8jm4GAWkJc4cikbJMwsoC4xad4iZoj6DiaJ
	iS/7wOrZBIwkvh3awAxiiwgoSGzufcYK0XCZUeLfWScQW1ggTWL1yn4mEJtFQFViTdNsdohd
	HhKHm9axQBwkJ/Hz4nX2CYx8s5CcMQvhjFlIzljAyLyKUTS1ILmgOCk911CvODG3uDQvXS85
	P3cTIzh0n0ntYFzZYHGIUYCDUYmHd8FnjhAh1sSy4srcQ4wSHMxKIrxpPzhDhHhTEiurUovy
	44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgtgskycXBKNTCqvo/nfSI4n5HvVEW135lf
	/+/YfHLJnnYlTWf16kzjtwyH2fezX0u9cmvCRkmtXqEbQs1rdPMSWcU+OabmxL15uPfEz/Ib
	86cfc91lc+TDh30/Nn/6mfz5wMT1YfWGpYv7NAQOvLn02ceR55Jff/XSP0/eT3ngLa/94lLg
	7D0RZy99tk9Z+jWwRomlOCPRUIu5qDgRAMSgzaxZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applicable for 3.14-stable only.

This commit drops duplicate declaration of struct usb_functionfs_descs_head
erronousely added in commit 28c5980b54 ("usb: gadget: f_fs: resurect
usb_functionfs_descs_head structure").

Fix from 28c5980b54 is applicable only for v3.15-rc1 and newer kernels.

This fixes error in uapi:

  /src/linux$ make -C tools usb

  make: Entering directory '/src/linux/tools'
    DESCEND  usb
  make[1]: Entering directory '/src/linux/tools/usb'
  gcc -Wall -Wextra -g -I../include -o testusb testusb.c -lpthread
  gcc -Wall -Wextra -g -I../include -o ffs-test ffs-test.c -lpthread
  In file included from ffs-test.c:41:0:
  ../../include/uapi/linux/usb/functionfs.h:42:8: error: redefinition of ‘struct usb_functionfs_descs_head’
   struct usb_functionfs_descs_head {
          ^
  ../../include/uapi/linux/usb/functionfs.h:31:8: note: originally defined here
   struct usb_functionfs_descs_head {
          ^

Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
---
 include/uapi/linux/usb/functionfs.h | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/usb/functionfs.h b/include/uapi/linux/usb/functionfs.h
index 29e9c7a..f279394 100644
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@ -27,24 +27,18 @@ struct usb_endpoint_descriptor_no_audio {
 	__u8  bInterval;
 } __attribute__((packed));
 
-/* Legacy format, deprecated as of 3.14. */
-struct usb_functionfs_descs_head {
-	__le32 magic;
-	__le32 length;
-	__le32 fs_count;
-	__le32 hs_count;
-} __attribute__((packed, deprecated));
 
 /*
  * All numbers must be in little endian order.
  */
 
+/* Legacy format, deprecated as of 3.14. */
 struct usb_functionfs_descs_head {
 	__le32 magic;
 	__le32 length;
 	__le32 fs_count;
 	__le32 hs_count;
-} __attribute__((packed));
+} __attribute__((packed, deprecated));
 
 /*
  * Descriptors format:
-- 
2.0.1

