Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab3FAS3Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 14:29:16 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49906 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752629Ab3FAS3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 14:29:11 -0400
Message-ID: <1370111350.2098.1.camel@joe-AO722>
Subject: Re: [PATCH] usb: musb: use the new %pa format specifier for
 dma_addr_t
From: Joe Perches <joe@perches.com>
To: Emil Goode <emilgoode@gmail.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sat, 01 Jun 2013 11:29:10 -0700
In-Reply-To: <1370109747-18821-1-git-send-email-emilgoode@gmail.com>
References: <1370109747-18821-1-git-send-email-emilgoode@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-01 at 20:02 +0200, Emil Goode wrote:
> This patch makes use of the new format specifier %pa that was introduced
> by the following commit.
> 
> 7d7992108d02aa92ad4c77e5d9ce14088c942e75
> ("lib/vsprintf.c: add %pa format specifier for phys_addr_t types")
[]
> diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
[]
> @@ -1756,12 +1756,11 @@ void musb_host_rx(struct musb *musb, u8 epnum)
[]
> -			dev_dbg(musb->controller, "RX%d count %d, buffer 0x%llx len %d/%d\n",
> +			dev_dbg(musb->controller, "RX%d count %d, buffer 0x%pa len %d/%d\n",

This would emit 0x0x<addr>

When you use %pa, don't add 0x


