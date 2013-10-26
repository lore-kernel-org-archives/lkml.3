Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3JZRft (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 13:35:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab3JZRfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 13:35:47 -0400
Date: Sat, 26 Oct 2013 18:37:30 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: usbatm: printk_ratelimit() always called in the atm_rldbg()
Message-ID: <20131026173730.GA18320@kroah.com>
References: <20131026132955.GA9251@shrek.podlesie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131026132955.GA9251@shrek.podlesie.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 03:29:56PM +0200, Krzysztof Mazur wrote:
> Hi,
> 
> commit 2d6401cf4ca3861692a4779745e0049cac769d10
> ("USB: usbatm: move the atm_dbg() call to use dynamic debug")
> changed the atm_rldbg() to:
> 
> #define atm_rldbg(instance, format, arg...)		\
> 	if (printk_ratelimit())				\
> 		atm_dbg(instance , format , ## arg)
> 
> and now printk_ratelimit() is always called even when debugging is
> disabled and a lot of "callbacks suppressed" messages are printed
> by the printk_ratelimit():
> 
> [...]
> usbatm_rx_process: 4977 callbacks suppressed
> usbatm_extract_one_cell: 2920 callbacks suppressed
> [...]
> 
> 
> I'm not sure how to fix that, maybe we need dynamic_pr_debug_ratelimit()?

How about just deleting the use of that macro entirely?  Odds are it's
not really needed anymore, right?

thanks,

greg k-h
