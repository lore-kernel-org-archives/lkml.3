Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaK1XQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 18:16:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52912 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaK1XP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 18:15:59 -0500
Date: Sat, 29 Nov 2014 00:15:55 +0100
From: Borislav Petkov <bp@alien8.de>
To: Giedrius Statkevicius <giedriuswork@gmail.com>
Cc: dvhart@infradead.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform: x86: hp_wireless: Inform the user if
 hp_wireless_input_setup()/add() fails
Message-ID: <20141128231555.GA31468@pd.tnic>
References: <1417212867-25187-1-git-send-email-giedriuswork@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1417212867-25187-1-git-send-email-giedriuswork@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 12:14:27AM +0200, Giedrius Statkevicius wrote:
> In hpwl_add() there is a unused variable err to which we assign the
> result of hp_wireless_input_setup() but we don't do anything depending
> on the result so print out a message that informs the user if add()
> (hp_wireless_input_setup()) fails since acpi_device_probe() doesn't
> print anything in this case.
> 
> Signed-off-by: Giedrius Statkevicius <giedriuswork@gmail.com>
> ---
>  drivers/platform/x86/hp-wireless.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/platform/x86/hp-wireless.c b/drivers/platform/x86/hp-wireless.c
> index 415348f..4e4cc8b 100644
> --- a/drivers/platform/x86/hp-wireless.c
> +++ b/drivers/platform/x86/hp-wireless.c
> @@ -85,6 +85,9 @@ static int hpwl_add(struct acpi_device *device)
>  	int err;
>  
>  	err = hp_wireless_input_setup();
> +	if (err)
> +		pr_err("Failed to setup hp wireless hotkeys\n");
> +

I don't think there's need for that. Just do:

	return hp_wireless_input_setup();

and drop err completely.

The upper layer which calls the ->add() method should propagate the
error properly.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
