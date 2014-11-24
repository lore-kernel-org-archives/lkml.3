Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075AbaKXXkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 18:40:52 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:26893 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaKXXkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 18:40:51 -0500
Date: Tue, 25 Nov 2014 02:40:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Zahari Doychev <zahari.doychev@linux.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        oleg.drokin@intel.com, bergwolf@gmail.com, andreas.dilger@intel.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] [drivers] staging/lustre: fix sparse warnings
Message-ID: <20141124234036.GA4835@mwanda>
References: <cover.1416853961.git.zahari.doychev@linux.com>
 <76b947454ee1a19847633c913f8ac28520aa0574.1416853961.git.zahari.doychev@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76b947454ee1a19847633c913f8ac28520aa0574.1416853961.git.zahari.doychev@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 07:55:41PM +0100, Zahari Doychev wrote:
> --- a/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
> +++ b/drivers/staging/lustre/include/linux/lnet/lib-lnet.h
> @@ -784,7 +784,8 @@ lnet_copy_iov2flat(int dlen, void *dest, unsigned int doffset,
>  		   unsigned int nsiov, struct iovec *siov, unsigned int soffset,
>  		   unsigned int nob)
>  {
> -	struct iovec diov = {/*.iov_base = */ dest, /*.iov_len = */ dlen};
> +	struct iovec diov = {/*.iov_base = */ (void __user *)dest,
> +			     /*.iov_len = */ dlen};
>  

Why can't we just make the comments into code by removing the /*
characters?  Remove the cast by declaring the data as __user data to
begin with instead of declaring it incorrectly and then casting to the
correct type later.

Also it's not allowed to send two patches with the exact same subject.
Also the subject was sucky and too vague anyway.  :)

regards,
dan carpenter

