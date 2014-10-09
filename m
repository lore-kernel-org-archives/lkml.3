Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaJIDO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 23:14:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:63299 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaJIDOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 23:14:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="397417801"
Message-ID: <1412824458.13621.5.camel@rzhang1-toshiba>
Subject: Re: [PATCH 1/3] thermal: step_wise: fix: Prevent from binary
 overflow when trend is dropping
From: Zhang Rui <rui.zhang@intel.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 09 Oct 2014 11:14:18 +0800
In-Reply-To: <1411547232-21493-2-git-send-email-l.majewski@samsung.com>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
	 <1411547232-21493-2-git-send-email-l.majewski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-24 at 10:27 +0200, Lukasz Majewski wrote:
> It turns out that some boards can have instance->lower greater than 0 and
> when thermal trend is dropping it results with next_target equal to -1.
> 
> Since the next_target is defined as unsigned long it is interpreted as
> 0xFFFFFFFF and larger than instance->upper.
> As a result the next_target is set to instance->upper which ramps up to
> maximal cooling device target when the temperature is steadily decreasing.
> 
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>

applied.

thanks,
rui
> ---
>  drivers/thermal/step_wise.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
> index 3b54c2c..fdd1f52 100644
> --- a/drivers/thermal/step_wise.c
> +++ b/drivers/thermal/step_wise.c
> @@ -77,7 +77,7 @@ static unsigned long get_target_state(struct thermal_instance *instance,
>  			next_target = instance->upper;
>  		break;
>  	case THERMAL_TREND_DROPPING:
> -		if (cur_state == instance->lower) {
> +		if (cur_state <= instance->lower) {
>  			if (!throttle)
>  				next_target = THERMAL_NO_TARGET;
>  		} else {


