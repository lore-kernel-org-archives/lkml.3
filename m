Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3F1HZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 03:25:18 -0400
Received: from stringer.orebokech.com ([88.190.240.207]:59456 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3F1HZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 03:25:16 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jun 2013 03:25:16 EDT
From: Romain Francoise <romain@orebokech.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kvm@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-net: fall back to vmalloc if high-order allocation fails
Organization: orebokech dot com
References: <87k3r31vbc.fsf@silenus.orebokech.com>
	<20130123210411.GA9055@redhat.com>
Date: Fri, 28 Jun 2013 09:16:59 +0200
In-Reply-To: <20130123210411.GA9055@redhat.com> (Michael S. Tsirkin's message
	of "Wed, 23 Jan 2013 23:04:11 +0200")
Message-ID: <87k3leemc4.fsf@kima.orebokech.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:

> On Wed, Jan 23, 2013 at 09:46:47PM +0100, Romain Francoise wrote:
>> Creating a vhost-net device allocates an object large enough (34320 bytes
>> on x86-64) to trigger an order-4 allocation, which may fail if memory if
>> fragmented:
>> 
>>  libvirtd: page allocation failure: order:4, mode:0x2000d0
>>  ...
>>  SLAB: Unable to allocate memory on node 0 (gfp=0xd0)
>>    cache: size-65536, object size: 65536, order: 4
>>    node 0: slabs: 8/8, objs: 8/8, free: 0
>> 
>> In that situation, rather than forcing the caller to use regular
>> virtio-net, try to allocate the descriptor with vmalloc().
>> 
>> Signed-off-by: Romain Francoise <romain@orebokech.com>

> Thanks for the patch.
> Hmm, I haven't seen this.
> Maybe we should try and reduce our memory usage,
> I will look into this.

Did you get a chance to investigate this? I'm still getting the same
allocation failures with v3.10-rc7 after reverting my local patch.

Thanks.
