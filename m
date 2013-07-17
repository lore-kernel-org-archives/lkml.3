Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab3GQXqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:46:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:39414 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab3GQXqK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:46:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,688,1367996400"; 
   d="scan'208";a="366983059"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Dragos Foianu <dragos.foianu@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "tao.peng@emc.com" <tao.peng@emc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/lustre/libcfs: removed dead code from
 libcfs_string
Thread-Topic: [PATCH] staging/lustre/libcfs: removed dead code from
 libcfs_string
Thread-Index: AQHOgszXd/Ro1xFj60e8b+AkX4uMoplpmsaA
Date: Wed, 17 Jul 2013 23:46:08 +0000
Message-ID: <CE0C88AF.55812%andreas.dilger@intel.com>
In-Reply-To: <1374059124-4126-1-git-send-email-dragos.foianu@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.99.42]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F468CF5E573FC6408A3BCED7F782D032@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/07/17 5:05 AM, "Dragos Foianu" <dragos.foianu@gmail.com> wrote:

>Confirmed by cscope that the functions are not used anymore. A fresh
>compilation does not yield any errors.
>
>Signed-off-by: Dragos Foianu <dragos.foianu@gmail.com>

Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>

>---
> .../staging/lustre/lustre/libcfs/libcfs_string.c   |   48
>--------------------
> 1 file changed, 48 deletions(-)
>
>diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
>b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
>index 9edccc9..c7a1971 100644
>--- a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
>+++ b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
>@@ -132,54 +132,6 @@ int cfs_str2mask(const char *str, const char
>*(*bit2str)(int bit),
> }
> EXPORT_SYMBOL(cfs_str2mask);
> 
>-/* Duplicate a string in a platform-independent way */
>-char *cfs_strdup(const char *str, u_int32_t flags)
>-{
>-	size_t lenz; /* length of str + zero byte */
>-	char *dup_str;
>-
>-	lenz = strlen(str) + 1;
>-
>-	dup_str = kmalloc(lenz, flags);
>-	if (dup_str == NULL)
>-		return NULL;
>-
>-	memcpy(dup_str, str, lenz);
>-
>-	return dup_str;
>-}
>-EXPORT_SYMBOL(cfs_strdup);
>-
>-/**
>- * cfs_{v}snprintf() return the actual size that is printed rather than
>- * the size that would be printed in standard functions.
>- */
>-/* safe vsnprintf */
>-int cfs_vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>-{
>-	int i;
>-
>-	LASSERT(size > 0);
>-	i = vsnprintf(buf, size, fmt, args);
>-
>-	return  (i >= size ? size - 1 : i);
>-}
>-EXPORT_SYMBOL(cfs_vsnprintf);
>-
>-/* safe snprintf */
>-int cfs_snprintf(char *buf, size_t size, const char *fmt, ...)
>-{
>-	va_list args;
>-	int i;
>-
>-	va_start(args, fmt);
>-	i = cfs_vsnprintf(buf, size, fmt, args);
>-	va_end(args);
>-
>-	return  i;
>-}
>-EXPORT_SYMBOL(cfs_snprintf);
>-
> /* get the first string out of @str */
> char *cfs_firststr(char *str, size_t size)
> {
>-- 
>1.7.10.4
>
>


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


