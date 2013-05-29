Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373Ab3E2Af2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 20:35:28 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:48675 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444Ab3E2Ae5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 20:34:57 -0400
Message-ID: <1369787693.3301.586.camel@edumazet-glaptop>
Subject: Re: [PATCH v2] rcu: fix a race in hlist_nulls_for_each_entry_rcu
 macro
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Roman Gushchin <klamm@yandex-team.ru>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, Dipankar Sarma <dipankar@in.ibm.com>,
        zhmurov@yandex-team.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Date: Tue, 28 May 2013 17:34:53 -0700
In-Reply-To: <51A47496.6000100@yandex-team.ru>
References: <519B8908.9080007@yandex-team.ru>
	  <1369150693.3301.233.camel@edumazet-glaptop>
	  <519BB90B.6080706@yandex-team.ru>
	  <1369188080.3301.268.camel@edumazet-glaptop>
	  <1369201765.3301.299.camel@edumazet-glaptop> <519CB2D8.103@yandex-team.ru>
	  <1369225837.3301.324.camel@edumazet-glaptop>
	  <519CC2FB.2010006@yandex-team.ru>
	  <20130522174532.GC3431@linux.vnet.ibm.com> <519D19DA.50400@yandex-team.ru>
	  <20130525113715.GA3795@linux.vnet.ibm.com>
	  <51A39E11.5020405@yandex-team.ru>
	 <1369699930.3301.494.camel@edumazet-glaptop>
	 <51A47496.6000100@yandex-team.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 13:10 +0400, Roman Gushchin wrote:
> On 28.05.2013 04:12, Eric Dumazet wrote:

> > Adding a barrier() is probably what we want.
> 
> I agree, inserting barrier() is also a correct and working fix.

Yeah, but I can not find a clean way to put it inside the "for (;;)"

for (barrier();;)  ->

error: expected expression before ‘__asm__’

No user currently does :

if (condition)
	hlist_nulls_for_each_entry_rcu(tpos, pos, head, member)

But who knows...


