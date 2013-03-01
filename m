Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab3CAJNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 04:13:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:22277 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab3CAJNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:13:20 -0500
X-IronPort-AV: E=Sophos;i="4.84,760,1355068800"; 
   d="scan'208";a="6793726"
Subject: Re: [PATCH 2/2] x86: add e820 descriptor attribute field
From: li guang <lig.fnst@cn.fujitsu.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20d755b3-7796-4f9a-b446-84c6678834f5@email.android.com>
References: <1362115638-10583-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <1362115638-10583-2-git-send-email-lig.fnst@cn.fujitsu.com>
	 <20d755b3-7796-4f9a-b446-84c6678834f5@email.android.com>
Date: Fri, 01 Mar 2013 17:12:55 +0800
Message-ID: <1362129175.2262.86.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 17:12:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 17:12:24,
	Serialize complete at 2013/03/01 17:12:24
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

can we fix if it breaks anything?
I think there are sound reasons that
ACPI add these extended attributes.

在 2013-02-28四的 21:28 -0800，H. Peter Anvin写道：
> NAK in the extreme.  Not only does this break the bootloader protocol, but there are systems in the field that break if you give e820 anything other than a 20-byte buffer.
> 
> liguang <lig.fnst@cn.fujitsu.com> wrote:
> 
> >according to ACPI 5.0 Table 15-273
> >Address Range Descriptor Structure,
> >offset 20 is 32-bit field of Extended
> >Attributes for Address Range Descriptor Structure.
> >
> >Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> >---
> > arch/x86/include/uapi/asm/e820.h |    7 ++++++-
> > 1 files changed, 6 insertions(+), 1 deletions(-)
> >
> >diff --git a/arch/x86/include/uapi/asm/e820.h
> >b/arch/x86/include/uapi/asm/e820.h
> >index 2d400b1..eb87284 100644
> >--- a/arch/x86/include/uapi/asm/e820.h
> >+++ b/arch/x86/include/uapi/asm/e820.h
> >@@ -38,6 +38,10 @@
> > #define E820_TYPE_NVS	4
> > #define E820_TYPE_UNUSABLE	5
> > 
> >+#define E820_ATTRIB_NV 0x2
> >+#define E820_ATTRIB_SLOW_ACCESS 0x4
> >+#define E820_ATTRIB_ERR_LOG 0x8
> >+
> > 
> > /*
> >  * reserved RAM used by kernel itself
> >@@ -53,7 +57,8 @@ struct e820entry {
> > 	__u64 addr;	/* start of memory segment */
> > 	__u64 size;	/* size of memory segment */
> > 	__u32 type;	/* type of memory segment */
> >-} __attribute__((packed));
> >+	__u32 attrib;
> >+};
> > 
> > struct e820map {
> > 	__u32 nr_map;
> 


