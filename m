Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbaCTA7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 20:59:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaCTA7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 20:59:30 -0400
Date: Wed, 19 Mar 2014 23:58:28 +0000
From: Greg KH <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: lgirdwood@gmail.com, broonie@kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 3.13] regulator: core: Change dummy supplies error
 message to a warning
Message-ID: <20140319235828.GC22080@kroah.com>
References: <1394054987-4743-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394054987-4743-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 02:29:47PM -0700, Shuah Khan wrote:
> Change "dummy supplies not allowed" error message to warning instead,
> as this is a just warning message with no change to the behavior.
> 
> upstream commit acc3d5cec84f82ebea535fa0bd9500ac3df2aee9
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
> 
> Back porting as the original patch tagged for stable failed to apply.
> Included Mark Brown's Signed-off from the original commit. This change
> is not applicable to 3.12 and earlier.
> 
>  drivers/regulator/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 0186c1b..804521a 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1359,7 +1359,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
>  		rdev = dummy_regulator_rdev;
>  		goto found;
>  	} else {
> -		dev_err(dev, "dummy supplies not allowed\n");
> +		dev_warn(dev, "dummy supplies not allowed\n");

This really isn't a problem that warrents a stable backport, sorry.  I
can understand distros being "annoyed" at it, but probably not.

greg k-h
