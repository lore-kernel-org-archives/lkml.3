Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab3GYAtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 20:49:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37087 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab3GYAtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 20:49:51 -0400
Date: Wed, 24 Jul 2013 17:49:47 -0700 (PDT)
Message-Id: <20130724.174947.452272360732442554.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/3] net/usb/r815x: replace USB buffer from stack to
 DMA-able
From: David Miller <davem@davemloft.net>
In-Reply-To: <D7C722C73C7A400780358D0376412267@realtek.com.tw>
References: <D7C722C73C7A400780358D0376412267@realtek.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 24 Jul 2013 17:49:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: hayeswang <hayeswang@realtek.com>
Date: Tue, 23 Jul 2013 17:26:04 +0800

> diff --git a/drivers/net/usb/r815x.c b/drivers/net/usb/r815x.c
> index 8523922..e9b99ba 100644
> --- a/drivers/net/usb/r815x.c
> +++ b/drivers/net/usb/r815x.c
> @@ -24,34 +24,43 @@
>  
>  static int pla_read_word(struct usb_device *udev, u16 index)
>  {
> - int data, ret;
> + int ret;
>   u8 shift = index & 2;
> - __le32 ocp_data;
> + __le32 *tmp;

Your email client has corrupted these patches.
