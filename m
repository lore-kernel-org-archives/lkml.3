Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbbALSwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:52:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbbALSwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:52:18 -0500
Date: Mon, 12 Jan 2015 10:52:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB fixes for v3.19-rc5
Message-ID: <20150112185217.GA11506@kroah.com>
References: <1421086040-28464-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421086040-28464-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:07:20PM -0600, Felipe Balbi wrote:
> Hi Greg,
> 
> Looks like this will be my last pull request for v3.19. Please consider merging
> on top of your usb-linus branch.
> 
> Note that there will be a conflict when merging on that branch, the solution is
> to use the version from my tree as that's more correct. Here's how the related
> code should look like:
> 
> devm_usb_ge_phy_by_phandle():
> 
> [ ... ]
> 
> 195         phy = __of_usb_find_phy(node);
> 196         if (IS_ERR(phy)) {
> 197                 devres_free(ptr);
> 198                 goto err1;
> 199         }
> 200 
> 201         if (!try_module_get(phy->dev->driver->owner)) {
> 202                 phy = ERR_PTR(-ENODEV);
> 203                 devres_free(ptr);
> 204                 goto err1;
> 205         }
> 
> [ ... ]
> 
> cheers
> 
> The following changes since commit 6785a1034461c2d2c205215f63a50a740896e55b:
> 
>   usb: gadget: udc: atmel: fix possible IN hang issue (2014-12-22 10:41:15 -0600)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.19-rc5

Pulled and pushed out.

thanks,

greg k-h
