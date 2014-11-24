Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaKXNpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:45:54 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:46509 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbaKXNpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:45:51 -0500
Message-ID: <5473368C.5040409@6wind.com>
Date: Mon, 24 Nov 2014 14:45:48 +0100
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        davem@davemloft.net, stephen@networkplumber.org,
        akpm@linux-foundation.org, luto@amacapital.net, cwang@twopensource.com
Subject: Re: [PATCH net-next v4 0/4] netns: allow to identify peer netns
References: <1412257690-31253-1-git-send-email-nicolas.dichtel@6wind.com>	<1414682728-4532-1-git-send-email-nicolas.dichtel@6wind.com> <871tpph03k.fsf@x220.int.ebiederm.org>
In-Reply-To: <871tpph03k.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 30/10/2014 19:41, Eric W. Biederman a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>
>> The goal of this serie is to be able to multicast netlink messages with an
>> attribute that identify a peer netns.
>> This is needed by the userland to interpret some informations contained in
>> netlink messages (like IFLA_LINK value, but also some other attributes in case
>> of x-netns netdevice (see also
>> http://thread.gmane.org/gmane.linux.network/315933/focus=316064 and
>> http://thread.gmane.org/gmane.linux.kernel.containers/28301/focus=4239)).
>>
>> Ids of peer netns are set by userland via a new genl messages. These ids are
>> stored per netns and are local (ie only valid in the netns where they are set).
>> To avoid allocating an int for each peer netns, I use idr_for_each() to retrieve
>> the id of a peer netns. Note that it will be possible to add a table (struct net
>> -> id) later to optimize this lookup if needed.
>>
>> Patch 1/4 introduces the netlink API mechanism to set and get these ids.
>> Patch 2/4 and 3/4 implements an example of how to use these ids in rtnetlink
>> messages. And patch 4/4 shows that the netlink messages can be symetric between
>> a GET and a SET.
>>
>> iproute2 patches are available, I can send them on demand.
>
> A quick reply.  I think this patchset is in the right general direction.
> There are some oddball details that seem odd/awkward to me such as using
> genetlink instead of rtnetlink to get and set the ids, and not having
> ids if they are not set (that feels like a maintenance/usability challenge).
>
> I would like to give your patches a deep review, but I won't be able to
> do that for a couple of weeks.  I am deep in the process of moving,
> and will be mostly offline until about the Nov 11th.
Eric, did you have a chance to look at this?


Regards,
Nicolas
