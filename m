Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaF3OiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:38:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbaF3OiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:38:07 -0400
Date: Mon, 30 Jun 2014 16:38:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Nicholas Krause <xerofoify@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixes kernel panic with Null pointer in hid-appleir.c
In-Reply-To: <1403281515-5508-1-git-send-email-xerofoify@gmail.com>
Message-ID: <alpine.LNX.2.00.1406301636100.28307@pobox.suse.cz>
References: <1403281515-5508-1-git-send-email-xerofoify@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014, Nicholas Krause wrote:

> In for loop of function appleir_input_configured we hit
> a Null pointer after the for loop due to array_size not
> being correct needs to be changed to input_dev->keycodemax.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/hid/hid-appleir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-appleir.c b/drivers/hid/hid-appleir.c
> index 0e6a42d..ab0a702 100644
> --- a/drivers/hid/hid-appleir.c
> +++ b/drivers/hid/hid-appleir.c
> @@ -272,7 +272,7 @@ static void appleir_input_configured(struct hid_device *hid,
>  	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
>  
>  	memcpy(appleir->keymap, appleir_key_table, sizeof(appleir->keymap));
> -	for (i = 0; i < ARRAY_SIZE(appleir_key_table); i++)
> +	for (i = 0; i < ARRAY_SIZE(input_dev->keycodemax); i++)

Ugh, how is this supposed to work? input_dev->keycodemax is int, not 
array. I think you actually want sizeof(appleir->keymap) there.

-- 
Jiri Kosina
SUSE Labs
