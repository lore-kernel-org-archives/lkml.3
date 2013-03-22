Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab3CVNOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 09:14:46 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33592 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab3CVNOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 09:14:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: linux-kernel@vger.kernel.org, andrew@lunn.ch, jason@lakedaemon.net,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] drivers: cpuidle: kirkwood: fix coccicheck warnings
Date: Fri, 22 Mar 2013 14:22:05 +0100
Message-ID: <3028121.Qzfv8ofGRj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1363911175-12502-1-git-send-email-silviupopescu1990@gmail.com>
References: <1363911175-12502-1-git-send-email-silviupopescu1990@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 22, 2013 02:12:55 AM Silviu-Mihai Popescu wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

Applied to linux-pm.git/bleeding-edge and will be moved to linux-next after
build testing.

Thanks,
Rafael


> ---
>  drivers/cpuidle/cpuidle-kirkwood.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle-kirkwood.c b/drivers/cpuidle/cpuidle-kirkwood.c
> index 670aa1e..53aad73 100644
> --- a/drivers/cpuidle/cpuidle-kirkwood.c
> +++ b/drivers/cpuidle/cpuidle-kirkwood.c
> @@ -66,9 +66,9 @@ static int kirkwood_cpuidle_probe(struct platform_device *pdev)
>  	if (res == NULL)
>  		return -EINVAL;
>  
> -	ddr_operation_base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!ddr_operation_base)
> -		return -EADDRNOTAVAIL;
> +	ddr_operation_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(ddr_operation_base))
> +		return PTR_ERR(ddr_operation_base);
>  
>  	device = &per_cpu(kirkwood_cpuidle_device, smp_processor_id());
>  	device->state_count = KIRKWOOD_MAX_STATES;
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
