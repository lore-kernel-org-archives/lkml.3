Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbaJaJld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:41:33 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:62406 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014AbaJaJla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:41:30 -0400
Message-ID: <54535944.6050405@6wind.com>
Date: Fri, 31 Oct 2014 10:41:24 +0100
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
Subject: Re: [PATCH net-next v4 1/4] netns: add genl cmd to add and get peer
 netns ids
References: <1412257690-31253-1-git-send-email-nicolas.dichtel@6wind.com>	<1414682728-4532-1-git-send-email-nicolas.dichtel@6wind.com>	<1414682728-4532-2-git-send-email-nicolas.dichtel@6wind.com> <874mulh0cs.fsf@x220.int.ebiederm.org>
In-Reply-To: <874mulh0cs.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 30/10/2014 19:35, Eric W. Biederman a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>
>> With this patch, a user can define an id for a peer netns by providing a FD or a
>> PID. These ids are local to netns (ie valid only into one netns).
>
> Scratches head.  Do you actually find value in using the pid instead of
> a file descriptor?
I copied the mechanism from rtnl_link_get_net():
First check if the user provides a PID, if not, check for a FD.

>
> Doing things by pid was an early attempt to make things work, and has
> been a bit clutsy.  If you don't find value in it I would recommend just
> supporting getting/setting the network namespace by file descriptor.
Hmm, if I understand well, it's what is done in the patch:

[snip]
>> +static int netns_nl_cmd_newid(struct sk_buff *skb, struct genl_info *info)
>> +{
[snip]
>> +	if (info->attrs[NETNSA_PID])
>> +		peer = get_net_ns_by_pid(nla_get_u32(info->attrs[NETNSA_PID]));
>> +	else if (info->attrs[NETNSA_FD])
>> +		peer = get_net_ns_by_fd(nla_get_u32(info->attrs[NETNSA_FD]));
>> +	else
>> +		return -EINVAL;
>> +	if (IS_ERR(peer))
>> +		return PTR_ERR(peer);

Am I right?


Regards,
Nicolas
