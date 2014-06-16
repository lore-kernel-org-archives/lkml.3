Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaFPFFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 01:05:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:17876 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbaFPFFf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 01:05:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,483,1400050800"; 
   d="scan'208";a="558024776"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Anil Belur <askb23@gmail.com>
CC: "Dilger, Andreas" <andreas.dilger@intel.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<hpdd-discuss@lists.01.org>" <hpdd-discuss@ml01.01.org>
Subject: Re: [PATCH v3 7/7] staging: lustre: lclient: lcommon_cl.c fixing
 coding style issues
Thread-Topic: [PATCH v3 7/7] staging: lustre: lclient: lcommon_cl.c fixing
 coding style issues
Thread-Index: AQHPiRuPsP6g0oDoIE+du5ChT3PTMptzpFWA
Date: Mon, 16 Jun 2014 05:05:33 +0000
Message-ID: <6D484D74-443E-4667-9CB8-4F90EC53FB81@intel.com>
References: <1402892916-5298-1-git-send-email-askb23@gmail.com>
 <1402892916-5298-7-git-send-email-askb23@gmail.com>
In-Reply-To: <1402892916-5298-7-git-send-email-askb23@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.12.165]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FE572D5D48B22D4685B224DA3E5D9C41@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 16, 2014, at 12:28 AM, Anil Belur wrote:

> From: Anil Belur <askb23@gmail.com>
> 
> fixed: WARNING: line over 80 characters and indent after the conditional
> statement
> 
> Signed-off-by: Anil Belur <askb23@gmail.com>
> ---
> drivers/staging/lustre/lustre/lclient/lcommon_cl.c | 9 ++++++---
> 1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
> index c180a20..8fed70c 100644
> --- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
> +++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
> @@ -825,6 +825,7 @@ int ccc_prep_size(const struct lu_env *env, struct cl_object *obj,
> 	loff_t	  pos   = start + count - 1;
> 	loff_t kms;
> 	int result;
> +	unsigned long cur_index;

I wonder why move this particular declaration here?
The only user is still in that one conditional branch anyway.

> 
> 	/*
> 	 * Consistency guarantees: following possibilities exist for the
> @@ -864,11 +865,13 @@ int ccc_prep_size(const struct lu_env *env, struct cl_object *obj,
> 				 * linux-2.6.18-128.1.1 miss to do that.
> 				 * --bug 17336 */
> 				loff_t size = cl_isize_read(inode);
> -				unsigned long cur_index = start >> PAGE_CACHE_SHIFT;
> +
> +				cur_index = start >> PAGE_CACHE_SHIFT;
> +				loff_t check = ((size - 1) >> PAGE_CACHE_SHIFT);

This used to produce a warning about mixing code and declarations in the past. 
Probably a bad idea to mix them anyway.

Thanks.

Bye,
    Oleg

