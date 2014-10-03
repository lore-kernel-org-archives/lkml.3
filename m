Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaJCMWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 08:22:35 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46688 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaJCMW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 08:22:29 -0400
Message-ID: <542E9502.1040104@6wind.com>
Date: Fri, 03 Oct 2014 14:22:26 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        davem@davemloft.net, stephen@networkplumber.org,
        akpm@linux-foundation.org, luto@amacapital.net, cwang@twopensource.com
Subject: Re: [RFC PATCH net-next v3 1/4] netns: add genl cmd to add and get
 peer netns ids
References: <542D5726.8070308@6wind.com>	<1412257690-31253-1-git-send-email-nicolas.dichtel@6wind.com>	<1412257690-31253-2-git-send-email-nicolas.dichtel@6wind.com> <87tx3mmflp.fsf@x220.int.ebiederm.org>
In-Reply-To: <87tx3mmflp.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/10/2014 21:33, Eric W. Biederman a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>
>> With this patch, a user can define an id for a peer netns by providing a FD or a
>> PID. These ids are local to netns (ie valid only into one netns).
>>
>> This will be useful for netlink messages when a x-netns interface is
>> dumped.
>
> You have a "id -> struct net *" table but you don't have a
> "struct net * -> id" table which looks like it will impact the
> performance of peernet2id at scale.
It is indirectly stores in 'struct idr'. It can be optimized later, with a
proper algorithm to find quickly this 'struct net *' (hash table? something
else?). A basic algorithm will not be more scalable than the current
idr_for_each().
