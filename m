Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3FEPjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:39:25 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45316 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab3FEPjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:39:24 -0400
Message-ID: <1370446760.24311.275.camel@edumazet-glaptop>
Subject: Re: [PATCH v9 net-next 2/7] net: add low latency socket poll
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 05 Jun 2013 08:39:20 -0700
In-Reply-To: <51AF59B0.6080101@linux.intel.com>
References: <20130605103400.11172.49099.stgit@ladj378.jer.intel.com>
	  <20130605103421.11172.82925.stgit@ladj378.jer.intel.com>
	 <1370445714.24311.268.camel@edumazet-glaptop>
	 <51AF59B0.6080101@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 18:30 +0300, Eliezer Tamir wrote:
> On 05/06/2013 18:21, Eric Dumazet wrote:
> > On Wed, 2013-06-05 at 13:34 +0300, Eliezer Tamir wrote:
> >
> >
> > This is probably too big to be inlined, and nonblock should be a bool
> 
> 
> > It would also make sense to give end_time as a parameter, so that the
> > polling() code could really give  a end_time for the whole duration of
> > poll().
> >
> > (You then should test can_poll_ll(end_time) _before_ call to
> > ndo_ll_poll())
> 
> how would you handle a nonblocking operation in that case?
> I guess if we have a socket option, then we don't need to handle none 
> blocking any diffrent, since the user specified exactly how much time to 
> waste polling. right?

If the thread already spent 50us in the poll() system call, it for sure
should not call any ndo_ll_poll(). This makes no more sense at this
point.



