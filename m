Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaAFIRt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 03:17:49 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:48643 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaAFIRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 03:17:47 -0500
Message-ID: <52CA667B.4090606@huawei.com>
Date: Mon, 6 Jan 2014 16:16:59 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: John Fastabend <john.fastabend@gmail.com>
CC: David Miller <davem@davemloft.net>, <edumazet@google.com>,
        <jasowang@redhat.com>, <horms@verge.net.au>, <serge.hallyn@ubuntu.com>,
        <netdev@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <containers@lists.linux-foundation.org>, <kaber@trash.net>,
        <xemul@openvz.org>, <ebiederm@xmission.com>,
        <linux-kernel@vger.kernel.org>, <jhs@mojatatu.com>,
        <lizefan@huawei.com>
Subject: Re: [RFC PATCH net-next 1/4] net: introduce backup_classid to struct
 skbuff
References: <52C62A48.1050604@huawei.com> <20140103.003404.1439874071277993396.davem@davemloft.net> <52C656F2.8060803@gmail.com>
In-Reply-To: <52C656F2.8060803@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/3 14:21, John Fastabend wrote:
> On 01/02/2014 09:34 PM, David Miller wrote:
>> From: Libo Chen <clbchenlibo.chen@huawei.com>
>> Date: Fri, 3 Jan 2014 11:11:04 +0800
>>
>>>
>>> introduce backup_classid to struct skbuff,
>>> we can use it to backup sk_classid when net_ns switch.
>>>
>>> Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
>>
>> Sorry, no new sk_buff members unless there is absolutely not other
>> possible implementation.
>>
>> sk_buff is too big as-is.
> 
> To get what you want fix the dev_forward_skb() call. But its
> not clear to me why you would expect the sock info to be propagated
> like this. It seems like an incorrect assumption or a misunderstanding
> somewhere. If the virtual link was a physical link you wouldn't expect
> to know anything about the senders socket.

AFAIK, once the sock is created, sock->sk_classid will be set, see sk_alloc()
so I think it is safe.

thanks,
Libo

> 
> Thanks,
> John
> 


