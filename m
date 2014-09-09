Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbaIIM56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 08:57:58 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57692 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751192AbaIIM54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 08:57:56 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI / platform / LPSS: disable async suspend/resume of LPSS devices
Date: Tue, 09 Sep 2014 15:17:23 +0200
Message-ID: <74255682.ogZlaWiZ0J@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <540E91F0.2060306@linux.intel.com>
References: <540E91F0.2060306@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 09, 2014 01:36:48 PM Fu, Zhonghui wrote:
> From 6deb00230f5df68da3ca7490402a0c537bf386bb Mon Sep 17 00:00:00 2001
> From: Fu Zhonghui <zhonghui.fu@linux.intel.com>
> Date: Tue, 9 Sep 2014 13:02:25 +0800
> Subject: [PATCH] ACPI / platform / LPSS: disable async suspend/resume of LPSS devices
> 
> LPSS devices must suspend/resume in fixed order. Or some LPSS devices
> will hang during the transition to ACPI_STATE_D0 state.
> 
> Signed-off-by: Li Aubrey <aubrey.li@linux.intel.com>
> Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
> ---
>  drivers/acpi/acpi_lpss.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index fddc1e8..54e5c97 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -419,7 +419,7 @@ static int acpi_lpss_create_device(struct acpi_device *adev,
>  	adev->driver_data = pdata;
>  	pdev = acpi_create_platform_device(adev);
>  	if (!IS_ERR_OR_NULL(pdev)) {
> -		device_enable_async_suspend(&pdev->dev);
> +		device_disable_async_suspend(&pdev->dev);

Removing the "enable" line should be sufficient for that.  Isn't it?

>  		return 1;
>  	}
>  
> -- 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
