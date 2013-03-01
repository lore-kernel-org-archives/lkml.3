Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140Ab3CAFbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:31:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45215 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab3CAFbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:31:21 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <1362115638-10583-2-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1362115638-10583-1-git-send-email-lig.fnst@cn.fujitsu.com> <1362115638-10583-2-git-send-email-lig.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 2/2] x86: add e820 descriptor attribute field
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Feb 2013 21:28:58 -0800
To: liguang <lig.fnst@cn.fujitsu.com>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20d755b3-7796-4f9a-b446-84c6678834f5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK in the extreme.  Not only does this break the bootloader protocol, but there are systems in the field that break if you give e820 anything other than a 20-byte buffer.

liguang <lig.fnst@cn.fujitsu.com> wrote:

>according to ACPI 5.0 Table 15-273
>Address Range Descriptor Structure,
>offset 20 is 32-bit field of Extended
>Attributes for Address Range Descriptor Structure.
>
>Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
>---
> arch/x86/include/uapi/asm/e820.h |    7 ++++++-
> 1 files changed, 6 insertions(+), 1 deletions(-)
>
>diff --git a/arch/x86/include/uapi/asm/e820.h
>b/arch/x86/include/uapi/asm/e820.h
>index 2d400b1..eb87284 100644
>--- a/arch/x86/include/uapi/asm/e820.h
>+++ b/arch/x86/include/uapi/asm/e820.h
>@@ -38,6 +38,10 @@
> #define E820_TYPE_NVS	4
> #define E820_TYPE_UNUSABLE	5
> 
>+#define E820_ATTRIB_NV 0x2
>+#define E820_ATTRIB_SLOW_ACCESS 0x4
>+#define E820_ATTRIB_ERR_LOG 0x8
>+
> 
> /*
>  * reserved RAM used by kernel itself
>@@ -53,7 +57,8 @@ struct e820entry {
> 	__u64 addr;	/* start of memory segment */
> 	__u64 size;	/* size of memory segment */
> 	__u32 type;	/* type of memory segment */
>-} __attribute__((packed));
>+	__u32 attrib;
>+};
> 
> struct e820map {
> 	__u32 nr_map;

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
