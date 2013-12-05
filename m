Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab3LEImG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 03:42:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48748 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab3LEImE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 03:42:04 -0500
Date: Thu, 5 Dec 2013 11:41:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Serban Constantinescu <serban.constantinescu@arm.com>
Cc: gregkh@linuxfoundation.org, arve@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        ccross@android.com, Dave.Butcher@arm.com, irogers@google.com,
        romlem@android.com
Subject: Re: [PATCH v1 4/9] staging: android: binder: Add align_helper() macro
Message-ID: <20131205084149.GX28413@mwanda>
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com>
 <1386180581-6710-5-git-send-email-serban.constantinescu@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386180581-6710-5-git-send-email-serban.constantinescu@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 06:09:36PM +0000, Serban Constantinescu wrote:
> This patch adds align_helper() macro that will be used for enforcing
> the desired alignment on 64bit systems where the alignment will differ
> depending on the userspace used (32bit /64bit).
> 
> This patch is a temporary patch that will be extended with 32bit compat
> handling.
> 
> Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
> ---
>  drivers/staging/android/binder.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index 16109cd..6719a53 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -140,6 +140,8 @@ module_param_call(stop_on_user_error, binder_set_stop_on_user_error,
>  			binder_stop_on_user_error = 2; \
>  	} while (0)
>  
> +#define align_helper(ptr)	    ALIGN(ptr, sizeof(void *))
> +

This is a terrible name.

regards,
dan carpenter

