Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbaI3TcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:32:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbaI3TcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:32:03 -0400
Date: Tue, 30 Sep 2014 12:32:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Einon <mark.einon@gmail.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org
Subject: Re: [PATCH] et131x: Promote staging et131x driver to drivers/net
Message-ID: <20140930193201.GA2349@kroah.com>
References: <1412104572-2931-1-git-send-email-mark.einon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412104572-2931-1-git-send-email-mark.einon@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 08:16:12PM +0100, Mark Einon wrote:
> This patch moves the et131x gigabit ethernet driver from drivers/staging
> to drivers/net/ethernet/agere.
> 
> Signed-off-by: Mark Einon <mark.einon@gmail.com>
> ---
> 
> This patch appiles to both staging-next and the linux-next tag next-20140930,
> and takes into account all feedback recieved from the recent RFC for this
> patch.
> 
>  MAINTAINERS                                        | 10 +++----
>  drivers/net/ethernet/Kconfig                       |  1 +
>  drivers/net/ethernet/Makefile                      |  1 +
>  drivers/net/ethernet/agere/Kconfig                 | 31 ++++++++++++++++++++++
>  .../et131x => net/ethernet/agere}/Makefile         |  0
>  .../et131x => net/ethernet/agere}/et131x.c         |  0
>  .../et131x => net/ethernet/agere}/et131x.h         |  0
>  drivers/staging/Kconfig                            |  2 --
>  drivers/staging/Makefile                           |  1 -
>  drivers/staging/et131x/Kconfig                     | 10 -------
>  drivers/staging/et131x/README                      | 15 -----------
>  11 files changed, 38 insertions(+), 33 deletions(-)
>  create mode 100644 drivers/net/ethernet/agere/Kconfig
>  rename drivers/{staging/et131x => net/ethernet/agere}/Makefile (100%)
>  rename drivers/{staging/et131x => net/ethernet/agere}/et131x.c (100%)
>  rename drivers/{staging/et131x => net/ethernet/agere}/et131x.h (100%)
>  delete mode 100644 drivers/staging/et131x/Kconfig
>  delete mode 100644 drivers/staging/et131x/README

This is a fine way to make a patch, but it's no way that any of the
netdev developers could ever review it to know what the code happens to
look like in my staging-next branch :(

How about just sending a patch that adds the driver to drivers/net/...
Don't worry about the staging driver at the moment.  If it gets added to
drivers/net we can then delete the staging driver.

Sound easier?  Should make the patches half as big.

thanks,

greg k-h
