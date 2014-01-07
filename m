Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaAGKjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:39:17 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:58163 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaAGKjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:39:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140106215335.GC9894@breakpoint.cc>
References: <1389023672-14351-1-git-send-email-avagin@openvz.org>
	<20140106170235.GJ28854@breakpoint.cc>
	<20140106205414.GA19788@gmail.com>
	<20140106215335.GC9894@breakpoint.cc>
Date: Tue, 7 Jan 2014 14:39:14 +0400
Message-ID: <CANaxB-w0-ErUvrEiGmG7dxV-dBwnYX3eX8rE0NQ=boKbc6HU8w@mail.gmail.com>
Subject: Re: [PATCH] netfilter: nf_conntrack: release conntrack from rcu callback
From: Andrey Wagin <avagin@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, vvs@openvz.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

2014/1/7 Florian Westphal <fw@strlen.de>:
> Andrew Vagin <avagin@gmail.com> wrote:

>> >                 ct = nf_ct_tuplehash_to_ctrack(h);
>> >                 if (unlikely(nf_ct_is_dying(ct) ||
>> >                              !atomic_inc_not_zero(&ct->ct_general.use)))
>> >                     // which means we should hit this path (0 ref).
>> >                         h = NULL;
>> >                 else {
>> >                     // otherwise, it cannot go away from under us, since
>> >                     // we own a reference now.
>> >                         if (unlikely(!nf_ct_tuple_equal(tuple, &h->tuple) ||
>> >                                      nf_ct_zone(ct) != zone)) {
>
> Perhaps this needs additional !nf_ct_is_confirmed()?

Yes, it think it must help. Thank you for the comments. I resent this patch:
[PATCH] netfilter: nf_conntrack: fix RCU race in nf_conntrack_find_get

>
> It would cover your case (found a recycled element that has been put on
> the unconfirmed list (refcnt already set to 1, ct->tuple is set) on another cpu,
> extensions possibly not yet fully initialised), and the same tuple).
>
> Regards,
> Florian

Thanks,
Andrey
