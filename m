Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbaBUM75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:59:57 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:50591 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932518AbaBUM7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:59:55 -0500
Message-ID: <53074DC6.8070801@epfl.ch>
Date: Fri, 21 Feb 2014 13:59:50 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
CC: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3.11 032/121] pinctrl: do not init debugfs entries for
 unimplemented functionalities
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com> <1392986945-9693-33-git-send-email-luis.henriques@canonical.com>
In-Reply-To: <1392986945-9693-33-git-send-email-luis.henriques@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/21/2014 01:47 PM, Luis Henriques wrote:
> 3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.
> 

This was nack'ed by Greg KH a few days ago. Please see [1].

Regards,
Florian

[1] http://www.spinics.net/lists/stable/msg35959.html

> ------------------
> 
> From: Florian Vaussard <florian.vaussard@epfl.ch>
> 
> commit e7f2a444891cb39f11d5429467d0fd7e011fe7fe upstream.
> 
> Commit c420619 "pinctrl: pinconf: remove checks on ops->pin_config_get"
> removed the check on (ops != NULL) when performing pinconf_pins_show() or
> pinconf_groups_show(). As these entries are always enabled, even if
> pinconf is not supported, reading will result in an oops due to NULL
> ops.
> 
> Instead of checking for ops, remove the corresponding debugfs entries if
> pinconf and/or pinmux are not implemented.
> 
> Tested on OMAP3 (pinctrl-single).
> 
> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>  drivers/pinctrl/core.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
> index dbcf284..dec5787 100644
> --- a/drivers/pinctrl/core.c
> +++ b/drivers/pinctrl/core.c
> @@ -1621,8 +1621,10 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
>  			    device_root, pctldev, &pinctrl_groups_ops);
>  	debugfs_create_file("gpio-ranges", S_IFREG | S_IRUGO,
>  			    device_root, pctldev, &pinctrl_gpioranges_ops);
> -	pinmux_init_device_debugfs(device_root, pctldev);
> -	pinconf_init_device_debugfs(device_root, pctldev);
> +	if (pctldev->desc->pmxops)
> +		pinmux_init_device_debugfs(device_root, pctldev);
> +	if (pctldev->desc->confops)
> +		pinconf_init_device_debugfs(device_root, pctldev);
>  }
>  
>  static void pinctrl_remove_device_debugfs(struct pinctrl_dev *pctldev)
> 
