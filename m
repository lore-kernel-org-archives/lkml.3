Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaBTHJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 02:09:13 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:23256 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbaBTHJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 02:09:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsQHABepBVN5LJYe/2dsb2JhbABZgwaEEbcshVGBFBd0giUBAQUjDwEjIxAIAxgCAgUhAgIPBSUDIRMbh2mscqE9FxaBE4xuTQeCb4FJBJgvilCHVYNBKIEt
Date: Thu, 20 Feb 2014 18:09:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Joe Perches <joe@perches.com>
Cc: pawel.sikora@agmk.net, linux-kernel@vger.kernel.org
Subject: Re: [3.13.2] list passed to list_sort() too long for efficiency.
Message-ID: <20140220070907.GP13647@dastard>
References: <1799469.xr2i5c36Hj@localhost.localdomain>
 <1392227186.1868.20.camel@joe-AO722>
 <4850975.2GAlrTXDHt@localhost.localdomain>
 <1392228466.1868.24.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392228466.1868.24.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 10:07:46AM -0800, Joe Perches wrote:
> On Wed, 2014-02-12 at 18:59 +0100, Paweł Sikora wrote:
> > On Wednesday 12 of February 2014 09:46:26 Joe Perches wrote:
> > > On Wed, 2014-02-12 at 18:16 +0100, Paweł Sikora wrote:
> > > > [16855.582522] list passed to list_sort() too long for efficiency
> > > > 
> > > > could someone put some light on the last line?
> > > 
> > > Did you look at the list_sort function in lib/list_sort.c?
> > > 
> > > (granted the dmesg is harder to find that it should be
> > >  because the format is split)
> > > 
> > > It just means it's slower than it could otherwise be
> > 
> > thanks,
> > so without a stacktrace in dmesg we can't isolate a root of cause :/
> > 
> 
> Perhaps something like this would help:
> 
> Emit the caller of list_sort using %pS when the list is too
> long to be efficient.  Also emit the message if necessary
> once for each call.

Still not useful. For XFS, the list_sort caller isn't directly of
interest - it's further down the stack where the interesting
information is (e.g. caller flushing buffers from log recovery,
metadata writeback, quota shrinker, quotacheck, etc).  Only a full
stack trace will tell us what we need to know.

I think WARN_ON_ONCE() is probably a better solution here.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
