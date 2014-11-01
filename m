Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbaKAVIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 17:08:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56116 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759284AbaKAVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 17:08:18 -0400
Date: Sat, 01 Nov 2014 17:08:12 -0400 (EDT)
Message-Id: <20141101.170812.1034370067621331861.davem@davemloft.net>
To: ebiederm@xmission.com
Cc: nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, stephen@networkplumber.org,
        akpm@linux-foundation.org, luto@amacapital.net, cwang@twopensource.com
Subject: Re: [PATCH net-next v4 0/4] netns: allow to identify peer netns
From: David Miller <davem@davemloft.net>
In-Reply-To: <871tpph03k.fsf@x220.int.ebiederm.org>
References: <1412257690-31253-1-git-send-email-nicolas.dichtel@6wind.com>
	<1414682728-4532-1-git-send-email-nicolas.dichtel@6wind.com>
	<871tpph03k.fsf@x220.int.ebiederm.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 01 Nov 2014 14:08:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 30 Oct 2014 11:41:03 -0700

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

I'm going to mark this patch set 'deferred' in patchwork until things
move forward.

Thanks.
