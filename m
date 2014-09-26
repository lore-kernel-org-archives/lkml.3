Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaIZCJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 22:09:41 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:44114 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbaIZCJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 22:09:38 -0400
MIME-Version: 1.0
In-Reply-To: <5423D80B.9060500@6wind.com>
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>
	<54228D87.3070309@6wind.com>
	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>
	<5422F0F4.6000709@6wind.com>
	<CAHA+R7Ot2kLHb+ne5AW3bFNc87qkFOiEHEyDh9sFrsHqXgrY3g@mail.gmail.com>
	<5423D80B.9060500@6wind.com>
Date: Thu, 25 Sep 2014 19:09:37 -0700
Message-ID: <CAHA+R7Ooyam2L-QfP-TjMEZEOqrQcQDxYiebmw760kgEji4G=g@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
From: Cong Wang <cwang@twopensource.com>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: netdev <netdev@vger.kernel.org>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 1:53 AM, Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
> Le 24/09/2014 18:45, Cong Wang a écrit :
>>
>> On Wed, Sep 24, 2014 at 9:27 AM, Nicolas Dichtel
>> <nicolas.dichtel@6wind.com> wrote:
>>>
>>> Now informations got with 'ip link' are wrong and incomplete:
>>>    - the link dev is now tunl0 instead of eth0, because we only got an
>>> ifindex
>>>      from the kernel without any netns informations.
>>
>>
>> This is not new, macvlan has the same problem. This is why I said
>> it is mostly a display problem, maybe just mark the ifindex as -1 or
>> something when it is not in this netns. At least I don't expect the inner
>> netns know anything outside, and I don't think I am the only one using
>> netns in this way.
>
> I understand your point but there is several use of netns. Netns can be used
> also to instantiate virtual routers. In this case, administrators or daemons
> need to be able to monitor and dump the configuration on all netns
> (particularly beeing able to identify fully x-netns interfaces). We start to
> discuss this in one of the two thread pointed in my cover letter and get the
> conclusion that checking user ns is a good way to know if an id should be
> disclosed or not for a peer netns.

Then you are leaking information, this breaks isolation.

> Can you describe your use case?

Yes, too simple: isolation networking, different netns's don't see each other
(including anything inside) and only communicate via veth.


> If you only play with netns, you may want to monitor all activies in all
> netns
> (this is already possible) and beeing able to link information between netns
> (this is what I'm trying to solve).


No, I don't want to monitor anything. Even if I wanted, I would just start one
daemon in each netns instead of one for all.

On the other hand, why not exchange the configuration via veth
between different netns? There are many ways to do so with TCP HTTP etc.
This doesn't have to be solved in kernel.
