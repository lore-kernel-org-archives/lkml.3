Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631Ab3EBS15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:27:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51395 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760931Ab3EBS14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:27:56 -0400
Date: Thu, 2 May 2013 14:27:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-kernel@vger.kernel.org, <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH, RFC 16/22] USB: UHCI: clarify Kconfig dependencies
In-Reply-To: <201305021952.35040.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1305021423450.1436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 May 2013, Arnd Bergmann wrote:

> > What do you think of my patch as compared to yours? 
> 
> I think in the end it comes down to the question where you want to
> head with your driver. The way I did my version was going towards
> making it similar to EHCI, with stand-alone bus glue drivers
> and a core that is just a library module but does not register
> a device_driver by itself.
> 
> Given that there are just three bus glues from UHCI, and at most
> two of them enabled at the same time, I don't see a direct need
> for UHCI to go down the same route as EHCI. If you want to just
> leave this driver alone, your patch is simpler and has the same
> effect in the end. Otherwise I think my patch avoids changing it
> all again once the driver gets reworked.

Okay then, I'll submit my patch to Greg after the merge window closes.

> Things might also get a little messy if we are seeing a lot
> of other platforms beside VIA VT8500 use UHCI, but I think that
> is rather unlikely.

Indeed.  UHCI is the oldest of the host controller standards; people
aren't about to start creating a whole bunch of new implementations of 
it.  Even Intel no longer uses UHCI on their more recent motherboards.

Alan Stern

