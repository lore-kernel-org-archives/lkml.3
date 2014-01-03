Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaACGWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 01:22:11 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:34231 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaACGWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 01:22:09 -0500
Message-ID: <52C656F2.8060803@gmail.com>
Date: Thu, 02 Jan 2014 22:21:38 -0800
From: John Fastabend <john.fastabend@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: clbchenlibo.chen@huawei.com
CC: David Miller <davem@davemloft.net>, edumazet@google.com,
        jasowang@redhat.com, horms@verge.net.au, serge.hallyn@ubuntu.com,
        netdev@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, kaber@trash.net,
        xemul@openvz.org, ebiederm@xmission.com, linux-kernel@vger.kernel.org,
        jhs@mojatatu.com, lizefan@huawei.com
Subject: Re: [RFC PATCH net-next 1/4] net: introduce backup_classid to struct
 skbuff
References: <52C62A48.1050604@huawei.com> <20140103.003404.1439874071277993396.davem@davemloft.net>
In-Reply-To: <20140103.003404.1439874071277993396.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 09:34 PM, David Miller wrote:
> From: Libo Chen <clbchenlibo.chen@huawei.com>
> Date: Fri, 3 Jan 2014 11:11:04 +0800
>
>>
>> introduce backup_classid to struct skbuff,
>> we can use it to backup sk_classid when net_ns switch.
>>
>> Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
>
> Sorry, no new sk_buff members unless there is absolutely not other
> possible implementation.
>
> sk_buff is too big as-is.

To get what you want fix the dev_forward_skb() call. But its
not clear to me why you would expect the sock info to be propagated
like this. It seems like an incorrect assumption or a misunderstanding
somewhere. If the virtual link was a physical link you wouldn't expect
to know anything about the senders socket.

Thanks,
John

-- 
John Fastabend         Intel Corporation
