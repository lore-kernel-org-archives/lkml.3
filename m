Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaETRle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:41:34 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:39137 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaETRlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:41:32 -0400
Message-ID: <537B93CB.3040109@cogentembedded.com>
Date: Tue, 20 May 2014 21:41:31 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] kernel: add calibration_delay_done()
References: <1400600176-435-1-git-send-email-pdeschrijver@nvidia.com> <1400600176-435-2-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1400600176-435-2-git-send-email-pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 07:36 PM, Peter De Schrijver wrote:

> Add calibration_delay_done() call and dummy implementation. This allows
> architectures to stop accepting registrations for new timer based delay
> functions.

> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>   init/calibrate.c |   12 ++++++++++++
>   1 files changed, 12 insertions(+), 0 deletions(-)

> diff --git a/init/calibrate.c b/init/calibrate.c
> index 520702d..31cae76 100644
> --- a/init/calibrate.c
> +++ b/init/calibrate.c
> @@ -262,6 +262,16 @@ unsigned long __attribute__((weak)) calibrate_delay_is_known(void)
>   	return 0;
>   }
>
> +/*
> + * Indicate the cpu delay calibration is done. This can be used by
> + * architectures to stop accepting delay timer registrations after this point.
> + */
> +
> +void __attribute__((weak)) calibration_delay_done(void)
> +{
> +	return;

    Not really needed.

> +}
> +
>   void calibrate_delay(void)
>   {
>   	unsigned long lpj;

WBR, Sergei

