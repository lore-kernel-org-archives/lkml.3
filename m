Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaGAGjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 02:39:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55660 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbaGAGjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 02:39:11 -0400
Date: Tue, 1 Jul 2014 08:39:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Nicholas Krause <xerofoify@gmail.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hid-appleir: Fix kernel panic due to null pointer
In-Reply-To: <1404180865-3681-1-git-send-email-xerofoify@gmail.com>
Message-ID: <alpine.LNX.2.00.1407010837370.1655@pobox.suse.cz>
References: <1404180865-3681-1-git-send-email-xerofoify@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014, Nicholas Krause wrote:

> Fixes a null pointer in appleir_input_configured due to reading
> into wrong size array. Changed the variable to input_dev->keycodemax.

This is a stale changelog from the previous buggy version.

> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/hid/hid-appleir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-appleir.c b/drivers/hid/hid-appleir.c
> index 0e6a42d..cc02df4 100644
> --- a/drivers/hid/hid-appleir.c
> +++ b/drivers/hid/hid-appleir.c
> @@ -272,7 +272,7 @@ static void appleir_input_configured(struct hid_device *hid,
>  	input_dev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
>  
>  	memcpy(appleir->keymap, appleir_key_table, sizeof(appleir->keymap));
> -	for (i = 0; i < ARRAY_SIZE(appleir_key_table); i++)
> +	for (i = 0; i < appleir->keymap; i++)

This is wrong. appleir->keymap is an array, and you want to count its 
elements.

Third time is the charm perhaps?

-- 
Jiri Kosina
SUSE Labs
