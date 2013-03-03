Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3CCTV4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 14:21:56 -0500
Received: from two.firstfloor.org ([193.170.194.197]:34132 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3CCTVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 14:21:55 -0500
Date: Sun, 3 Mar 2013 20:21:53 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [RFC PATCH 1/5] net: implement support for low latency socket
 polling
Message-ID: <20130303192153.GC3401@two.firstfloor.org>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
 <20130227175555.10611.42794.stgit@gitlad.jf.intel.com>
 <1362335704.15793.81.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362335704.15793.81.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alternative to 2) would be to use a generation id, incremented every
> time a napi used in spin polling enabled driver is dismantled (and freed
> after RCU grace period)
> 
> And store in sockets not only the pointer to napi_struct, but the
> current generation id : If the generation id doesnt match, disable
> the spinpoll until next packet rebuilds the cache again.

This would require rcu_read_lock, aka preempt off, during polling, right?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
