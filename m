Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab3GNAUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 20:20:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:5925 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab3GNAUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 20:20:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,661,1367996400"; 
   d="scan'208";a="267993413"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Dragos Foianu <dragos.foianu@gmail.com>
CC: "tao.peng@emc.com" <tao.peng@emc.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging/lustre/libcfs: replaced string duplication code
 with kstrdup
Thread-Topic: [PATCH] staging/lustre/libcfs: replaced string duplication
 code with kstrdup
Thread-Index: AQHOfs32JhpGJimIYkO896487P0M3pljYu0A
Date: Sun, 14 Jul 2013 00:20:05 +0000
Message-ID: <CE0749B3.54CC0%andreas.dilger@intel.com>
In-Reply-To: <1373612526-15990-1-git-send-email-dragos.foianu@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.80.187]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <973EA885BC02EE4AABECA94194356823@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/07 1:02 AM, "Dragos Foianu" <dragos.foianu@gmail.com> wrote:

>Modified cfs_strdup function to use kstrdup instead of duplicating its
>implementation.
>
>Found using Coccinelle.

Thanks for the patch, but in fact this function doesn't appear to be used
in the code anymore and could be removed entirely.  Seems that
cfs_vsnprintf() and cfs_snprintf() could also be deleted at the same time.

Cheers, Andreas

>Signed-off-by: Dragos Foianu <dragos.foianu@gmail.com>
>---
> drivers/staging/lustre/lustre/libcfs/libcfs_string.c |   13 +------------
> 1 file changed, 1 insertion(+), 12 deletions(-)
>
>diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
>b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
>index 9edccc9..4dba304 100644
>--- a/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
>+++ b/drivers/staging/lustre/lustre/libcfs/libcfs_string.c
>@@ -135,18 +135,7 @@ EXPORT_SYMBOL(cfs_str2mask);
> /* Duplicate a string in a platform-independent way */
> char *cfs_strdup(const char *str, u_int32_t flags)
> {
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
>+	return kstrdup(str, flags);
> }
> EXPORT_SYMBOL(cfs_strdup);


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


