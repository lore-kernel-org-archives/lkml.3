Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3A3TCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:02:22 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:47392 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab3A3TCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:02:20 -0500
Date: Wed, 30 Jan 2013 20:02:09 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH] ptp: PTP_1588_CLOCK_PCH depends on x86
Message-ID: <20130130190207.GB6283@netboy.at.omicron.at>
References: <510958D5.7060206@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510958D5.7060206@suse.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 12:31:01PM -0500, Jeff Mahoney wrote:
> The EG20T PCH is only compatible with Intel Atom processors so it
> should depend on x86.

Yes, there is something wrong with PTP_1588_CLOCK_PCH. The last
several times I did 'make oldconfig' for various configs, it asked me
whether to enable this 'new' option. That is really annoying,
especially with non-atom and non-x86 builds.

Ben, you removed the PCH_GBE dependency in 18d359ce. Are you sure that
was the right thing to do?

Thanks,
Richard

 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  drivers/ptp/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/drivers/ptp/Kconfig
> +++ b/drivers/ptp/Kconfig
> @@ -72,6 +72,7 @@ config DP83640_PHY
>  
>  config PTP_1588_CLOCK_PCH
>  	tristate "Intel PCH EG20T as PTP clock"
> +	depends on X86
>  	select PTP_1588_CLOCK
>  	help
>  	  This driver adds support for using the PCH EG20T as a PTP
> 
> -- 
> Jeff Mahoney
> SUSE Labs
