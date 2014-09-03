Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaICFUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:20:13 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:40270 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaICFUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:20:11 -0400
Message-ID: <5406A4FF.1090209@mentor.com>
Date: Wed, 3 Sep 2014 10:49:59 +0530
From: Harish Jenny Kandiga Nagaraj <harish_kandiga@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <dborkman@redhat.com>, <tgraf@suug.ch>, <ebiederm@xmission.com>,
        <darkjames-ws@darkjames.pl>, <rgb@redhat.com>,
        <eric.dumazet@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] netlink: Safer deletion of sk_bind_node
References: <1409555309-5893-1-git-send-email-harish_kandiga@mentor.com>	<20140901.220325.955861172520355423.davem@davemloft.net>	<54058376.9090700@mentor.com> <20140902.115215.1488500321662046816.davem@davemloft.net>
In-Reply-To: <20140902.115215.1488500321662046816.davem@davemloft.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If that is the case , then subscriptions of netlink_sock should have been updated after netlink_remove or netlink_release.
I don't see that happening.

On Wednesday 03 September 2014 12:22 AM, David Miller wrote:
> From: Harish Jenny Kandiga Nagaraj <harish_kandiga@mentor.com>
> Date: Tue, 2 Sep 2014 14:14:38 +0530
>
>> In one of our random test runs we observed the crash mentioned in the previous mail.
>>
>> After debugging we found out that the call flow of the inline and static functions were
>> netlink_release
>> -----netlink_remove
>> ---------__sk_del_bind_node
>> --------------__hlist_del
>>
>> *pprev was NULL in __hlist_del function while deleting &sk->sk_bind_node hlist_node. Hence the patch was given.
>>
>> In netlink_remove function , first the sk_del_node_init function will be called. This internally calls __sk_del_node_init function. While deleting &sk->sk_node hlist_node using __sk_del_node function there is a NULL check with sk_hashed function.
>>
>> Why there is no NULL check for *pprev while deleting &sk->sk_bind_node ?
> Because if ->subscriptions is non-zero, it must be on a list, and therefore
> pprev must be non-NULL.

