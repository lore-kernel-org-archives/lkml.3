Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab3HSS3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 14:29:25 -0400
Received: from bitmer.com ([213.157.87.50]:42465 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3HSS3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 14:29:23 -0400
X-Greylist: delayed 1545 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Aug 2013 14:29:23 EDT
Message-ID: <52125DB9.7040405@bitmer.com>
Date: Mon, 19 Aug 2013 21:02:33 +0300
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, kernel-janitors@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ASoC: omap: simplify platform_get_resource_byname/devm_ioremap_resource
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr> <1376902316-18520-2-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1376902316-18520-2-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 08/19/2013 11:51 AM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Remove unneeded error handling on the result of a call to
> platform_get_resource_byname when the value is passed to devm_ioremap_resource.
> 
> In the case of omap-dmic.c, the error-handling code of
> devm_ioremap_resource is also corrected to include releasing the clock.
> 
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression pdev,res,e,e1;
> expression ret != 0;
> identifier l;
> @@
> 
>   res = platform_get_resource_byname(...);
> - if (res == NULL) { ... \(goto l;\|return ret;\) }
>   e = devm_ioremap_resource(e1, res);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  sound/soc/omap/omap-dmic.c  |    9 +++------
>  sound/soc/omap/omap-mcpdm.c |    3 ---
>  2 files changed, 3 insertions(+), 9 deletions(-)
> 
To the patch and catch of missing clock release in omap-dmic.c in case
of failing devm_ioremap_resource:

Acked-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
