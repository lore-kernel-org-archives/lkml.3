Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab3A0Ty5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 14:54:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:36138 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876Ab3A0Tyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 14:54:54 -0500
Date: Sun, 27 Jan 2013 11:56:38 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: zbr@ioremap.net, panto@antoniou-consulting.com,
        LKML <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: section mismatch in drivers/w1/masters/w1-gpio.c
Message-ID: <20130127195638.GA5005@kroah.com>
References: <510581A0.2080801@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510581A0.2080801@hauke-m.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 08:36:00PM +0100, Hauke Mehrtens wrote:
> Hi,
> 
> when building 3.8-rc5 I get the following section mismatch:
> 
> WARNING: drivers/w1/masters/w1-gpio.o(.data+0x188): Section mismatch in
> reference from the variable w1_gpio_driver to the function
> .init.text:w1_gpio_probe()
> The variable w1_gpio_driver references
> the function __init w1_gpio_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> 
> 
> The __init in front of w1_gpio_probe() should be removed.

Great, care to send a patch doing just that so I can apply it?

thanks,

greg k-h
