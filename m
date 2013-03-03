Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3CCVUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 16:20:07 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:51729 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab3CCVUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 16:20:05 -0500
Message-ID: <1362345601.15793.83.camel@edumazet-glaptop>
Subject: Re: [RFC PATCH 1/5] net: implement support for low latency socket
 polling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Sun, 03 Mar 2013 13:20:01 -0800
In-Reply-To: <20130303192153.GC3401@two.firstfloor.org>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
	 <20130227175555.10611.42794.stgit@gitlad.jf.intel.com>
	 <1362335704.15793.81.camel@edumazet-glaptop>
	 <20130303192153.GC3401@two.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-03-03 at 20:21 +0100, Andi Kleen wrote:
> > Alternative to 2) would be to use a generation id, incremented every
> > time a napi used in spin polling enabled driver is dismantled (and freed
> > after RCU grace period)
> > 
> > And store in sockets not only the pointer to napi_struct, but the
> > current generation id : If the generation id doesnt match, disable
> > the spinpoll until next packet rebuilds the cache again.
> 
> This would require rcu_read_lock, aka preempt off, during polling, right?
> 

Of course, polling probably needs BH disabling as well to get the per
napi lock


