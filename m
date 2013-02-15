Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161383Ab3BONOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:14:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23929 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161313Ab3BONOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 08:14:16 -0500
Date: Fri, 15 Feb 2013 08:14:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: One more: Re: [GIT PULL] (xen) stable/for-jens-3.8
Message-ID: <20130215131406.GA11630@phenom.dumpdata.com>
References: <20130214232630.GA8440@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214232630.GA8440@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 06:26:30PM -0500, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> Please git pull the following branch:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.8
> 
> which has fixes to the blkback that I hope you can push to Linus for 3.8.
> The one that is quite vicious is the "xen-blkfront: drop the use of
> llist_for_each_entry_safe". It is a fix to re-do an "free-ing" loop - otherwise
> we hit a GCC 4.1.1 bug (so RHEL5 based) that turns the loop in an unbound one.
> 
> Please pull!
> 
>  drivers/block/xen-blkback/blkback.c |  1 -
>  drivers/block/xen-blkback/xenbus.c  | 49 ++++++++++++++++++-------------------
>  drivers/block/xen-blkfront.c        | 13 +++++++---
>  include/linux/llist.h               | 25 -------------------
>  4 files changed, 34 insertions(+), 54 deletions(-)
> 
> Jan Beulich (1):
>       xen-blkback: do not leak mode property
> 
> Konrad Rzeszutek Wilk (2):
>       xen/blkback: Don't trust the handle from the frontend.
>       xen-blkfront: drop the use of llist_for_each_entry_safe
> 

And on the hells of that one, I've got one more ! (yeah, I am sure you
are thrilled about it).

Same branch:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.8

This time fixing a memory leak in the xen-blkback with the persistent
grants feature.

 drivers/block/xen-blkback/blkback.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Roger Pau Monne (1):
      xen-blkback: use balloon pages for persistent grants

Please pull!

If you want to delay pushing them to Linus until 3.9 I can poke Greg
about back-porting those to the stable tree - your call.

