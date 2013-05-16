Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab3EPOqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:46:49 -0400
Received: from nbd.name ([46.4.11.11]:51826 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab3EPOqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:46:48 -0400
Message-ID: <5194F03D.3080709@phrozen.org>
Date: Thu, 16 May 2013 16:42:05 +0200
From: John Crispin <john@phrozen.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 31/33] arch/mips/lantiq/xway: don't check resource with
 devm_ioremap_resource
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de> <1368702961-4325-32-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1368702961-4325-32-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/05/13 13:15, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang<wsa@the-dreams.de>

Acked-by: John Crispin <blogic@openwrt.org>





> ---
>   arch/mips/lantiq/xway/gptu.c |    4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/arch/mips/lantiq/xway/gptu.c b/arch/mips/lantiq/xway/gptu.c
> index 9861c86..d6a79b8 100644
> --- a/arch/mips/lantiq/xway/gptu.c
> +++ b/arch/mips/lantiq/xway/gptu.c
> @@ -144,10 +144,6 @@ static int gptu_probe(struct platform_device *pdev)
>   	}
>
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Failed to get resource\n");
> -		return -ENOMEM;
> -	}
>
>   	/* remap gptu register range */
>   	gptu_membase = devm_ioremap_resource(&pdev->dev, res);

