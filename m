Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030218AbaDJKrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:47:03 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38617 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965939AbaDJKrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:47:01 -0400
Date: Thu, 10 Apr 2014 11:46:48 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Michael Welling <mwelling@ieee.org>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, jslaby@suse.cz
Subject: Re: [PATCH 1/2] tty serial: xr17c15x driver
Message-ID: <20140410114648.68bfbf61@alan.etchedpixels.co.uk>
In-Reply-To: <20140410041035.GA26578@deathray>
References: <1397102671-26536-1-git-send-email-mwelling@ieee.org>
	<20140410041035.GA26578@deathray>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2014 23:10:35 -0500
Michael Welling <mwelling@ieee.org> wrote:

> The 8250_core driver is supposed to support these devices but it has
> soft lockups on some hardware. This driver was ported from the vendors
> 2.6.37 driver and has been proven to work.
> 
> I do not expect it to be merged, I am looking for feedback and
> possible fixes.

The thing to do is going to be to compare the various methods in the
driver with the 8250.c driver.

It appeas to be based upon an ancient 8250.c so if you want to pick up
all the changes then you need to compare with 8250.c, and if you want to
fix 8250.c instead you need to do exactly the same job so that seems a
more productive way to go about it IMHO.

There are bits of the driver you've pasted like the loop over ports for
shared IRQs you can't fix however, because they assume there is one
driver for all the ports. Not sure it matters though given your devices
are all going to be PCI bus.

Other thing to do would be to instrument serial_in/out and run the two
drivers briefly and compare the sequence of accesses and settings used.

Alan
