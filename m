Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512Ab3GZHeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 03:34:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:65359 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab3GZHeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 03:34:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,749,1367996400"; 
   d="scan'208";a="273614466"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Xiong Zhou <jencce.kernel@gmail.com>
CC: Peng Tao <bergwolf@gmail.com>, Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging/lustre: add BLOCK depends in Kconfig
Thread-Topic: [PATCH] staging/lustre: add BLOCK depends in Kconfig
Thread-Index: AQHOiQWa6Ypo0E8Su0K9tUbRNoTVL5l2GQ6AgADkFAD//6aYAA==
Date: Fri, 26 Jul 2013 07:34:05 +0000
Message-ID: <CE178240.57D7D%andreas.dilger@intel.com>
In-Reply-To: <CADJHv_tL0R6m2YRu9d6jp3CuwC_z_0SQhpGD8YeAeU4wen98DA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.106.6]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6F52E8465B606046BE36F2396DDFA47B@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6Q7YF73009562

On 2013/07/26 12:54 AM, "Xiong Zhou" <jencce.kernel@gmail.com> wrote:

>2013/7/26 Dilger, Andreas <andreas.dilger@intel.com>:
>> On 2013/07/25 1:06 AM, "Xiong Zhou" <jencce.kernel@gmail.com> wrote:
>>
>>>From: Xiong Zhou <jencce.kernel@gmail.com>
>>>
>>>Add BLOCK depends in Kconfig for LUSTRE to fix this:
>>>drivers/staging/lustre/lustre/fid/../include/linux/lustre_compat25.h:117
>>>:2
>>>:
>>>error: implicit declaration of function Ê½unregister_blkdevÊ¼
>>>
>>>Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
>>>---
>>> drivers/staging/lustre/lustre/Kconfig |    2 +-
>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>>diff --git a/drivers/staging/lustre/lustre/Kconfig
>>>b/drivers/staging/lustre/lustre/Kconfig
>>>index 9ae7fa8..0b45de0 100644
>>>--- a/drivers/staging/lustre/lustre/Kconfig
>>>+++ b/drivers/staging/lustre/lustre/Kconfig
>>>@@ -1,6 +1,6 @@
>>> config LUSTRE_FS
>>>       tristate "Lustre file system client support"
>>>-      depends on STAGING && INET && m
>>>+      depends on STAGING && INET && BLOCK && m
>>>       select LNET
>>>       select CRYPTO
>>>       select CRYPTO_CRC32
>>
>> The Lustre client does not need a block device - it is a network
>> filesystem.
>> The one piece of code that is relevant here relates to a
>>Lustre-optimized
>> "loop" device that bypasses the VFS, data copying, and DLM locking for
>>use
>> by swap and such.  It would be better instead to make that code
>>conditional
>> and add a new CONFIG_LUSTRE_LLOOP or similar, and only make that part
>> dependent on BLOCK.
>
>This makes sence. I noticed that this patch has gone into Greg's tree,
>so a coming patch based on this patch is cool?

That would be fine, thanks.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
