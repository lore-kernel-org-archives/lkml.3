Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaG2BQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 21:16:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35275 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaG2BQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 21:16:23 -0400
Date: Mon, 28 Jul 2014 18:16:21 -0700 (PDT)
Message-Id: <20140728.181621.1196619942413270695.davem@davemloft.net>
To: ast@plumgrid.com
Cc: pablo@netfilter.org, dborkman@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, willemb@google.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next] net: filter: rename 'struct sk_filter' to
 'struct bpf_prog'
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAMEtUuyuxfs7Liy_HCDijUX9Q8yziY2kt0XCpJtXUyMR1P941Q@mail.gmail.com>
References: <CAMEtUux8F4xZ77_HQADfoeV-9sibaEWm=XJcAaY+cQyDWb2caA@mail.gmail.com>
	<20140728214552.GA4049@salvia>
	<CAMEtUuyuxfs7Liy_HCDijUX9Q8yziY2kt0XCpJtXUyMR1P941Q@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Jul 2014 18:16:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexei Starovoitov <ast@plumgrid.com>
Date: Mon, 28 Jul 2014 18:12:05 -0700

> On Mon, Jul 28, 2014 at 2:45 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>> > struct sk_filter_cb {
>>> >         int type;
>>> >         struct module *me;
>>> >         void (*charge)(struct sock *sk, struct sk_filter *fp);
>>> >         void (*uncharge)(struct sock *sk, struct sk_filter *fp);
>>> >         unsigned int (*run_filter)(struct sk_filter *fp, struct sk_buff *skb);
>>> > };
>>>
>>> Pablo,
>>>
>>> I don't think you understand the scope of BPF.
>>> 'struct module *'? to attach nft to sockets? ouch.
>>
>> The idea is that there will be one sk_filter_cb per socket filtering
>> approach. The structure module is just there in case one of the
>> approach is loadable as kernel module, it's the typical code pattern
>> in the kernel. You can git grep for similar code.
> 
> socket filtering is available to unprivileged users.
> So you're proposing to let them increment refcnt of modules?!
> That's not secure.

It's impossible to avoid, and really is nothing new.

Users can open sockets, and that holds a reference to the module
implementing that protocol.  Is that not secure too?

This discussion is degenerating into nonsense, please stop ignoring
Pablo's core points.

Thanks.
