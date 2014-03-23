Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaCWVu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 17:50:56 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:54056 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaCWVuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 17:50:54 -0400
Date: Sun, 23 Mar 2014 16:50:41 -0500
From: David Fries <David@Fries.net>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, zbr@ioremap.net,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: w1: 3.14-rc7 - possible recursive locking detected
Message-ID: <20140323215041.GB5096@spacedout.fries.net>
References: <CAAfyv37OPxJkcyYi0ZZe9MSQZ3TMeCuxa8rmWh8ahNF6Bs01Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfyv37OPxJkcyYi0ZZe9MSQZ3TMeCuxa8rmWh8ahNF6Bs01Mg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sun, 23 Mar 2014 16:50:43 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 10:38:13PM +0100, Belisko Marek wrote:
> Hi,
> 
> booting latest 3.14-rc7 on gta04 board gives following warning:
> 
> [    3.101409] Driver for 1-wire Dallas network protocol.
> [    3.109649] omap_hdq omap_hdq: OMAP HDQ Hardware Rev 0.5. Driver in
> [    3.400146]        CPU0
> [    3.402709]        ----
> [    3.405273]   lock(&(&priv->bus_notifier)->rwsem);
> [    3.410308]   lock(&(&priv->bus_notifier)->rwsem);
> [    3.415374]
> [    3.415374]  *** DEADLOCK ***
> 
> AFAIK we didn't see that on (at least 3/14-rc2).

The last drivers/w1 change went in before v3.14-rc1, so if it is
something in the w1 code, it has either been there or something else
in the rest of the kernel changed to expose it.  I'm using the ds2490
USB w1 dongle, I didn't see that problem when enabling lock debugging
on 3.14.0-rc5+ which includes some changes I'm working on.

https://github.com/dfries/linux.git w1_rework

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
