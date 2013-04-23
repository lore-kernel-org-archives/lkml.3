Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab3DWRRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 13:17:38 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:40010 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab3DWRRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 13:17:36 -0400
Date: Tue, 23 Apr 2013 10:17:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 19/21] usb: phy: don't mark usb_bind_phy as __init
Message-ID: <20130423171734.GA31432@kroah.com>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
 <1366734653-488286-20-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366734653-488286-20-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 06:30:51PM +0200, Arnd Bergmann wrote:
> It makes no sense for a symbol to be both exported and marked __init,
> because any users in modules would be calling this function after
> it gets discarded. Further, this patch revolves a section mismatch
> warning from usbhs_init_phys(), which is intentionally not marked
> __init:
> 
> WARNING: vmlinux.o(.text+0x413f8): Section mismatch in reference from
> the function usbhs_init_phys() to the function .init.text:usb_bind_phy()
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> ---
>  drivers/usb/otg/otg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

What tree has this file?  It's not mine :(

