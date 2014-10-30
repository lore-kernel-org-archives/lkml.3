Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760035AbaJ3Nc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:32:57 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:36653 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759506AbaJ3Ncy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:32:54 -0400
X-Originating-IP: 50.43.41.112
Date: Thu, 30 Oct 2014 06:32:42 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aristeu Rozanski <aris@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.18] tiny: rename ENABLE_DEV_COREDUMP to
 ALLOW_DEV_COREDUMP
Message-ID: <20141030133242.GA32205@thin>
References: <20141016133658.GP5930@redhat.com>
 <20141016134430.GB7664@thin>
 <20141016154949.GR5930@redhat.com>
 <1413798151.10246.10.camel@jlt4.sipsolutions.net>
 <20141020115511.GA28133@thin>
 <20141020221800.GB2101@kroah.com>
 <1414656079.1823.1.camel@jlt4.sipsolutions.net>
 <1414659635.1823.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414659635.1823.3.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 10:00:35AM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The ENABLE_DEV_COREDUMP option is misleading as it implies that
> it gets the framework enabled, this isn't true it just allows it
> to get enabled if a driver needs it.
> 
> Rename it to ALLOW_DEV_COREDUMP to better capture its semantics.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Seems reasonable.  The original "DISABLE" was really "FORCE_DISABLE"
(even if used), and the inverse of "FORCE_DISABLE" is not "ENABLE", it's
"ALLOW" (if used).

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/base/Kconfig | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 99d30729d11e..e9f96afe920d 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -171,8 +171,8 @@ config WANT_DEV_COREDUMP
>  	  Drivers should "select" this option if they desire to use the
>  	  device coredump mechanism.
>  
> -config ENABLE_DEV_COREDUMP
> -	bool "Enable device coredump" if EXPERT
> +config ALLOW_DEV_COREDUMP
> +	bool "Allow device coredump" if EXPERT
>  	default y
>  	help
>  	  This option controls if the device coredump mechanism is available or
> @@ -187,7 +187,7 @@ config ENABLE_DEV_COREDUMP
>  config DEV_COREDUMP
>  	bool
>  	default y if WANT_DEV_COREDUMP
> -	depends on ENABLE_DEV_COREDUMP
> +	depends on ALLOW_DEV_COREDUMP
>  
>  config DEBUG_DRIVER
>  	bool "Driver Core verbose debug messages"
> -- 
> 2.1.0
> 
> 
