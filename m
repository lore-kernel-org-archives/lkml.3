Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934855Ab3E2BbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 21:31:19 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:58195 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934525Ab3E2BbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 21:31:18 -0400
Date: Tue, 28 May 2013 18:31:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Roman Gushchin <klamm@yandex-team.ru>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, zhmurov@yandex-team.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] rcu: fix a race in hlist_nulls_for_each_entry_rcu
 macro
Message-ID: <20130529013111.GS6172@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <519CB2D8.103@yandex-team.ru>
 <1369225837.3301.324.camel@edumazet-glaptop>
 <519CC2FB.2010006@yandex-team.ru>
 <20130522174532.GC3431@linux.vnet.ibm.com>
 <519D19DA.50400@yandex-team.ru>
 <20130525113715.GA3795@linux.vnet.ibm.com>
 <51A39E11.5020405@yandex-team.ru>
 <1369699930.3301.494.camel@edumazet-glaptop>
 <51A47496.6000100@yandex-team.ru>
 <1369787693.3301.586.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1369787693.3301.586.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052901-7282-0000-0000-000017A052BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 05:34:53PM -0700, Eric Dumazet wrote:
> On Tue, 2013-05-28 at 13:10 +0400, Roman Gushchin wrote:
> > On 28.05.2013 04:12, Eric Dumazet wrote:
> 
> > > Adding a barrier() is probably what we want.
> > 
> > I agree, inserting barrier() is also a correct and working fix.
> 
> Yeah, but I can not find a clean way to put it inside the "for (;;)"
> 
> for (barrier();;)  ->
> 
> error: expected expression before ‘__asm__’
> 
> No user currently does :
> 
> if (condition)
> 	hlist_nulls_for_each_entry_rcu(tpos, pos, head, member)
> 
> But who knows...

I still have my earlier question, but I suggest "({ barrier(); XXX })"
to put the barrier into the for loop, either in the second or third
clause, where XXX was the original second or third clause.

							Thanx, Paul

