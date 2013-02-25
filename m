Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971Ab3BYNyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 08:54:52 -0500
Received: from smtp153.dfw.emailsrvr.com ([67.192.241.153]:33845 "EHLO
	smtp153.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612Ab3BYNyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 08:54:49 -0500
Message-ID: <512B6CEB.1030203@calxeda.com>
Date: Mon, 25 Feb 2013 07:53:47 -0600
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>
CC: "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] cpufreq: highbank: do not initialize array with a
 loop
References: <1361725277-5125-1-git-send-email-emilio@elopez.com.ar> <1361790465-21760-1-git-send-email-emilio@elopez.com.ar>
In-Reply-To: <1361790465-21760-1-git-send-email-emilio@elopez.com.ar>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2013 05:07 AM, Emilio López wrote:
> As uninitialized array members will be initialized to zero, we can
> avoid using a for loop by setting a value to it.
> 
> Signed-off-by: Emilio López <emilio@elopez.com.ar>
> ---
> 
> Note that I don't own any device using this driver, it has only been compile
> tested, but it shouldn't cause any issues.
> 
> Changes v1 -> v2:
>   * Move freq / 1000000 to the array definition as suggested by Viresh Kumar
> 
>  drivers/cpufreq/highbank-cpufreq.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
> index 66e3a71..b61b5a3 100644
> --- a/drivers/cpufreq/highbank-cpufreq.c
> +++ b/drivers/cpufreq/highbank-cpufreq.c
> @@ -28,13 +28,7 @@
>  
>  static int hb_voltage_change(unsigned int freq)
>  {
> -	int i;
> -	u32 msg[HB_CPUFREQ_IPC_LEN];
> -
> -	msg[0] = HB_CPUFREQ_CHANGE_NOTE;
> -	msg[1] = freq / 1000000;
> -	for (i = 2; i < HB_CPUFREQ_IPC_LEN; i++)
> -		msg[i] = 0;
> +	u32 msg[HB_CPUFREQ_IPC_LEN] = {HB_CPUFREQ_CHANGE_NOTE, freq / 1000000};
>  
>  	return pl320_ipc_transmit(msg);
>  }
> 
Thanks for the improvement.

Acked-By: Mark Langsdorf <mark.langsdorf@calxeda.com>

--Mark Langsdorf
Calxeda, Inc.
