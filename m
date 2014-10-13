Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbaJMIUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:20:50 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:37793 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbaJMIUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:20:47 -0400
Message-ID: <543B8B57.80108@gmail.com>
Date: Mon, 13 Oct 2014 16:20:39 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Cong Wang <cwang@twopensource.com>
CC: "David S. Miller" <davem@davemloft.net>, Hong Zhiguo <honkiko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "Tao, Yue" <Yue.Tao@windriver.com>,
        Alexandre Dietsch <alexandre.dietsch@windriver.com>,
        zhuyj <zyjzyj2000@gmail.com>
Subject: Re: ipv4: net namespace does not inherit network configurations
References: <53D7697C.6020103@gmail.com> <CAHA+R7MC2gKeSWqR8pDDX26D-Th4BG1AveM+HseMMPjLBJuWDw@mail.gmail.com>
In-Reply-To: <CAHA+R7MC2gKeSWqR8pDDX26D-Th4BG1AveM+HseMMPjLBJuWDw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Miller && Cong

Can we merge this patch into kernel mainline? since the independence
between ipv4 and ipv6 is inconsistent even in the latest linux 
kernel(3.17-rc7),
that is, the net namespace is independent in ipv6 while it is not in ipv4.

Thanks a lot.
Zhu Yanjun

On 07/30/2014 01:48 AM, Cong Wang wrote:
> On Tue, Jul 29, 2014 at 2:29 AM, zhuyj <zyjzyj2000@gmail.com> wrote:
>> Hi,all
>>
>> I did a test on kernel3.16 rc6:
>>
>> root@qemu1:~# echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
>> root@qemu1:~# echo 1 > /proc/sys/net/ipv4/conf/all/forwarding
>> root@qemu1:~# ip netns list
>> root@qemu1:~# ip netns add fib1
>> root@qemu1:~# ip netns exec fib1 bash
>> root@qemu1:~# cat /proc/sys/net/ipv6/conf/all/forwarding
>> 0
>> root@qemu1:~# cat /proc/sys/net/ipv4/conf/all/forwarding
>> 1
>>
>> The behavior of ipv4 and ipv6 is very inconsistent. I checked
>> the kernel source code. I found that from this patch
>> [ipv6: fix bad free of addrconf_init_net], the above difference
>> appeared.
>>
>> Since a net namespace is independent to another. That is, there
>> is no any relationship between the net namespaces. So the behavior
>> of ipv4 is not correct.
>>
> Well, they are already independent, not shared, just that the initial
> value is duplicated from init_net for IPv4.
>
> This change might break existing applications which rely on this
> behavior, but given IPv6 change is almost the same, I think it's ok.
>
> BTW, you need to submit a patch as normal, instead of as an attachment.
>

