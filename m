Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbaGZKXK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 06:23:10 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46080 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803AbaGZKXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 06:23:08 -0400
X-Sasl-enc: +516mcRDyxSDIFFhZzf0vW1yFUbRdWCkgY2wtIbY2orM 1406370187
Message-ID: <53D3818A.1060401@imap.cc>
Date: Sat, 26 Jul 2014 12:23:06 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>, Hansjoerg Lipp <hjlipp@web.de>
CC: Karsten Keil <isdn@linux-pingi.de>,
        gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] isdn/bas_gigaset: fix a leak on failure path in gigaset_probe()
References: <1406327671-28271-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1406327671-28271-1-git-send-email-khoroshilov@ispras.ru>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.07.2014 00:34, schrieb Alexey Khoroshilov:
> There is a lack of usb_put_dev(udev) on failure path in gigaset_probe().

You're right. Good catch.

> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Tilman Schmidt <tilman@imap.cc>

> ---
>  drivers/isdn/gigaset/bas-gigaset.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
> index c44950d3eb7b..b7ae0a0dd5b6 100644
> --- a/drivers/isdn/gigaset/bas-gigaset.c
> +++ b/drivers/isdn/gigaset/bas-gigaset.c
> @@ -2400,6 +2400,7 @@ allocerr:
>  error:
>  	freeurbs(cs);
>  	usb_set_intfdata(interface, NULL);
> +	usb_put_dev(udev);
>  	gigaset_freecs(cs);
>  	return rc;
>  }
> 

-- 
Tilman Schmidt                              E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
