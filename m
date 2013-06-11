Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3FKP7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 11:59:10 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44416 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab3FKP7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 11:59:08 -0400
Message-ID: <1370966332.3252.38.camel@edumazet-glaptop>
Subject: Re: [PATCH net-next 2/2] net:add socket option for low latency
 polling
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
Date: Tue, 11 Jun 2013 08:58:52 -0700
In-Reply-To: <51B74439.3030203@linux.intel.com>
References: <20130611142415.17879.75569.stgit@ladj378.jer.intel.com>
	  <20130611142438.17879.6389.stgit@ladj378.jer.intel.com>
	 <1370961930.3252.32.camel@edumazet-glaptop>
	 <51B74439.3030203@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 18:37 +0300, Eliezer Tamir wrote:
> On 11/06/2013 17:45, Eric Dumazet wrote:
> > On Tue, 2013-06-11 at 17:24 +0300, Eliezer Tamir wrote:
> >> adds a socket option for low latency polling.
> >> This allows overriding the global sysctl value with a per-socket one.
> >>
> >> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> >> ---
> >>
> >>
> >> -static inline cycles_t ll_end_time(void)
> >> +static inline cycles_t ll_end_time(struct sock *sk)
> >>   {
> >> -	return TSC_MHZ * ACCESS_ONCE(sysctl_net_ll_poll) + get_cycles();
> >> +	return TSC_MHZ * ACCESS_ONCE(sk->sk_ll_usec) + get_cycles();
> >>   }
> >
> > Hmm, sk_ll_usec is an unsigned int.
> 
> We changed it to an unsigned long in v7, I guess that was gratuitous.
> Re-reading your comments on v6 2/5 I realize a cast would have sufficed.
> Should I send a patch to revert it to an unsigned int?

One sysctl as unsigned long was not a big deal so I was ok with your
change ;)

unsigned int for sk_ll_usec is enough, but using a 32x32->64bit multiply
is probably safer.




