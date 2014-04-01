Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaDAKMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:12:18 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:45857 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaDAKMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:12:16 -0400
Message-ID: <533A90F9.3050807@gmail.com>
Date: Tue, 01 Apr 2014 18:12:09 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: ipv6:remove ipv6 global address after the interface is down
References: <533A8737.8050108@gmail.com> <20140401093544.GF24150@order.stressinduktion.org>
In-Reply-To: <20140401093544.GF24150@order.stressinduktion.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 05:35 PM, Hannes Frederic Sowa wrote:
> On Tue, Apr 01, 2014 at 05:30:31PM +0800, zhuyj wrote:
>> Hi, Paul
>>
>> With kernel 2.6.34.x, the following problem will appear.
>>
>>   TargetA ------------------------- TargetB
>> 3000::1/64 3000::2/64
>>
>>   TargetA
>>     - bring the interface down by doing an "ifconfig eth1 down"
>>     - bring the interface back up by doing an "ifconfig eth1 up"
>>
>> TargetB
>>     - ping6 3000::1
>>        ping6 succeeds the first time
>>     - after bringing the interface on TargetA down and then back up,
>> ping6 to the interface fails.
>>
>> With the latest mainline kernel(3.4+), this problem is resolved. When
>> eth1 is down, ipv6 address and route item are removed.
>> But with kernel 2.6.34.x, when eth1 is down, ipv6 address remains while
>> route item is removed.
>>
>> So when eth1 is up and assign the previous ipv6 address, with 2.6.34.x,
>> some errors will appear. But with latest mainline kernel, it can work well.
>>
>> So I made a patch to fix this problem in kernel 2.6.34.x. Please merge
>> this to kernel2.6.34.x.
> 2.6.34 stable is EOL and won't get updated anymore. If this is problem is also
> present in other, still maintained, stable kernel this would be possible.
Hi, Hannes

It is fortunate. I checked other stable kernel. They can work well. 
Maybe this patch can only fix the problem on 2.6.34.x.

>
> Can you identify the upstream commit which repaired this problem and when it
> got introduced?
commit 73a8bd74 [ipv6:Revert 'administrative down' address handling 
changes] can fix this problem.

Best Regards!
Zhu Yanjun
>
> Thanks,
>
>    Hannes
>
>

