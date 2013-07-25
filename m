Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab3GYXRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 19:17:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:2828 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602Ab3GYXRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 19:17:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,746,1367996400"; 
   d="scan'208";a="376248197"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Xiong Zhou <jencce.kernel@gmail.com>, Peng Tao <bergwolf@gmail.com>
CC: Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging/lustre: add BLOCK depends in Kconfig
Thread-Topic: [PATCH] staging/lustre: add BLOCK depends in Kconfig
Thread-Index: AQHOiQWa6Ypo0E8Su0K9tUbRNoTVL5l2GQ6A
Date: Thu, 25 Jul 2013 23:17:46 +0000
Message-ID: <CE170DA9.57BC6%andreas.dilger@intel.com>
In-Reply-To: <alpine.DEB.2.02.1307251458330.31610@M2420>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.106.6]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2DA4052B0AF936449A81B3BB3FA3F87B@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6PNHtvH007852

On 2013/07/25 1:06 AM, "Xiong Zhou" <jencce.kernel@gmail.com> wrote:

>From: Xiong Zhou <jencce.kernel@gmail.com>
>
>Add BLOCK depends in Kconfig for LUSTRE to fix this:
>drivers/staging/lustre/lustre/fid/../include/linux/lustre_compat25.h:117:2
>: 
>error: implicit declaration of function Ê½unregister_blkdevÊ¼
>
>Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
>---
> drivers/staging/lustre/lustre/Kconfig |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/staging/lustre/lustre/Kconfig
>b/drivers/staging/lustre/lustre/Kconfig
>index 9ae7fa8..0b45de0 100644
>--- a/drivers/staging/lustre/lustre/Kconfig
>+++ b/drivers/staging/lustre/lustre/Kconfig
>@@ -1,6 +1,6 @@
> config LUSTRE_FS
> 	tristate "Lustre file system client support"
>-	depends on STAGING && INET && m
>+	depends on STAGING && INET && BLOCK && m
> 	select LNET
> 	select CRYPTO
> 	select CRYPTO_CRC32

The Lustre client does not need a block device - it is a network
filesystem.
The one piece of code that is relevant here relates to a Lustre-optimized
"loop" device that bypasses the VFS, data copying, and DLM locking for use
by swap and such.  It would be better instead to make that code conditional
and add a new CONFIG_LUSTRE_LLOOP or similar, and only make that part
dependent
on BLOCK.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
