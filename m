Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaKKGaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 01:30:22 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47144 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaKKGaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 01:30:20 -0500
Date: Tue, 11 Nov 2014 12:00:08 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: steve.glendinning@shawell.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usbnet: smsc95xx: dereferencing NULL pointer
Message-ID: <20141111063008.GA4446@sudip-PC>
References: <1415366560-27614-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20141110.142223.816257623301941276.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141110.142223.816257623301941276.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 02:22:23PM -0500, David Miller wrote:
> From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> Date: Fri,  7 Nov 2014 18:52:40 +0530
> 
> > we were dereferencing dev to initialize pdata. but just after that we
> > have a BUG_ON(!dev). so we were basically dereferencing the pointer
> > first and then tesing it for NULL.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> 
> You didn't even compile test this.
> 
> Do not even bother fixing theoretical issues if you're going to be
> introducing a _REAL_ serious regression into the code with your "fix":
> 
> drivers/net/usb/smsc95xx.c: In function ‘smsc95xx_resume’:
> drivers/net/usb/smsc95xx.c:1674:5: warning: ‘pdata’ is used uninitialized in this function [-Wuninitialized]
>   u8 suspend_flags = pdata->suspend_flags;
>      ^
> 
> So, instead of a theoretical issue, we now have a real guaranteed
> crash.
> 
> You did not compile test this change, and you definitely did not
> functionally test this change either.
> 
> Please do not do this ever again, thanks.

extremely sorry for this.
i have compile tested but don't know how i missed the new warning message.
for any of my patch,if for some reason i am not able to compile test it, i mention that in the comments.
sorry again.

thanks
sudip
