Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbaKJTW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:22:27 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47042 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaKJTW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:22:26 -0500
Date: Mon, 10 Nov 2014 14:22:23 -0500 (EST)
Message-Id: <20141110.142223.816257623301941276.davem@davemloft.net>
To: sudipm.mukherjee@gmail.com
Cc: steve.glendinning@shawell.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbnet: smsc95xx: dereferencing NULL pointer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415366560-27614-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1415366560-27614-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Nov 2014 11:22:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAAJMYJs031315

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Fri,  7 Nov 2014 18:52:40 +0530

> we were dereferencing dev to initialize pdata. but just after that we
> have a BUG_ON(!dev). so we were basically dereferencing the pointer
> first and then tesing it for NULL.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

You didn't even compile test this.

Do not even bother fixing theoretical issues if you're going to be
introducing a _REAL_ serious regression into the code with your "fix":

drivers/net/usb/smsc95xx.c: In function ¡smsc95xx_resume¢:
drivers/net/usb/smsc95xx.c:1674:5: warning: ¡pdata¢ is used uninitialized in this function [-Wuninitialized]
  u8 suspend_flags = pdata->suspend_flags;
     ^

So, instead of a theoretical issue, we now have a real guaranteed
crash.

You did not compile test this change, and you definitely did not
functionally test this change either.

Please do not do this ever again, thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
