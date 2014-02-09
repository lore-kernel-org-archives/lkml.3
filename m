Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaBITzO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 14:55:14 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:52257 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607AbaBITzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 14:55:13 -0500
Message-ID: <1391975711.25855.12.camel@x220>
Subject: Re: [PATCH 20/28] Remove OMAP_PM_SRF
From: Paul Bolle <pebolle@tiscali.nl>
To: Richard Weinberger <richard@nod.at>
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Sun, 09 Feb 2014 20:55:11 +0100
In-Reply-To: <1391971686-9517-21-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-21-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 19:55:12.0727 (UTC) FILETIME=[D82CBE70:01CF25D0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/staging/tidspbridge/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/tidspbridge/Kconfig b/drivers/staging/tidspbridge/Kconfig
> index 1b6d581..b5e74e9 100644
> --- a/drivers/staging/tidspbridge/Kconfig
> +++ b/drivers/staging/tidspbridge/Kconfig
> @@ -17,7 +17,7 @@ menuconfig TIDSPBRIDGE
>  
>  config TIDSPBRIDGE_DVFS
>  	bool "Enable Bridge Dynamic Voltage and Frequency Scaling (DVFS)"
> -	depends on TIDSPBRIDGE && OMAP_PM_SRF && CPU_FREQ
> +	depends on TIDSPBRIDGE && CPU_FREQ

You're effectively enabling the TIDSPBRIDGE_DVFS code here. As far as
I'm aware that code has _never_ been buildable (ever since it got merged
in v2.6.36).

I think TIDSPBRIDGE_DVFS (and everything depending on it) might better
be removed.


Paul Bolle

>  	help
>  	  DVFS allows DSP Bridge to initiate the operating point change to
>  	  scale the chip voltage and frequency in order to match the


