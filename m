Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab3DVRQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 13:16:55 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40220 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3DVRQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 13:16:53 -0400
Message-ID: <51757080.3070203@samsung.com>
Date: Tue, 23 Apr 2013 02:16:48 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH v2] usb: ehci-s5p: fix: Fix null pointer dereferencing
References: <CAFp+6iE1Ei=B7+XfZghVivwQ5zdbCnuG+F=qdLX3P19Xo9QdYg@mail.gmail.com> <1365513131-27691-1-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1365513131-27691-1-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/13 22:12, Vivek Gautam wrote:
> 7edb3da: (USB: EHCI: make ehci-s5p a separate driver)
> raised an issue with ehci-s5p's driver data.
> Now that 's5p_ehci_hcd' doesn't maintain pointer to 'usb_hcd'
> and s5p_ehci is nothing but a pointer to hcd->priv;
> add hcd to the driver data rather than s5p_ehci.
>
> This fixes issues with null pointer dereferencing in
> s5p_ehci_shutdown(), s5p_ehci_suspend(), s5p_ehci_resume().
>
> Signed-off-by: Vivek Gautam<gautam.vivek@samsung.com>
> CC: Manjunath Goudar<manjunath.goudar@linaro.org>
> CC: Arnd Bergmann<arnd@arndb.de>
> CC: Jingoo Han<jg1.han@samsung.com>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin

> ---
>
> Based on 'usb-next'
>
>   drivers/usb/host/ehci-s5p.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> index d8cb0ca..580548a 100644
> --- a/drivers/usb/host/ehci-s5p.c
> +++ b/drivers/usb/host/ehci-s5p.c
> @@ -173,7 +173,7 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>   		goto fail_add_hcd;
>   	}
>
> -	platform_set_drvdata(pdev, s5p_ehci);
> +	platform_set_drvdata(pdev, hcd);
>
>   	return 0;
>
