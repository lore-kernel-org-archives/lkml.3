Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3A1PUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:20:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56770 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab3A1PUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:20:37 -0500
Date: Mon, 28 Jan 2013 15:20:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Roger Quadros <rogerq@ti.com>, tony@atomide.com, sameo@linux.intel.com,
        balbi@ti.com, gregkh@linuxfoundation.org, eballetbo@gmail.com,
        javier@dowhile0.org, sshtylyov@mvista.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/30] USB: ehci-omap: Use devm_request_and_ioremap()
Message-ID: <20130128152010.GN23505@n2100.arm.linux.org.uk>
References: <1359372631-8180-10-git-send-email-rogerq@ti.com> <Pine.LNX.4.44L0.1301281013010.1997-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301281013010.1997-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 10:17:33AM -0500, Alan Stern wrote:
> On Mon, 28 Jan 2013, Roger Quadros wrote:
> 
> > Make use of devm_request_and_ioremap() and correct comment.
> 
> Didn't a big patch come through recently converting all usages of 
> devm_request_and_ioremap() to another function (I forget the name) that 
> does its own error reporting and returns an ERR_PTR value?
> 
> (Checks the mailing list archive...)  Ah, here it is:
> 
> 	http://marc.info/?l=linux-usb&m=135876311801537&w=2
> 
> And the new function is devm_ioremap_resource().  We should avoid 
> adding new usages of an old interface.

Maybe... if devm_ioremap_resource() was already in the kernel.  The
problem at the moment is it isn't, and it'll probably be rather
horrid for everyone to deal with especially when it comes to testing.
