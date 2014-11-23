Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaKWUbZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 15:31:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493AbaKWUbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 15:31:23 -0500
Date: Sun, 23 Nov 2014 22:30:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: pagupta@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com, dgibson@redhat.com, vfalico@gmail.com,
        edumazet@google.com, vyasevic@redhat.com, hkchu@google.com,
        wuzhy@linux.vnet.ibm.com, xemul@parallels.com, therbert@google.com,
        bhutchings@solarflare.com, xii@google.com, stephen@networkplumber.org,
        jiri@resnulli.us, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH net-net 0/4] Increase the limit of tuntap queues
Message-ID: <20141123203032.GA6286@redhat.com>
References: <20141119.151628.768548269128919029.davem@davemloft.net>
 <20141119204427.GB30994@redhat.com>
 <20141123104623.GA31915@redhat.com>
 <20141123.134323.1154795102254868842.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141123.134323.1154795102254868842.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 01:43:23PM -0500, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Sun, 23 Nov 2014 12:46:23 +0200
> 
> > At the moment attaching/detaching queues is an unpriveledged operation.
> > 
> > Shouldn't we worry that an application can cause large
> > allocations, and provide a way to limit these?
> > 
> > David, could you comment on this please?
> 
> I don't want arbitrary limits imposed.
> 
> Where does this "application" run?  If it's in the host, then who
> cares?  If they suck up all of their available memory with queue
> resources, it's their problem.

qemu runs in the host, but it's unpriveledged: it gets
passed tun FDs by a priveledged daemon, and it only
has the rights to some operations,
in particular to attach and detach queues.

The assumption always was that this operation is safe
and can't make kernel run out of resources.


-- 
MST
