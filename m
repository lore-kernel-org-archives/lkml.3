Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985AbaFQQYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:24:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:9856 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964824AbaFQQYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:24:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,495,1400050800"; 
   d="scan'208";a="556877156"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Anil Belur <askb23@gmail.com>, "Drokin, Oleg" <oleg.drokin@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpdd-discuss@lists.01.org" <hpdd-discuss@ml01.01.org>
Subject: Re: [PATCH v6 7/8] staging: lustre: lclient: lcommon_cl.c fixing
 coding style issues
Thread-Topic: [PATCH v6 7/8] staging: lustre: lclient: lcommon_cl.c fixing
 coding style issues
Thread-Index: AQHPie/HHDHzDcNn/kms2lFugs0Jgpt1jf6A
Date: Tue, 17 Jun 2014 16:23:01 +0000
Message-ID: <CFC5C64E.ABDAF%andreas.dilger@intel.com>
References: <1402983839-3549-1-git-send-email-askb23@gmail.com>
 <1402983839-3549-8-git-send-email-askb23@gmail.com>
In-Reply-To: <1402983839-3549-8-git-send-email-askb23@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.132.85]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11A5DEF70A92084689CAC01B2252F690@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/06/16, 11:43 PM, "Anil Belur" <askb23@gmail.com> wrote:

>From: Anil Belur <askb23@gmail.com>
>
>fixed: WARNING: line over 80 characters, used a new variable 'size_index'
>to
>store the offset. Replaceed "unsigned long" with  "loff_t" type for
>'cur_index'
>
>Signed-off-by: Anil Belur <askb23@gmail.com>
>---
> drivers/staging/lustre/lustre/lclient/lcommon_cl.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
>b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
>index 2f51b76..e2da397 100644
>--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
>+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
>@@ -821,10 +821,11 @@ int ccc_prep_size(const struct lu_env *env, struct
>cl_object *obj,
> 				 * linux-2.6.18-128.1.1 miss to do that.
> 				 * --bug 17336 */
> 				loff_t size = cl_isize_read(inode);
>-				unsigned long cur_index = start >> PAGE_CACHE_SHIFT;
>+				loff_t cur_index = start >> PAGE_CACHE_SHIFT;
>+				loff_t size_index = ((size - 1) >> PAGE_CACHE_SHIFT);

Should be an empty line between variable declarations and code.

> 
> 				if ((size == 0 && cur_index != 0) ||
>-				    (((size - 1) >> PAGE_CACHE_SHIFT) < cur_index))
>+				    (size_index < cur_index))
> 				*exceed = 1;
> 			}
> 			return result;
>-- 
>1.9.0
>
>


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


