Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab3GJWnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:43:11 -0400
Received: from mout.gmx.net ([212.227.17.20]:52573 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474Ab3GJWnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:43:08 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH 3/4] tpm: Convert tpm_tis driver to use dev_pm_ops from legacy pm_ops
Date: Thu, 11 Jul 2013 00:51:04 +0200
User-Agent: KMail/1.13.7 (Linux/3.8.11; KDE/4.9.5; x86_64; ; )
Cc: Shuah Khan <shuah.kh@samsung.com>, rafael.j.wysocki@intel.com,
        bhelgaas@google.com, a.zummo@towertech.it, key@linux.vnet.ibm.com,
        mail@srajiv.net, tpmdd@selhorst.net, tpmdd@sirrix.com,
        matthew.garrett@nebula.com, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        shuahkhan@gmail.com
References: <1373429409-3944-1-git-send-email-shuah.kh@samsung.com>
In-Reply-To: <1373429409-3944-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201307110051.04726.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:4EktA2Y0BfX2Zx3BaoOA/NF5dv8H+T3vPRE2X/L1loYiv5TyBai
 FuEjYT82VOtnxFytz2SzBEQXqQ2c4gnmKpLIDG1MmoUBQdWV/NhloDDjXzMVzQG0aaVvllO
 H8F/TDgPOlmFUch0bwtRGkdRIgjUl1DI0FeHu3wGVvZdjgQ5tZThWpzLJZ5m55cwfLv5Gda
 y7pEDXU6HwPEO83azGgQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for your patch
>  static struct pnp_device_id tpm_pnp_tbl[] = {
>  	{"PNP0C31", 0},		/* TPM */
>  	{"ATM1200", 0},		/* Atmel */
> @@ -835,9 +834,12 @@ static struct pnp_driver tis_pnp_driver = {
>  	.name = "tpm_tis",
>  	.id_table = tpm_pnp_tbl,
>  	.probe = tpm_tis_pnp_init,
> -	.suspend = tpm_tis_pnp_suspend,
> -	.resume = tpm_tis_pnp_resume,
>  	.remove = tpm_tis_pnp_remove,
> +#ifdef CONFIG_PM_SLEEP
> +	.driver	= {
> +		.pm = &tpm_tis_pm,
> +	},
> +#endif
>  };


I don't think the #if CONFIG_PM_SLEEP is required here.

Thanks,
Peter
