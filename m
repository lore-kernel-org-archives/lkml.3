Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab3C2NjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 09:39:06 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60208 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab3C2NjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 09:39:03 -0400
Message-ID: <1364564339.5113.19.camel@edumazet-glaptop>
Subject: Re: [PATCH] net: add a synchronize_net() in
 netdev_rx_handler_unregister()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Pirko <jpirko@redhat.com>, Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Nicolas de =?ISO-8859-1?Q?Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guy Streeter <streeter@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, stephen@networkplumber.org
Date: Fri, 29 Mar 2013 06:38:59 -0700
In-Reply-To: <1364563039.10629.19.camel@gandalf.local.home>
References: <1364490997.6345.237.camel@gandalf.local.home>
	 <1364491792.15753.47.camel@edumazet-glaptop>
	 <20130329094856.GB1677@minipsycho.orion>
	 <1364562082.5113.16.camel@edumazet-glaptop>
	 <1364563039.10629.19.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-29 at 09:17 -0400, Steven Rostedt wrote:

> I've thought about this too, but I wasn't sure we wanted two
> synchronize_*() functions, as the caller does a synchronize as well.
> That said, I think this is the more robust solution and it lets all
> rx_handler() functions assume that their rx_handler_data is set. And it
> removes the check from the fast path which outweighs an added
> synchronization in the slow path.
> 

Note that I used synchronize_net(), which does a
synchronize_rcu_expedited() when RTNL is locked, so its normally quite
fast.

> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> Thanks!

Thanks a lot for your very detailed report and analysis !


