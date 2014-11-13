Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbaKMK07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:26:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41802 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbaKMK05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:26:57 -0500
Date: Thu, 13 Nov 2014 10:26:53 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.17 023/319] drivers/net: Disable UFO through virtio
Message-ID: <20141113102653.GA9451@hercules>
References: <20141112010952.553519040@linuxfoundation.org>
 <20141112010956.540146480@linuxfoundation.org>
 <1415826239.3398.113.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415826239.3398.113.camel@decadent.org.uk>
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
> 

I guess the same applies to the 3.16 kernel; I'll drop both patches
from the kernel currently under review.

Cheers,
--
Luís
> Ben.
> 
> -- 
> Ben Hutchings
> Experience is directly proportional to the value of equipment destroyed.
>                                                          - Carolyn Scheppner

