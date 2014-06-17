Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857AbaFQQRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:17:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:8593 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933798AbaFQQQU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:16:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,494,1400050800"; 
   d="scan'208";a="549276303"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Anil Belur <askb23@gmail.com>, "Drokin, Oleg" <oleg.drokin@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpdd-discuss@lists.01.org" <hpdd-discuss@ml01.01.org>
Subject: Re: [PATCH v6 3/8] staging: lustre: lclient: lcommon_misc.c fixing
 coding style issues
Thread-Topic: [PATCH v6 3/8] staging: lustre: lclient: lcommon_misc.c fixing
 coding style issues
Thread-Index: AQHPie/HPjsJvI0URkuobk/VOpb4pJt1jACA
Date: Tue, 17 Jun 2014 16:15:53 +0000
Message-ID: <CFC5C5CA.ABDA9%andreas.dilger@intel.com>
References: <1402983839-3549-1-git-send-email-askb23@gmail.com>
 <1402983839-3549-4-git-send-email-askb23@gmail.com>
In-Reply-To: <1402983839-3549-4-git-send-email-askb23@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.252.132.85]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B895495643F14548AD8FD1C192E16F11@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/06/16, 11:43 PM, "Anil Belur" <askb23@gmail.com> wrote:

>From: Anil Belur <askb23@gmail.com>
>
>fixed warning:
>* WARNING: min() should probably be min_t(__u32, desc.ld_tgt_count,
>LOV_MAX_STRIPE_COUNT)
>
>Signed-off-by: Anil Belur <askb23@gmail.com>
>---
> drivers/staging/lustre/lustre/lclient/lcommon_misc.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
>b/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
>index 21de1cd..0900bef 100644
>--- a/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
>+++ b/drivers/staging/lustre/lustre/lclient/lcommon_misc.c
>@@ -63,7 +63,7 @@ int cl_init_ea_size(struct obd_export *md_exp, struct
>obd_export *dt_exp)
> 	if (rc)
> 		return rc;
> 
>-	stripes = min(desc.ld_tgt_count, (__u32)LOV_MAX_STRIPE_COUNT);
>+	stripes = min_t(__u32, desc.ld_tgt_count, (__u32)LOV_MAX_STRIPE_COUNT);

If you are using min_t(__u32, ...) then there is no need for the (__u32)
cast of
LOV_MAX_STRIPE_COUNT, since that is the whole point of min_t() that the
cast is
done internally.

> 	lsm.lsm_stripe_count = stripes;
> 	easize = obd_size_diskmd(dt_exp, &lsm);
> 
>-- 
>1.9.0
>
>


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


