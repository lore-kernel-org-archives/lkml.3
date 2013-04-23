Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab3DWXoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 19:44:39 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:35521 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab3DWXog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 19:44:36 -0400
Date: Tue, 23 Apr 2013 16:44:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephen Rothwell <sfr@canb.auug.org.au>, Patrick McHardy <kaber@trash.net>
cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (net-next
 tree related)
In-Reply-To: <20130423174618.59095bd1cf999c61332d4805@canb.auug.org.au>
Message-ID: <alpine.DEB.2.02.1304231639490.6938@chino.kir.corp.google.com>
References: <20130423174618.59095bd1cf999c61332d4805@canb.auug.org.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013, Stephen Rothwell wrote:

> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> net/netlink/af_netlink.c: In function 'netlink_frame_flush_dcache':
> net/netlink/af_netlink.c:384:40: error: 'NL_MMAP_MSG_HDRLEN' undeclared (first use in this function)
> 
> Caused by commit 9652e931e73b ("netlink: add mmap'ed netlink helper
> functions").  This needed to be build tested on an architecture that has
> ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE set to 1 (like Sparc :-)).
> 

Hijacking this thread since I didn't see the causing patch to be posted to 
lkml.  From linux-next:

net/netlink/af_netlink.c: In function 'netlink_queue_mmaped_skb':
net/netlink/af_netlink.c:663:14: error: incompatible types when assigning to type '__u32' from type 'kuid_t'
net/netlink/af_netlink.c:664:14: error: incompatible types when assigning to type '__u32' from type 'kgid_t'
net/netlink/af_netlink.c: In function 'netlink_ring_set_copied':
net/netlink/af_netlink.c:693:14: error: incompatible types when assigning to type '__u32' from type 'kuid_t'
net/netlink/af_netlink.c:694:14: error: incompatible types when assigning to type '__u32' from type 'kgid_t'

for a config with CONFIG_UIDGID_STRICT_TYPE_CHECKS enabled.

Looks like it's coming from f9c2288837ba ("netlink: implement memory 
mapped recvmsg()").  Patrick?
