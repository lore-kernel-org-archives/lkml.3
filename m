Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab3EJJCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:02:22 -0400
Received: from nbd.name ([46.4.11.11]:54097 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab3EJJCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:02:21 -0400
Message-ID: <518CB681.4030709@phrozen.org>
Date: Fri, 10 May 2013 10:57:37 +0200
From: John Crispin <john@phrozen.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org
Subject: Re: [RFC 40/42] arch/mips/lantiq/xway: don't check resource with
 devm_ioremap_resource
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de> <1368173847-5661-41-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1368173847-5661-41-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/13 10:17, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang<wsa@the-dreams.de>

Acked-by: John Crispin <blogic@openwrt.org>

> ---
>   arch/mips/lantiq/xway/gptu.c |    7 +------
>   1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/arch/mips/lantiq/xway/gptu.c b/arch/mips/lantiq/xway/gptu.c
> index 9861c86..26226f0 100644
> --- a/arch/mips/lantiq/xway/gptu.c
> +++ b/arch/mips/lantiq/xway/gptu.c
> @@ -143,13 +143,8 @@ static int gptu_probe(struct platform_device *pdev)
>   		return -EINVAL;
>   	}
>
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (!res) {
> -		dev_err(&pdev->dev, "Failed to get resource\n");
> -		return -ENOMEM;
> -	}
> -
>   	/* remap gptu register range */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>   	gptu_membase = devm_ioremap_resource(&pdev->dev, res);
>   	if (IS_ERR(gptu_membase))
>   		return PTR_ERR(gptu_membase);

