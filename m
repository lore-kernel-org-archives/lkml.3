Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaLXO5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 09:57:23 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47342 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaLXO5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 09:57:21 -0500
Message-ID: <549AD44A.8010603@ti.com>
Date: Wed, 24 Dec 2014 08:57:14 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Eduardo Valentin <edubezval@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>, Tero Kristo <t-kristo@ti.com>
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] thermal: ti-soc-thermal: ti-bandgap.c:  Remove unused
 function
References: <1419183823-10787-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1419183823-10787-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2014 11:43 AM, Rickard Strandqvist wrote:
> Remove the function ti_bandgap_write_thot() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/thermal/ti-soc-thermal/ti-bandgap.c |   13 -------------
>  drivers/thermal/ti-soc-thermal/ti-bandgap.h |    1 -
>  2 files changed, 14 deletions(-)
> 
> diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> index 634b6ce..cbb6a5f 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> @@ -611,19 +611,6 @@ int ti_bandgap_read_thot(struct ti_bandgap *bgp, int id, int *thot)
>  }
>  
>  /**
> - * ti_bandgap_write_thot() - sets sensor current thot
> - * @bgp: pointer to bandgap instance
> - * @id: sensor id
> - * @val: desired thot value
> - *
> - * Return: 0 on success or the proper error code
> - */
> -int ti_bandgap_write_thot(struct ti_bandgap *bgp, int id, int val)
> -{
> -	return _ti_bandgap_write_threshold(bgp, id, val, true);
> -}
> -
> -/**
>   * ti_bandgap_read_tcold() - reads sensor current tcold
>   * @bgp: pointer to bandgap instance
>   * @id: sensor id
> diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.h b/drivers/thermal/ti-soc-thermal/ti-bandgap.h
> index b3adf72..976afc0 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.h
> +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.h
> @@ -371,7 +371,6 @@ struct ti_bandgap_data {
>  };
>  
>  int ti_bandgap_read_thot(struct ti_bandgap *bgp, int id, int *thot);
> -int ti_bandgap_write_thot(struct ti_bandgap *bgp, int id, int val);
>  int ti_bandgap_read_tcold(struct ti_bandgap *bgp, int id, int *tcold);
>  int ti_bandgap_write_tcold(struct ti_bandgap *bgp, int id, int val);
>  int ti_bandgap_read_update_interval(struct ti_bandgap *bgp, int id,
> 

Not sure if removing support for programming of hot threshold is a
good idea. how about ti_bandgap_write_tcold then?


-- 
Regards,
Nishanth Menon
