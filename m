Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3A1PFA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:05:00 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:60230 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab3A1PE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:04:57 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtVHAKWSBlFV5qjOPGdsb2JhbABEin6zWhcDAQEBATg0gh4BAQQBOhwjBQsIAyElDwUNGAoaE4d/AwkKtgcNiVUVi3uENGEDlDeBVYV7hTyICg
X-IronPort-AV: E=Sophos;i="4.84,552,1355094000"; 
   d="scan'208";a="194536323"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 28 Jan 2013 16:10:10 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/25] HID: multitouch: optimize FlatFrog panels
Message-ID: <20130128151010.GA3470@polaris.bitmath.org>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
 <1359120190-18281-7-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359120190-18281-7-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> Relying on ALWAYS_VALID enhance a little the processing time of
> the events.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Is there a measurement backing up this claim? I suspect
micro-optimizations of this kind drowns completely along the rather
long way from device, via malloc and loops, to the input core.
Considering the must-be-tested-for-regression risk on top of that,
this patch falls far below what is worth doing, IMHO.

> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 5a886bd..7dfe891 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -229,8 +229,9 @@ static struct mt_class mt_classes[] = {
>  	},
>  
>  	{ .name = MT_CLS_FLATFROG,
> -		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
> -			MT_QUIRK_NO_AREA,
> +		.quirks = MT_QUIRK_ALWAYS_VALID |
> +			MT_QUIRK_NO_AREA |
> +			MT_QUIRK_CONTACT_CNT_ACCURATE,
>  		.sn_move = 2048,
>  		.maxcontacts = 40,
>  	},
> -- 
> 1.8.1
> 

Thanks.
Henrik
