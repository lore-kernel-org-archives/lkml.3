Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaFFWR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 18:17:58 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:37427 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaFFWR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 18:17:57 -0400
Date: Fri, 6 Jun 2014 15:17:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: dormando <dormando@rydia.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Multitude of dst obsolescense race conditions
Message-ID: <20140606221749.GX4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.02.1405140233210.16893@dtop>
 <1400067618.7973.72.camel@edumazet-glaptop2.roam.corp.google.com>
 <20140606181236.GS4581@linux.vnet.ibm.com>
 <1402081030.3645.312.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402081030.3645.312.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060622-1344-0000-0000-0000020F8054
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 11:57:10AM -0700, Eric Dumazet wrote:
> On Fri, 2014-06-06 at 11:12 -0700, Paul E. McKenney wrote:
> 
> > It is probably just be me getting lost in the code, but I am not seeing
> > a synchronize_rcu(), call_rcu(), or synchronize_net() anywhere in
> > dst_release() or the things that it calls.  If there really isn't such
> > a call, then I don't see how the above code is safe in the case where
> > __sk_dst_set() is invoked on one CPU just after sk_dst_get() executes
> > the rcu_dereference() on some other CPU.
> 
> Well, this part is fine, dst_release() do not free dst that are
> potentially stored in sk_dst_cache
> 
> Only the refcount is decremented.
> 
> The bug is elsewhere, we had another thread raising this issue on netdev
> this morning.
> 
> I am cooking a patch to clear the mess.

Ah, thank you, sorry for the noise!

							Thanx, Paul

