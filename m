Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab3HFMxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 08:53:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32873 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab3HFMxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 08:53:17 -0400
Message-ID: <5200F1B4.6050004@infradead.org>
Date: Tue, 06 Aug 2013 05:53:08 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, pavel@ucw.cz, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OPP: Export opp_add()
References: <58acb4a8a4e98089078de3ed71999730b6d97b4b.1375521724.git.viresh.kumar@linaro.org>
In-Reply-To: <58acb4a8a4e98089078de3ed71999730b6d97b4b.1375521724.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2013 02:25 AM, Viresh Kumar wrote:
> Export opp_add() so that modules can use it.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>   drivers/base/power/opp.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
> index c8ec186..ef89897 100644
> --- a/drivers/base/power/opp.c
> +++ b/drivers/base/power/opp.c
> @@ -460,6 +460,7 @@ int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
>   	srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_ADD, new_opp);
>   	return 0;
>   }
> +EXPORT_SYMBOL_GPL(opp_add);

Could it be renamed to pm_opp_add() or power_opp_add() ?
The name is a bit too unspecific IMO.

>
>   /**
>    * opp_set_availability() - helper to set the availability of an opp
>


-- 
~Randy
