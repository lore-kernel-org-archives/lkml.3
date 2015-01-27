Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbbA0DLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 22:11:53 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51522 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbbA0DLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 22:11:50 -0500
Date: Mon, 26 Jan 2015 19:11:46 -0800
From: Darren Hart <dvhart@infradead.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: Re: [PATCH v3 2/2] asus-laptop: cleanup is_visible
Message-ID: <20150127031146.GB3585@vmdeb7>
References: <1422021671-31861-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1422021671-31861-2-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422021671-31861-2-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 09:01:11AM -0500, Vivien Didelot wrote:
> Get rid of the "normal" label, use one if-statement per attribute for
> maintainability and change s/supported/ret/ and s/asus->handle/handle/
> to fix a coding style issue (lines with 80+ chars).
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> ---
>  drivers/platform/x86/asus-laptop.c | 61 ++++++++++++++------------------------
>  1 file changed, 22 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
> index 46b2746..37a3a1f 100644
> --- a/drivers/platform/x86/asus-laptop.c
> +++ b/drivers/platform/x86/asus-laptop.c
> @@ -1602,55 +1602,38 @@ static umode_t asus_sysfs_is_visible(struct kobject *kobj,
>  	struct platform_device *pdev = to_platform_device(dev);
>  	struct asus_laptop *asus = platform_get_drvdata(pdev);
>  	acpi_handle handle = asus->handle;
> -	bool supported;
> +	bool ret = true;

Very odd to have ret be a bool...

>  
> -	if (asus->is_pega_lucid) {
> -		/* no ls_level interface on the Lucid */
> -		if (attr == &dev_attr_ls_switch.attr)
> -			supported = true;
> -		else if (attr == &dev_attr_ls_level.attr)
> -			supported = false;
> -		else
> -			goto normal;
> -
> -		return supported ? attr->mode : 0;
> -	}
> -
> -normal:
>  	if (attr == &dev_attr_wlan.attr) {
> -		supported = !acpi_check_handle(handle, METHOD_WLAN, NULL);
> -
> +		ret = !acpi_check_handle(handle, METHOD_WLAN, NULL);

acpi_check_handle returns an int, you should be able to just use that.
...

>  	} else if (attr == &dev_attr_ls_value.attr) {
> -		supported = asus->is_pega_lucid;
> +		ret = asus->is_pega_lucid;

This should promote to an int without a problem.
...

-- 
Darren Hart
Intel Open Source Technology Center
