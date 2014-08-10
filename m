Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaHJMLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 08:11:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHJMLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 08:11:45 -0400
Date: Sat, 9 Aug 2014 21:39:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Einon <mark.einon@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] staging: et131x: Fix errors caused by phydev->addr
 accesses before initialisation
Message-ID: <20140810043917.GA17278@kroah.com>
References: <1407279426-8021-1-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407279426-8021-1-git-send-email-mark.einon@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 11:57:06PM +0100, Mark Einon wrote:
> Fix two reported bugs, caused by et131x_adapter->phydev->addr being accessed
> before it is initialised, by:
> 
> - letting et131x_mii_write() take a phydev address, instead of using the one
>   stored in adapter by default. This is so et131x_mdio_write() can use it's own
>   addr value.
> - removing implementation of et131x_mdio_reset(), as it's not needed.
> - moving a call to et131x_disable_phy_coma() in et131x_pci_setup(), which uses
>   phydev->addr, until after the mdiobus has been registered.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=80751
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=77121
> Cc: stable@vger.kernel.org
> Signed-off-by: Mark Einon <mark.einon@gmail.com>
> ---
>  drivers/staging/et131x/et131x.c | 68 ++++++++++++++++-------------------------
>  1 file changed, 27 insertions(+), 41 deletions(-)

I got 3 copies of this patch, all look to be different?

I don't know what to do, so I've deleted them all, please resend the
version you want me to apply.

thanks,

greg k-h
