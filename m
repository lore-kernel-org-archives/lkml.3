Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaAEVuw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 16:50:52 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59260 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751371AbaAEVuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 16:50:51 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Levente Kurusa <levex@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 25/38] pnp: card: add missing put_device call
Date: Sun, 05 Jan 2014 23:04:36 +0100
Message-ID: <3229394.V2cHUip126@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc6+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1387465429-3568-26-git-send-email-levex@linux.com>
References: <1387465429-3568-2-git-send-email-levex@linux.com> <1387465429-3568-26-git-send-email-levex@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 19, 2013 04:03:36 PM Levente Kurusa wrote:
> This is required so that we give up the last reference to the device.
> 
> Signed-off-by: Levente Kurusa <levex@linux.com>

Queued up for 3.14, thanks!

> ---
>  drivers/pnp/card.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/pnp/card.c b/drivers/pnp/card.c
> index bc00693..874c236 100644
> --- a/drivers/pnp/card.c
> +++ b/drivers/pnp/card.c
> @@ -239,6 +239,7 @@ int pnp_add_card(struct pnp_card *card)
>  	error = device_register(&card->dev);
>  	if (error) {
>  		dev_err(&card->dev, "could not register (err=%d)\n", error);
> +		put_device(&card->dev);
>  		return error;
>  	}
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
