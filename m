Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbaLWQXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:23:32 -0500
Received: from ec2-54-201-57-178.us-west-2.compute.amazonaws.com ([54.201.57.178]:44469
	"EHLO ip-172-31-12-36.us-west-2.compute.internal"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750983AbaLWQXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:23:31 -0500
Date: Tue, 23 Dec 2014 16:20:13 +0000
From: dwalker@fifo99.com
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: add per console loglevel
Message-ID: <20141223162013.GB19144@fifo99.com>
References: <20141220224908.GB4466@fifo99.com>
 <20141221194753.49c12693@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141221194753.49c12693@neptune.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 07:47:53PM +0100, Bruno Prémont wrote:
> On Sat, 20 December 2014 dwalker@fifo99.com wrote:
> > This adds to to the console= command line options allowing the
> > addition of a per console log level setting.
> > 
> > examples,
> > 
> > 	console=ttyS0,ll4
> > 	console=tty0,ll6
> > 
> > This can be used on systems which have multiple serial consoles, but
> > it's desired for logging to be light on one and heavy on another.
> 
> Looks useful to me.
> What would be the best way to make these per-console loglevels
> configurable at runtime? `dmesg -n $LEVEL` only affects the global
> limit.
> 
> One drawback to letting global loglevel have precedence is that
> all consoles that should not get detailed log messages need to have
> their loglevel explicitly lowered and it's not possible to have
> one console forced to show more than the global loglevel.

Right, reason for the patch.
 
> 
> An approach I would prefer is to have all consoles follow global
> loglevel except when something different had been explicitly requested
> for them.

This patch is mostly like this. It breaks down when you set the "llX"
parameter to something above KERN_NOTICE, and the global one is also
set above that.

> This way a single console can be added later on (e.g. netconsole)
> and set to pass through debug messages without affecting anyone else.

Not following the "added later" part.

Daniel
