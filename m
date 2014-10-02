Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaJBVNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:13:43 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:48104 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbaJBVNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:13:42 -0400
Date: Thu, 2 Oct 2014 17:13:31 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] thermal: step_wise: fix: Prevent from binary
 overflow when trend is dropping
Message-ID: <20141002211325.GA5016@developer>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1411547232-21493-2-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411547232-21493-2-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lukasz,

On Wed, Sep 24, 2014 at 10:27:10AM +0200, Lukasz Majewski wrote:
> It turns out that some boards can have instance->lower greater than 0 and
> when thermal trend is dropping it results with next_target equal to -1.
> 
> Since the next_target is defined as unsigned long it is interpreted as
> 0xFFFFFFFF and larger than instance->upper.
> As a result the next_target is set to instance->upper which ramps up to
> maximal cooling device target when the temperature is steadily decreasing.
> 

Thanks for finding a problem and sending a fix.

Can you please explain a little more on how next_target reaches -1 when
lower is greater than 0?


> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
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
> -- 
> 2.0.0.rc2
> 


Eduardo
