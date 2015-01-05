Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbbAEONW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:13:22 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:54937 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbAEONT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:13:19 -0500
MIME-Version: 1.0
In-Reply-To: <1419416190-4321-1-git-send-email-vinceh@nvidia.com>
References: <1419416190-4321-1-git-send-email-vinceh@nvidia.com>
From: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Date: Mon, 5 Jan 2015 15:12:58 +0100
X-Google-Sender-Auth: Qx8NRxFuN6QhVm6l7n3cSmPxylE
Message-ID: <CAAObsKDYSVp_W5Qz_43Lyd=nqfQJPw=ttN1-7ENRX19n79gHnA@mail.gmail.com>
Subject: Re: [PATCH] usb: host: ehci-tegra: request deferred probe when
 failing to get phy
To: Vince Hsu <vinceh@nvidia.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 December 2014 at 11:16, Vince Hsu <vinceh@nvidia.com> wrote:
> The commit 1290a958d48e ("usb: phy: propagate __of_usb_find_phy()'s error on
> failure") changed the condition to return -EPROBE_DEFER to host driver.
> Originally the Tegra host driver depended on the returned -EPROBE_DEFER to
> get the phy device later when booting. Now we have to do that explicitly.

With this patch, USB works again on this nyan-blaze board.

Tested-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

Thanks,

Tomeu

> Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> ---
> Hi,
>
> This fixes a regression found on 3.19-rc1. The USB host can't be probed and
> the USB failed on Jetson TK1.
>
> Thanks,
> Vince
>
>
>  drivers/usb/host/ehci-tegra.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 19a9af1b4d74..ff9af29b4e9f 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -451,7 +451,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
>
>         u_phy = devm_usb_get_phy_by_phandle(&pdev->dev, "nvidia,phy", 0);
>         if (IS_ERR(u_phy)) {
> -               err = PTR_ERR(u_phy);
> +               err = -EPROBE_DEFER;
>                 goto cleanup_clk_en;
>         }
>         hcd->usb_phy = u_phy;
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
