Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaIAWFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 18:05:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38768 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaIAWE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 18:04:59 -0400
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Sep 2014 18:04:58 EDT
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 1 Sep 2014 23:56:05 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Sander Nemvalts <snemvalts@gmail.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers:firewire: fix style errors in core-card.c This
 is a patch in the core-card.c file which fixes up 2 warnings found by the
 checkpatch.pl tool Signed-off-by: Sander Nemvalts <snemvalts@gmail.com>
Message-ID: <20140901235605.5466b6a6@kant>
In-Reply-To: <1409597306-22164-1-git-send-email-snemvalts@gmail.com>
References: <1409597306-22164-1-git-send-email-snemvalts@gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 01 Sander Nemvalts wrote:
> --- a/drivers/firewire/core-card.c
> +++ b/drivers/firewire/core-card.c
> @@ -89,7 +89,8 @@ static size_t config_rom_length = 1 + 4 + 1 + 1;
>  #define BIB_ISC			((1) << 29)
>  #define BIB_CMC			((1) << 30)
>  #define BIB_IRMC		((1) << 31)
> -#define NODE_CAPABILITIES	0x0c0083c0 /* per IEEE 1394 clause 8.3.2.6.5.2 */
> +/* per IEEE 1394 clause 8.3.2.6.5.2 */
> +#define NODE_CAPABILITIES	0x0c0083c0

This is no improvement.

>  /*
>   * IEEE-1394 specifies a default SPLIT_TIMEOUT value of 800 cycles (100 ms),
> @@ -132,7 +133,7 @@ static void generate_config_rom(struct fw_card *card, __be32 *config_rom)
>  	j = 7 + descriptor_count;
>  
>  	/* Generate root directory entries for descriptors. */
> -	list_for_each_entry (desc, &descriptor_list, link) {
> +	list_for_each_entry(desc, &descriptor_list, link) {
>  		if (desc->immediate > 0)
>  			config_rom[i++] = cpu_to_be32(desc->immediate);
>  		config_rom[i] = cpu_to_be32(desc->key | (j - i));

We are writing
	for (a; b; c);
not
	for(a; b; c);
and thus a space after list_for_each and friends makes sense.
-- 
Stefan Richter
-=====-====- =--= ----=
http://arcgraph.de/sr/
