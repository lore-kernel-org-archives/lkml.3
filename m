Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3LNVqY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 16:46:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab3LNVqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 16:46:23 -0500
Date: Sat, 14 Dec 2013 13:48:20 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>
Subject: Re: [PATCH 1/2] ion: Don't allow building ION as a module.
Message-ID: <20131214214820.GA26981@kroah.com>
References: <20131214170618.GA17461@kroah.com>
 <1387051606-10440-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387051606-10440-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 12:06:45PM -0800, John Stultz wrote:
> ION doesn't export the proper symbols for it to be a module. This
> causes build issues when ION is configured as a module.
> 
> Since Andorid kernels rarely use modules (I think recent policy
> requires no modules?), go ahead and set the ION config to a bool
> from the tristate option.
> 
> If folks decide ION as a module is important, we will have to go
> through and export the various needed symbols.
> 
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  drivers/staging/android/ion/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/android/ion/Kconfig b/drivers/staging/android/ion/Kconfig
> index a342d96..b95281e 100644
> --- a/drivers/staging/android/ion/Kconfig
> +++ b/drivers/staging/android/ion/Kconfig
> @@ -1,5 +1,5 @@
>  menuconfig ION
> -	tristate "Ion Memory Manager"
> +	bool "Ion Memory Manager"

Or you can do:
	depends on m
and leave it as a "tristate", then when switching it off, I think you
can then be prompted as 'm' again, but I could be wrong about that.

So should ION ever be able to be built as a module in the future?

thanks,

greg k-h
