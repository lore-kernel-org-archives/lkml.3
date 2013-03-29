Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab3C2OFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 10:05:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48283 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755518Ab3C2OFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:05:06 -0400
Date: Fri, 29 Mar 2013 10:05:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: Tony Prisk <linux@prisktech.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: ehci: mark unlink_empty_async_suspended() as
 __maybe_unused
In-Reply-To: <201303282109.47130.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1303290956390.1467-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Mar 2013, Arnd Bergmann wrote:

> Patch 4d053fdac3 "usb: ehci: unlink_empty_async_suspended() only used
> with CONFIG_PM" tried to hide the unlink_empty_async_suspended function
> inside of an #ifdef to work around an unused function warning.
> 
> Unfortunately that had the effect of introducing a new warning:
> 
> drivers/usb/host/ehci-q.c:1297:13: warning: 'unlink_empty_async_suspended' 
> 	declared 'static' but never defined [-Wunused-function]
> 
> While we could add another #ifdef around the function declaration to avoid
> this, a nicer solution is to mark it as __maybe_unused, which will let
> gcc silently drop the function definition when it is not needed.

IMO the compiler is being stupid.  -Wunused-function should warn 
about functions that are defined but not called, not about functions 
that are declared but not defined.  Grumble...

Anyway yes, this is a good fix.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

