Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbaBKUJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:09:41 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:49759 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbaBKUJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:09:37 -0500
Date: Tue, 11 Feb 2014 21:09:23 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Stefan =?iso-8859-1?Q?S=F8rensen?= 
	<stefan.sorensen@spectralink.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dp83640: Support a configurable number of
 periodic outputs
Message-ID: <20140211200922.GA4254@netboy>
References: <1392132562-23644-1-git-send-email-stefan.sorensen@spectralink.com>
 <1392132562-23644-2-git-send-email-stefan.sorensen@spectralink.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392132562-23644-2-git-send-email-stefan.sorensen@spectralink.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 04:29:21PM +0100, Stefan Sørensen wrote:

> diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
> index 547725f..d4fe95d 100644
> --- a/drivers/net/phy/dp83640.c
> +++ b/drivers/net/phy/dp83640.c
> @@ -38,15 +38,11 @@
>  #define LAYER4		0x02
>  #define LAYER2		0x01
>  #define MAX_RXTS	64
> -#define N_EXT_TS	6
> +#define N_EXT		8
>  #define PSF_PTPVER	2
>  #define PSF_EVNT	0x4000
>  #define PSF_RX		0x2000
>  #define PSF_TX		0x1000
> -#define EXT_EVENT	1

Regarding this EXT_EVENT thing ...

> @@ -430,12 +419,12 @@ static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
>  	switch (rq->type) {
>  	case PTP_CLK_REQ_EXTTS:
>  		index = rq->extts.index;
> -		if (index < 0 || index >= N_EXT_TS)
> +		if (index < 0 || index >= n_ext_ts)
>  			return -EINVAL;
> -		event_num = EXT_EVENT + index;
> +		event_num = index;

there was a mapping between the "event numbers" and the external time
stamp channels. I don't remember off the top of my head why this these
two differ by one, but there was a good reason.

Are you sure this is still working with this change?

I am especially wondering about the event decoding here:

> @@ -642,7 +631,7 @@ static void recalibrate(struct dp83640_clock *clock)
>  
>  static inline u16 exts_chan_to_edata(int ch)
>  {
> -	return 1 << ((ch + EXT_EVENT) * 2);
> +	return 1 << ((ch) * 2);
>  }

Maybe I am just paranoid, but can you remind me how these event
numbers are supposed to work, before and after the change?

Thanks,
Richard
