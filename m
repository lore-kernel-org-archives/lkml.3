Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570AbaLDQVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:21:15 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36780 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbaLDQVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:21:13 -0500
Message-ID: <548089F5.30202@6wind.com>
Date: Thu, 04 Dec 2014 17:21:09 +0100
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        davem@davemloft.net, stephen@networkplumber.org,
        akpm@linux-foundation.org, luto@amacapital.net, cwang@twopensource.com
Subject: Re: [PATCH net-next v4 0/4] netns: allow to identify peer netns
References: <1412257690-31253-1-git-send-email-nicolas.dichtel@6wind.com>	<1414682728-4532-1-git-send-email-nicolas.dichtel@6wind.com>	<871tpph03k.fsf@x220.int.ebiederm.org> <54535B00.5090708@6wind.com> <87wq7g831b.fsf@x220.int.ebiederm.org> <545A32C4.7070108@6wind.com>
In-Reply-To: <545A32C4.7070108@6wind.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 05/11/2014 15:23, Nicolas Dichtel a écrit :
> Le 31/10/2014 20:14, Eric W. Biederman a écrit :
>> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>>
>>> Le 30/10/2014 19:41, Eric W. Biederman a écrit :
>>>> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>>>>
>>>>> The goal of this serie is to be able to multicast netlink messages with an
>>>>> attribute that identify a peer netns.
>>>>> This is needed by the userland to interpret some informations contained in
>>>>> netlink messages (like IFLA_LINK value, but also some other attributes in case
>>>>> of x-netns netdevice (see also
>>>>> http://thread.gmane.org/gmane.linux.network/315933/focus=316064 and
>>>>> http://thread.gmane.org/gmane.linux.kernel.containers/28301/focus=4239)).
>>>>>
>>>>> Ids of peer netns are set by userland via a new genl messages. These ids are
>>>>> stored per netns and are local (ie only valid in the netns where they are
>>>>> set).
>>>>> To avoid allocating an int for each peer netns, I use idr_for_each() to
>>>>> retrieve
>>>>> the id of a peer netns. Note that it will be possible to add a table
>>>>> (struct net
>>>>> -> id) later to optimize this lookup if needed.
>>>>>
>>>>> Patch 1/4 introduces the netlink API mechanism to set and get these ids.
>>>>> Patch 2/4 and 3/4 implements an example of how to use these ids in rtnetlink
>>>>> messages. And patch 4/4 shows that the netlink messages can be symetric
>>>>> between
>>>>> a GET and a SET.
>>>>>
>>>>> iproute2 patches are available, I can send them on demand.
>>>>
>>>> A quick reply.  I think this patchset is in the right general direction.
>>>> There are some oddball details that seem odd/awkward to me such as using
>>>> genetlink instead of rtnetlink to get and set the ids, and not having
>>>> ids if they are not set (that feels like a maintenance/usability challenge).
>>> No problem to use rtnetlink, in fact, I hesitated.
>>>
>>> For the second point, I'm not sure to follow you: how to have an id, which will
>>> not break migration, without asking the user to set it?
>>
>> We have that situtation with ifindex already.  Basically the thought is
>> to allow an id to be set, but also allow an id to be auto-generated if
>> we use an namespace without an id being set.
> If my understanding is correct, the difference is that we want to hide some
> netns.
> Do you think we can generate an id for each netns that does not have one and
> relying on the fact that this id has no meaning unless you have a netns file
> descriptor that allow you to get the id of this netns?
Any comment Eric ?


Thank you,
Nicolas
