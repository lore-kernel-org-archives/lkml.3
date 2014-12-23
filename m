Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbaLWVNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 16:13:36 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:47452 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaLWVNf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 16:13:35 -0500
Date: Tue, 23 Dec 2014 22:13:24 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: dwalker@fifo99.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: add per console loglevel
Message-ID: <20141223221324.11d00624@neptune.home>
In-Reply-To: <20141223162013.GB19144@fifo99.com>
References: <20141220224908.GB4466@fifo99.com>
	<20141221194753.49c12693@neptune.home>
	<20141223162013.GB19144@fifo99.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 December 2014 dwalker@fifo99.com wrote:
> On Sun, Dec 21, 2014 at 07:47:53PM +0100, Bruno Prémont wrote:
> > On Sat, 20 December 2014 dwalker@fifo99.com wrote:
> > > This adds to to the console= command line options allowing the
> > > addition of a per console log level setting.
> > > 
> > > examples,
> > > 
> > > 	console=ttyS0,ll4
> > > 	console=tty0,ll6
> > > 
> > > This can be used on systems which have multiple serial consoles, but
> > > it's desired for logging to be light on one and heavy on another.
> > 
> > Looks useful to me.
> > What would be the best way to make these per-console loglevels
> > configurable at runtime? `dmesg -n $LEVEL` only affects the global
> > limit.
> > 
> > One drawback to letting global loglevel have precedence is that
> > all consoles that should not get detailed log messages need to have
> > their loglevel explicitly lowered and it's not possible to have
> > one console forced to show more than the global loglevel.
> 
> Right, reason for the patch.
>  
> > 
> > An approach I would prefer is to have all consoles follow global
> > loglevel except when something different had been explicitly requested
> > for them.
> 
> This patch is mostly like this. It breaks down when you set the "llX"
> parameter to something above KERN_NOTICE, and the global one is also
> set above that.

In your patch global filter applies first, then what passes global filter
gets filtered with the per-console filter.

So I can't have `dmesg -n 3` and "console=ttyS0,ll8 console=tty0"
to get my debugging output over serial console.

> > This way a single console can be added later on (e.g. netconsole)
> > and set to pass through debug messages without affecting anyone else.

Netconsole console can be added at any time when system is running
either through loading of its module or using dynamic configuration
via configfs.

See also my patches.

Thanks,
Bruno
