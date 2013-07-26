Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3GZGyK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 02:54:10 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:51365 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3GZGyG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 02:54:06 -0400
MIME-Version: 1.0
In-Reply-To: <CE170DA9.57BC6%andreas.dilger@intel.com>
References: <alpine.DEB.2.02.1307251458330.31610@M2420>
	<CE170DA9.57BC6%andreas.dilger@intel.com>
Date: Fri, 26 Jul 2013 14:54:04 +0800
Message-ID: <CADJHv_tL0R6m2YRu9d6jp3CuwC_z_0SQhpGD8YeAeU4wen98DA@mail.gmail.com>
Subject: Re: [PATCH] staging/lustre: add BLOCK depends in Kconfig
From: Xiong Zhou <jencce.kernel@gmail.com>
To: "Dilger, Andreas" <andreas.dilger@intel.com>
Cc: Peng Tao <bergwolf@gmail.com>, Jiri Kosina <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/26 Dilger, Andreas <andreas.dilger@intel.com>:
> On 2013/07/25 1:06 AM, "Xiong Zhou" <jencce.kernel@gmail.com> wrote:
>
>>From: Xiong Zhou <jencce.kernel@gmail.com>
>>
>>Add BLOCK depends in Kconfig for LUSTRE to fix this:
>>drivers/staging/lustre/lustre/fid/../include/linux/lustre_compat25.h:117:2
>>:
>>error: implicit declaration of function ʽunregister_blkdevʼ
>>
>>Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
>>---
>> drivers/staging/lustre/lustre/Kconfig |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>>diff --git a/drivers/staging/lustre/lustre/Kconfig
>>b/drivers/staging/lustre/lustre/Kconfig
>>index 9ae7fa8..0b45de0 100644
>>--- a/drivers/staging/lustre/lustre/Kconfig
>>+++ b/drivers/staging/lustre/lustre/Kconfig
>>@@ -1,6 +1,6 @@
>> config LUSTRE_FS
>>       tristate "Lustre file system client support"
>>-      depends on STAGING && INET && m
>>+      depends on STAGING && INET && BLOCK && m
>>       select LNET
>>       select CRYPTO
>>       select CRYPTO_CRC32
>
> The Lustre client does not need a block device - it is a network
> filesystem.
> The one piece of code that is relevant here relates to a Lustre-optimized
> "loop" device that bypasses the VFS, data copying, and DLM locking for use
> by swap and such.  It would be better instead to make that code conditional
> and add a new CONFIG_LUSTRE_LLOOP or similar, and only make that part
> dependent
> on BLOCK.
>
> Cheers, Andreas
> --
> Andreas Dilger
>

This makes sence. I noticed that this patch has gone into Greg's tree,
so a coming patch
based on this patch is cool?

> Lustre Software Architect
> Intel High Performance Data Division
>
>
