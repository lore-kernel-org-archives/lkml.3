Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaCXIVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:21:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15306 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaCXIVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:21:31 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-63-532feafe65da
Date: Mon, 24 Mar 2014 09:21:12 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@rjwysocki.net, linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH] cpufreq: set value of CPUFREQ_BOOST_FREQ to 0xABABABAB
Message-id: <20140324092112.74f930d3@amdc2363>
In-reply-to: <78187ea173460c871eef31432ec2a80ec657fe30.1395643393.git.viresh.kumar@linaro.org>
References: <78187ea173460c871eef31432ec2a80ec657fe30.1395643393.git.viresh.kumar@linaro.org>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jAd1/r/SDDX4fkLJ42vSD3eLHqg+s
	Fu8PPWO2uLxrDpvF594jjBZnTl9itbj89TqzRcvH9UwWG796OHB63Lm2h83jwaHNLB63/z1m
	9thytZ3F4/MmuQDWKC6blNSczLLUIn27BK6Mzy81Cq4JVrRNm8LUwPiYt4uRk0NCwERi2uPT
	7BC2mMSFe+vZuhi5OIQEFjFKnD4ylwnC+cUocW76EbAqFgFViS/bmphBbDYBPYnPd58CFXFw
	iAhoSby8mQoSZhZ4yCixZjcniC0s4C1x9vM/sHJeoPITK0+CjeEUSJB4daEfzBYSiJf4cr2d
	BcTmF5CUaP/3gxniIDuJc582sEP0Ckr8mHyPBWK+lsTmbU2sELa8xOY1b5knMArOQlI2C0nZ
	LCRlCxiZVzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER8Mz6R2MqxosDjEKcDAq8fB69OsH
	C7EmlhVX5h5ilOBgVhLhfdYLFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6UEggPbEkNTs1
	tSC1CCbLxMEp1cC4Wj23Zoux+MNYzYyeCb4lD5Zk7rlWJ8x8YfHWbSxlXB95T6jeU+yPPnvD
	8cGU+Pt9uWUy09cd3Td9XdbW/GQpXts3lUI1grlFOv9VuNZ1FE9wOZzeJe3WnWQWvfX4lUNS
	PWodIYXR7H3t/JyiE+NmdeyZctmOqdLPsLp1za6/wjr/w+b9eaXEUpyRaKjFXFScCAC7VbtP
	ggIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> Ideally, .driver_data field of struct cpufreq_frequency_table must
> not be used by core at all. But during a recent change if its value
> is same as CPUFREQ_BOOST_FREQ macro, then it is treated specially by
> core.
> 
> The value of this macro was set to ~2 earlier, i.e. 0xFFFFFFFD. In
> case some driver is using this field for its own data and sets this
> field to -3, then with two's complement that value will also become
> 0xFFFFFFFD.
> 
> To fix this issue, lets change value of this flag to a very uncommon
> value which shouldn't be used by any driver unless they want to use
> BOOST feature.
> 
> Along with this update comments to make this more clear.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> 
> Gautham/Vaidy: I hope this fixes the problem we discussed for your
> patchset.
> 

I think that a name of the patchset, for which the current setting
causes problem would be welcome here.

Otherwise, I can only ask why it is not possible to add 
#define SPECIAL_SETTING ~3 ?


>  include/linux/cpufreq.h | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index c48e595..9f25d9d 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -455,12 +455,18 @@ extern struct cpufreq_governor
> cpufreq_gov_conservative;
>   *                     FREQUENCY TABLE HELPERS
> *
> *********************************************************************/ 
> +/* Special Values of .frequency field */
>  #define CPUFREQ_ENTRY_INVALID ~0
>  #define CPUFREQ_TABLE_END     ~1
> -#define CPUFREQ_BOOST_FREQ    ~2
> +/* Special Values of .driver_data field */
> +#define CPUFREQ_BOOST_FREQ    0xABABABAB
>  
>  struct cpufreq_frequency_table {
> -	unsigned int	driver_data; /* driver specific data,
> not used by core */
> +	/*
> +	 * driver specific data, not used by core unless it is set to
> +	 * CPUFREQ_BOOST_FREQ.
> +	 */
> +	unsigned int	driver_data;
>  	unsigned int	frequency; /* kHz - doesn't need to be
> in ascending
>  				    * order */
>  };



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
