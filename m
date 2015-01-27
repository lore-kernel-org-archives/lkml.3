Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbbA0PYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:24:21 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:54147 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbbA0PYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:24:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        devicetree@vger.kernel.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Ola Jeppson <ola@adapteva.com>, linux-usb@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: Re: [PATCH] usb: phy-generic: Don't fail on missing gpio reset
Date: Tue, 27 Jan 2015 16:24:10 +0100
Message-ID: <1488241.JRB4nxvr9q@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1422323129-20969-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1422323129-20969-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:XKtCaLJjwuezDXstTnPEpEBAsy4Z/DSEmTc1uR8E4RVar334zlr
 xCUpEBLz20YxXdH+xj/6gZ1a9QuwrZn+6oOoISj7Kkiz3g6U3CuLVkwXkDde5SP78DGSNTo
 /hIUR+s9ZDaZCw7Mn9E44UcOM4zWWQI4yP0Pvg5E4AGHJzpHPY4p5pa3SC/DPe2dH5bAjIL
 IV5Kcnp2n2qRAWUmqirqg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 January 2015 17:45:29 Soren Brinkmann wrote:
> diff --git a/drivers/usb/phy/phy-generic.c b/drivers/usb/phy/phy-generic.c
> index dd05254241fb..a73d4c738f0b 100644
> --- a/drivers/usb/phy/phy-generic.c
> +++ b/drivers/usb/phy/phy-generic.c
> @@ -241,10 +241,8 @@ int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_generic *nop,
>  
>         if (err == -EPROBE_DEFER)
>                 return -EPROBE_DEFER;
> -       if (err) {
> -               dev_err(dev, "Error requesting RESET GPIO\n");
> -               return err;
> -       }
> +       if (err)
> +               nop->gpiod_reset = NULL;

You might want to distinguish between a missing property and a
reset gpio that was specified but for some reason cannot be used.

	Arnd
