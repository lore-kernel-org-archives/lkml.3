Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaJCMW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:22:29 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:65381 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaJCMW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:22:27 -0400
Message-ID: <542E94FF.7070109@6wind.com>
Date: Fri, 03 Oct 2014 14:22:23 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        Network Development <netdev@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <cwang@twopensource.com>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>	<87ppei45ig.fsf@x220.int.ebiederm.org>	<CALCETrX5e0cp4QFCv1eAqR1hjoROU9Rh=cRos9U35DaR-py3Eg@mail.gmail.com>	<87y4t61a6v.fsf@x220.int.ebiederm.org> <54294B4E.70501@6wind.com>	<87y4t2gtd0.fsf@x220.int.ebiederm.org> <542D5726.8070308@6wind.com> <8761g2nurx.fsf@x220.int.ebiederm.org>
In-Reply-To: <8761g2nurx.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/10/2014 21:20, Eric W. Biederman a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>
>> Le 29/09/2014 20:43, Eric W. Biederman a écrit :
>>> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>>>
>>>> Le 26/09/2014 20:57, Eric W. Biederman a écrit :
>>>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>>>
>>>>>> On Fri, Sep 26, 2014 at 11:10 AM, Eric W. Biederman
>>>>>> <ebiederm@xmission.com> wrote:
>>>>>>> I see two ways to go with this.
>>>>>>>
>>>>>>> - A per network namespace table to that you can store ids for ``peer''
>>>>>>>      network namespaces.  The table would need to be populated manually by
>>>>>>>      the likes of ip netns add.
>>>>>>>
>>>>>>>      That flips the order of assignment and makes this idea solid.
>>>> I have a preference for this solution, because it allows to have a full
>>>> broadcast messages. When you have a lot of network interfaces (> 10k),
>>>> it saves a lot of time to avoid another request to get all informations.
>>>
>>> My practical question is how often does it happen that we care?
>> In fact, I don't think that scenarii with a lot of netns have a full mesh of
>> x-netns interfaces. It will be more one "link" netns with the physical
>> interface and all other with one interface with the link part in this "link"
>> netns. Hence, only one nsid is needing in each netns.
>
> I will buy that a full mesh is unlikely.
>
> For people doing simulations anything physical has a limited number of
> links.
>
> For people wanting all to all connectivity setting up an internal
> macvlan (or the equivalent) is likely much simpler and more efficient
> that a full mesh.
>
> So the question in my mind is how do we create these identifiers at need
> (when we create the cross network namespace links) instead of at network
> namespace creation time.  I don't see an answer to that in your patches,
> and perhaps it obvious.
For me, it is the responsability of the user who creates the netns. He should
know what will be done with this new netns, hence he may or may not define an
id. It's also possible to delegate this to the user who will create the tunnel.
In other words, it's part of the configuration.
