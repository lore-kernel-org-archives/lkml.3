Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab3HZVnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 17:43:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab3HZVno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 17:43:44 -0400
Date: Mon, 26 Aug 2013 11:55:03 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [3.10][PATCH 4/4] mei: me: fix hardware reset flow
Message-ID: <20130826185503.GB15992@kroah.com>
References: <1377424189-5508-1-git-send-email-tomas.winkler@intel.com>
 <1377424189-5508-5-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377424189-5508-5-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 12:49:49PM +0300, Tomas Winkler wrote:
> stable: 3.10
> commit ff96066e3171acdea356b331163495957cb833d0 char-misc

Sorry, but I have to wait until the patch hits Linus's tree before I can
accept it into a stable tree, you know that :(

> Both H_IS and H_IE needs to be set to receive H_RDY
> interrupt
> 
> 1. Assert H_IS to clear the interrupts during hw reset
> and use mei_me_reg_write instead of mei_hcsr_set as the later
> strips down the H_IS
> 
> 2. fix interrupt disablement embarrassing typo
>   hcsr |= ~H_IE -> hcsr &= ~H_IE;
> this will remove the unwanted interrupt on power down
> 
> 3. remove useless debug print outs
> 
> Cc: stable@vger.kernel.org
> Cc: Shuah Khan <shuah.kh@samsung.com>
> Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Conflicts:
> 	drivers/misc/mei/hw-me.c

What's this for?

I'll wait for this to hit Linus's tree during the 3.12-rc1 merge window
and then add it to the 3.10-stable tree, ok?

thanks,

greg k-h
