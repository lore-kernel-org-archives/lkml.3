Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab3GXR15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:27:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:21852 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab3GXR14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:27:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,736,1367996400"; 
   d="scan'208";a="375391590"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peng Tao <bergwolf@gmail.com>, Peng Tao <tao.peng@emc.com>
Subject: Re: [PATCH 8/8] staging/lustre: fix errno translate code on non-x86
Thread-Topic: [PATCH 8/8] staging/lustre: fix errno translate code on non-x86
Thread-Index: AQHOiEkCknSzAeBGAEabiy67v4W+45l0JnEA
Date: Wed, 24 Jul 2013 17:27:53 +0000
Message-ID: <CE156A09.575CF%andreas.dilger@intel.com>
In-Reply-To: <1374654692-13237-9-git-send-email-mail-agent-noreply@emc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.141.148]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2AA5850763BF9D47A0513573B44718C1@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/07/24 2:31 AM, "mail-agent-noreply@emc.com"
<mail-agent-noreply@emc.com> wrote:

>From: Peng Tao <bergwolf@gmail.com>
>
>On non-x86 we will build with Lustre's errno translate code but
>it has a few issues that break build on non-x86 platforms.

Tao
if the build is broken, wouldn't it make sense either to merge this patch
into
the original or land it earlier in the series to minimize/eliminate the
window
of un-bisectability?

Cheers, Andreas

PS - this is a bug introduced during porting to the upstream kernel, it
does
     not exist in Lustre master branch.

>Cc: Andreas Dilger <andreas.dilger@intel.com>
>Signed-off-by: Peng Tao <tao.peng@emc.com>
>---
> drivers/staging/lustre/lustre/ptlrpc/Makefile |    2 +-
> drivers/staging/lustre/lustre/ptlrpc/errno.c  |    4 +---
> 2 files changed, 2 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/staging/lustre/lustre/ptlrpc/Makefile
>b/drivers/staging/lustre/lustre/ptlrpc/Makefile
>index a379558..6d78b80 100644
>--- a/drivers/staging/lustre/lustre/ptlrpc/Makefile
>+++ b/drivers/staging/lustre/lustre/ptlrpc/Makefile
>@@ -16,7 +16,7 @@ ptlrpc_objs += sec.o sec_bulk.o sec_gc.o sec_config.o
>sec_lproc.o
> ptlrpc_objs += sec_null.o sec_plain.o nrs.o nrs_fifo.o
> 
> ptlrpc-y := $(ldlm_objs) $(ptlrpc_objs)
>-ptlrpc-$(CONFIG_LUSTRE_TRANSLATE_ERRNOS) += errno.c
>+ptlrpc-$(CONFIG_LUSTRE_TRANSLATE_ERRNOS) += errno.o
> 
> obj-$(CONFIG_PTLRPC_GSS) += gss/
> 
>diff --git a/drivers/staging/lustre/lustre/ptlrpc/errno.c
>b/drivers/staging/lustre/lustre/ptlrpc/errno.c
>index 46e259e..1c10063 100644
>--- a/drivers/staging/lustre/lustre/ptlrpc/errno.c
>+++ b/drivers/staging/lustre/lustre/ptlrpc/errno.c
>@@ -25,7 +25,7 @@
>  * Copyright (c) 2013, Intel Corporation.
>  */
> 
>-#include <libcfs/libcfs.h>
>+#include <linux/libcfs/libcfs.h>
> #include <lustre/lustre_errno.h>
> 
> /*
>@@ -184,7 +184,6 @@ static int lustre_errno_hton_mapping[] = {
> 	[EBADTYPE]		= LUSTRE_EBADTYPE,
> 	[EJUKEBOX]		= LUSTRE_EJUKEBOX,
> 	[EIOCBQUEUED]		= LUSTRE_EIOCBQUEUED,
>-	[EIOCBRETRY]		= LUSTRE_EIOCBRETRY
> };
> 
> static int lustre_errno_ntoh_mapping[] = {
>@@ -331,7 +330,6 @@ static int lustre_errno_ntoh_mapping[] = {
> 	[LUSTRE_EBADTYPE]		= EBADTYPE,
> 	[LUSTRE_EJUKEBOX]		= EJUKEBOX,
> 	[LUSTRE_EIOCBQUEUED]		= EIOCBQUEUED,
>-	[LUSTRE_EIOCBRETRY]		= EIOCBRETRY
> };
> 
> unsigned int lustre_errno_hton(unsigned int h)
>-- 
>1.7.1
>
>


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


