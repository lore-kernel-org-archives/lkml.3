Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaGILKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:10:33 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25379 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbaGILKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:24 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-a9-53bd231cd8ad
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 16/21] arm: boot: compressed: disable kasan's
 instrumentation
Date: Wed, 09 Jul 2014 15:01:13 +0400
Message-id: <1404903678-8257-17-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJMWRmVeSWpSXmKPExsVy+t/xy7oyynuDDTZOE7PY9usRm8XlXXPY
	HJg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK+P5+fnMBStYK+af/8vSwLiJpYuRk0NCwERi
	34UuRghbTOLCvfVsXYxcHEICSxkl/jfOYYRw+pgkPm17yAxSxSagJ/Fv1nY2EFtEQEFic+8z
	VhCbWUBHYuO1VqYuRg4OYYFIiScf0kHCLAKqEjffbWIHsXkF3CQ6Oh5DLVOQWLZ8JlgrJ1C8
	p2cBE4gtJOAqsfrzNsYJjLwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoQEwZcdjIuP
	WR1iFOBgVOLh1ajdHSzEmlhWXJl7iFGCg1lJhNdWdG+wEG9KYmVValF+fFFpTmrxIUYmDk6p
	BsYGeaYdeiuXF0SvqnpZHLFtnso9lomRGU9yzYPaGd5UNUj8UTSe8uArp0jLJs4uzj42n1df
	Co3usu3i9Nsxf7tIaZvDA57owo3XJ0b/0Xn8oVbzRWvP/fcLOj5k/bpnnLVt+ZoacfG46Z+2
	bvq/iOmFr/86Nc3VFrGTFDMXNrd9KFW6erycOUWJpTgj0VCLuag4EQBwvqfJ4AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid build errors, compiler's instrumentation used for kernel
address sanitizer, must be disabled for code not linked with kernel.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/arm/boot/compressed/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 76a50ec..03f2976 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -4,6 +4,8 @@
 # create a compressed vmlinuz image from the original vmlinux
 #
 
+KASAN_SANITIZE := n
+
 OBJS		=
 
 # Ensure that MMCIF loader code appears early in the image
-- 
1.8.5.5

