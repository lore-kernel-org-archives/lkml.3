Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab3BVXA4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 18:00:56 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:49464 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757647Ab3BVXAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 18:00:53 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AocJAEj4J1F5LJe7/2dsb2JhbABEhWW2P4UTgQsXc4IfAQEFOhwjEAgDGAklDwUlAyETiBG/HxWOGiI9B4NAA5Y5kGSDGw
Date: Sat, 23 Feb 2013 10:00:48 +1100
From: Dave Chinner <david@fromorbit.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] dcache: make Oracle more scalable on large systems
Message-ID: <20130222230048.GP26694@dastard>
References: <1361299859-27056-1-git-send-email-Waiman.Long@hp.com>
 <20130221233818.GM26694@dastard>
 <m2bobdxl1i.fsf@firstfloor.org>
 <5126F067.4040707@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5126F067.4040707@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 11:13:27PM -0500, Waiman Long wrote:
> On 02/21/2013 07:13 PM, Andi Kleen wrote:
> >Dave Chinner<david@fromorbit.com>  writes:
> >
> >>On Tue, Feb 19, 2013 at 01:50:55PM -0500, Waiman Long wrote:
> >>>It was found that the Oracle database software issues a lot of call
> >>>to the seq_path() kernel function which translates a (dentry, mnt)
> >>>pair to an absolute path. The seq_path() function will eventually
> >>>take the following two locks:
> >>Nobody should be doing reverse dentry-to-name lookups in a quantity
> >>sufficient for it to become a performance limiting factor. What is
> >>the Oracle DB actually using this path for?
> >Yes calling d_path frequently is usually a bug elsewhere.
> >Is that through /proc ?
> >
> >-Andi
> >
> >
> A sample strace of Oracle indicates that it opens a lot of /proc
> filesystem files such as the stat, maps, etc many times while
> running. Oracle has a very detailed system performance reporting
> infrastructure in place to report almost all aspect of system
> performance through its AWR reporting tool or the browser-base
> enterprise manager. Maybe that is the reason why it is hitting this
> performance bottleneck.

That seems to me like an application problem - poking at what the
kernel is doing via diagnostic interfaces so often that it gets in
the way of the kernel actually doing stuff is not a problem the
kernel can solve.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
