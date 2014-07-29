Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaG2Ujf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 16:39:35 -0400
Received: from merkurneu.hrz.uni-giessen.de ([134.176.2.3]:52871 "EHLO
	merkurneu.hrz.uni-giessen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466AbaG2Ujd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 16:39:33 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jul 2014 16:39:33 EDT
From: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Julian Andres Klode <jak@jak-linux.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ac100@lists.launchpad.net, linux-tegra@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] staging/nvec: Do not pass resource to mfd_add_devices()
Date: Tue, 29 Jul 2014 22:23:17 +0200
Message-Id: <21317349.CjmK2Kpl80@ax5200p>
User-Agent: KMail/4.13.2 (Linux/3.13.0-32-generic; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1406632575-26075-1-git-send-email-thierry.reding@gmail.com>
References: <1406632575-26075-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-HRZ-JLUG-MailScanner-Information: Passed JLUG virus check
X-HRZ-JLUG-MailScanner: No virus found
X-Envelope-From: marc.dietrich@ap.physik.uni-giessen.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 29 Juli 2014, 13:16:14 schrieb Thierry Reding:
> From: Thierry Reding <treding@nvidia.com>
> 
> The mfd_add_devices() function takes a struct resource * as fifth
> argument, but the nvec driver passes in a void __iomem *. The driver
> gets away with it because none of the subdevices ever directly access
> the registers.
> 
> Since subdevices never need to access the registers we can simply pass
> NULL instead.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Acked-by: Marc Dietrich <marvin24@gmx.de>

> ---
>  drivers/staging/nvec/nvec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
> index 0a5c84ad3f41..815065837ce7 100644
> --- a/drivers/staging/nvec/nvec.c
> +++ b/drivers/staging/nvec/nvec.c
> @@ -893,7 +893,7 @@ static int tegra_nvec_probe(struct platform_device
> *pdev) }
> 
>  	ret = mfd_add_devices(nvec->dev, -1, nvec_devices,
> -			      ARRAY_SIZE(nvec_devices), base, 0, NULL);
> +			      ARRAY_SIZE(nvec_devices), NULL, 0, NULL);
>  	if (ret)
>  		dev_err(nvec->dev, "error adding subdevices\n");

