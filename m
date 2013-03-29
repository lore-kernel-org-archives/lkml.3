Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab3C2OF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 10:05:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48295 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755536Ab3C2OFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:05:55 -0400
Date: Fri, 29 Mar 2013 10:05:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tony Prisk <linux@prisktech.co.nz>
cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: ehci: mark unlink_empty_async_suspended() as
 __maybe_unused
In-Reply-To: <5154B436.5080700@prisktech.co.nz>
Message-ID: <Pine.LNX.4.44L0.1303291005120.1467-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Mar 2013, Tony Prisk wrote:

> On 29/03/13 10:16, Arnd Bergmann wrote:
> > On Thursday 28 March 2013, Arnd Bergmann wrote:
> >> Patch 4d053fdac3 "usb: ehci: unlink_empty_async_suspended() only used
> >> with CONFIG_PM" tried to hide the unlink_empty_async_suspended function
> >> inside of an #ifdef to work around an unused function warning.
> > Hi Greg,
> >
> > Apparently the warning is now also in 3.8.5, so you might want to backport
> > this fix as well after you send it upstream.
> >
> > 	Arnd
> Grr, my bad - I originally wrote the patch with the forward decl 
> #ifdef'd as well, but Alan pointed out that it didn't need to be. I 
> thought I recompiled it after the change, but obviously not.

It's my fault too.  I didn't realize the compiler would issue a warning 
about a static declaration with no definition.

Alan Stern

