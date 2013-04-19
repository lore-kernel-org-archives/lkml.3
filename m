Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030370Ab3DSNRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 09:17:03 -0400
Received: from bosmailout19.eigbox.net ([66.96.189.19]:56934 "EHLO
	bosmailout19.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030323Ab3DSNRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 09:17:01 -0400
X-Greylist: delayed 2423 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Apr 2013 09:17:01 EDT
X-Authority-Analysis: v=2.0 cv=bNyU0YCZ c=1 sm=1
 a=KF4WKpv1V4mBX7Gc70YfMw==:17 a=bc2JKO6qiGsA:10 a=FB6NmUnAAagA:10
 a=WbkzYF82lJoA:10 a=8nJEP1OIZ-IA:10 a=aQkHbQ4UPFwA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=SWvhOY04jjHxkV-upQ0A:9 a=wPNLvfGTeEIA:10
 a=UH8/iCWBfdUmbm4Ft4Vi3Q==:117
X-EN-OrigOutIP: 10.20.18.13
X-EN-IMPSID: RoVc1l0010GvDVm01oVc7X
Message-ID: <51713A25.308@yahoo.es>
Date: Fri, 19 Apr 2013 20:35:49 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg KH <greg@kroah.com>, Eric Miao <eric.y.miao@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] platform: fall-back to driver name check if there is
 no id found
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.56.193
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy, Mika,

On 8 Feb 2013, Andy Shevchenko wrote:

> Some of the platform devices rely on the name of their driver to match with. In
> the current implementation, if platform id table is needed, they have to add
> the name to the platform id table which sounds alogical. The patch adjustes the
> logic of the id table matching to make sure we will fall-back to match by the
> driver name. This will make it similar to the DT or ACPI cases.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@xxxxxxxxxxxxxxx>
> Reported-by: Mika Westerberg <mika.westerberg@xxxxxxxxxxxxxxx>
> Cc: Eric Miao <eric.miao@xxxxxxxxxxx>
> Cc: Greg Kroah-Hartman <gregkh@xxxxxxx>
> ---
>  drivers/base/platform.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index c0b8df3..452ba4b 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -732,8 +732,8 @@ static int platform_match(struct device *dev, struct device_driver *drv)
>  		return 1;
>  
>  	/* Then try to match against the id table */
> -	if (pdrv->id_table)
> -		return platform_match_id(pdrv->id_table, pdev) != NULL;
> +	if (pdrv->id_table && platform_match_id(pdrv->id_table, pdev))
> +		return 1;
>  
>  	/* fall-back to driver name match */
>  	return (strcmp(pdev->name, drv->name) == 0);

When I upgraded an avr32 system from 3.8 to a recent next release, I found it was
broken: DMA was not available because the dw_dma driver did not get probed anymore.

The dw_dma driver does have a id_table, but the boards in arch/avr32 are still expecting
driver identification by name.

As long as we want to support this simple identification-by-name, I'd say Andy's patch
should get quickly into stable release.


Hein
