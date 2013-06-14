Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315Ab3FNBQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 21:16:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab3FNBQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 21:16:49 -0400
Date: Thu, 13 Jun 2013 18:15:31 -0700 (PDT)
Message-Id: <20130613.181531.1879909059826723046.davem@redhat.com>
To: mschiffer@universe-factory.net
Cc: xiyou.wangcong@gmail.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net/3.9] ipv6: ndisc: fix ndisc_send_redirect writing
 to the wrong skb
From: David Miller <davem@redhat.com>
In-Reply-To: <51B1BD64.8090300@universe-factory.net>
References: <CAM_iQpWNAnRTgzjPTPxLU-eqz1nWqD=zyjTgwZaaxbwcpf4KMw@mail.gmail.com>
	<20130531.014244.1871655049070137342.davem@davemloft.net>
	<51B1BD64.8090300@universe-factory.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Schiffer <mschiffer@universe-factory.net>
Date: Fri, 07 Jun 2013 13:00:52 +0200

> On 05/31/2013 10:42 AM, David Miller wrote:
>> From: Cong Wang <xiyou.wangcong@gmail.com>
>> Date: Fri, 31 May 2013 11:23:11 +0800
>> 
>>> On Fri, May 31, 2013 at 9:27 AM, Matthias Schiffer
>>> <mschiffer@universe-factory.net> wrote:
>>>> Since some refactoring in 5f5a011, ndisc_send_redirect called
>>>> ndisc_fill_redirect_hdr_option on the wrong skb, leading to data corruption or
>>>> in the worst case a panic when the skb_put failed.
>>>>
>>>> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
>>>
>>>
>>> Good catch!
>>>
>>> Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
>> 
>> I've queued this up for -stable.
>> 
> 
> I saw that this was marked as 'not applicable' in the patchwork - it
> should still be applied to the net tree though. I hope my patch tag
> 'net/3.9' didn't cause any confusion, I meant net *and* 3.9.

It's in the -stable queue and it will be submitted, don't worry.

In this situation it means "not applicable" to net or net-next, sorry
for the confusion.

The way I work with the "stable" patchwork bundle is I process that
queue with state filtering off, so that the patch bundle I end up with
has every patch in that queue, regardless of state.
