Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaFFS5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:57:13 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37101 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbaFFS5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:57:11 -0400
Message-ID: <1402081030.3645.312.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: Multitude of dst obsolescense race conditions
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: dormando <dormando@rydia.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Fri, 06 Jun 2014 11:57:10 -0700
In-Reply-To: <20140606181236.GS4581@linux.vnet.ibm.com>
References: <alpine.DEB.2.02.1405140233210.16893@dtop>
	 <1400067618.7973.72.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140606181236.GS4581@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 11:12 -0700, Paul E. McKenney wrote:

> It is probably just be me getting lost in the code, but I am not seeing
> a synchronize_rcu(), call_rcu(), or synchronize_net() anywhere in
> dst_release() or the things that it calls.  If there really isn't such
> a call, then I don't see how the above code is safe in the case where
> __sk_dst_set() is invoked on one CPU just after sk_dst_get() executes
> the rcu_dereference() on some other CPU.

Well, this part is fine, dst_release() do not free dst that are
potentially stored in sk_dst_cache

Only the refcount is decremented.

The bug is elsewhere, we had another thread raising this issue on netdev
this morning.

I am cooking a patch to clear the mess.

Thanks


