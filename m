Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161655AbaKNRqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:46:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50683 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161182AbaKNRqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:46:43 -0500
Date: Fri, 14 Nov 2014 09:46:42 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.17 023/319] drivers/net: Disable UFO through virtio
Message-ID: <20141114174642.GA2895@kroah.com>
References: <20141112010952.553519040@linuxfoundation.org>
 <20141112010956.540146480@linuxfoundation.org>
 <1415826239.3398.113.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415826239.3398.113.camel@decadent.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 09:03:59PM +0000, Ben Hutchings wrote:
> On Wed, 2014-11-12 at 10:12 +0900, Greg Kroah-Hartman wrote:
> > 3.17-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Ben Hutchings <ben@decadent.org.uk>
> > 
> > [ Upstream commit 3d0ad09412ffe00c9afa201d01effdb6023d09b4 ]
> > 
> > IPv6 does not allow fragmentation by routers, so there is no
> > fragmentation ID in the fixed header.  UFO for IPv6 requires the ID to
> > be passed separately, but there is no provision for this in the virtio
> > net protocol.
> > 
> > Until recently our software implementation of UFO/IPv6 generated a new
> > ID, but this was a bug.  Now we will use ID=0 for any UFO/IPv6 packet
> > passed through a tap, which is even worse.
> > 
> > Unfortunately there is no distinction between UFO/IPv4 and v6
> > features, so disable UFO on taps and virtio_net completely until we
> > have a proper solution.
> [...]
> 
> Please drop this patch for 3.14 and 3.17.  It causes problems for
> migration of VMs and we're probably going to revert part of this.  The
> following patch ("drivers/net, ipv6: Select IPv6 fragment idents for
> virtio UFO packets") might no longer apply, in which case you can drop
> that as well until we have this sorted out upstream.

Oops, I missed this for 3.14-stable, I'll go revert that as the first
patch to be queued up for the next round there.

I've dropped this from 3.17-stable, and the patch "drivers/net, ipv6:
Select IPv6 fragment idents for virtio UFO packets" still applied with
some fuzz, I'll do a test build to ensure I didn't break anything there.

thanks,

greg k-h
