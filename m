Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaJ0BJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:09:34 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:49170 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbaJ0BJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:09:32 -0400
Message-ID: <544D9B00.4040603@huawei.com>
Date: Mon, 27 Oct 2014 09:08:16 +0800
From: "Zhangjie (HZ)" <zhangjie14@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rick Jones <rick.jones2@hp.com>, <kvm@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <liuyongan@huawei.com>,
        <qinchuanyu@huawei.com>
Subject: Re: [QA-TCP] How to send tcp small packages immediately?
References: <544A029D.3080508@huawei.com> <544A6E12.2000007@hp.com>
In-Reply-To: <544A6E12.2000007@hp.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.210]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A02020A.544D9B4A.0200,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: d4a094dc43a23fd7176f2f39766b4969
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks!
On 2014/10/24 23:19, Rick Jones wrote:
> On 10/24/2014 12:41 AM, Zhangjie (HZ) wrote:
>> Hi,
>>
>> I use netperf to test the performance of small tcp package, with TCP_NODELAY set :
>>
>> netperf -H 129.9.7.164 -l 100 -- -m 512 -D
>>
>> Among the packages I got by tcpdump, there is not only small packages, also lost of
>> big ones (skb->len=65160).
>>
>> IP 129.9.7.186.60840 > 129.9.7.164.34607: tcp 65160
>> IP 129.9.7.164.34607 > 129.9.7.186.60840: tcp 0
>> IP 129.9.7.164.34607 > 129.9.7.186.60840: tcp 0
>> IP 129.9.7.164.34607 > 129.9.7.186.60840: tcp 0
>> IP 129.9.7.186.60840 > 129.9.7.164.34607: tcp 65160
>> IP 129.9.7.164.34607 > 129.9.7.186.60840: tcp 0
>> IP 129.9.7.164.34607 > 129.9.7.186.60840: tcp 0
>> IP 129.9.7.164.34607 > 129.9.7.186.60840: tcp 0
>> IP 129.9.7.186.60840 > 129.9.7.164.34607: tcp 80
>> IP 129.9.7.186.60840 > 129.9.7.164.34607: tcp 512
>> IP 129.9.7.186.60840 > 129.9.7.164.34607: tcp 512
>>
>> SO, how to test small tcp packages? Including TCP_NODELAY, What else should be set?
> 
> Well, I don't think there is anything else you can set.  Even with TCP_NODELAY set, segment size with TCP will still be controlled by factors such as congestion window.
> 
> I am ass-u-me-ing your packet trace is at the sender.  I suppose if your sender were fast enough compared to the path that might combine with congestion window to result in the very large segments.
> 
> Not to say there cannot be a bug somewhere with TSO overriding TCP_NODELAY, but in broad terms, even TCP_NODELAY does not guarantee small TCP segments.  That has been something of a bane on my attempts to use TCP for aggregate small-packet performance measurements via netperf for quite some time.
> 
> And since you seem to have included a virtualization mailing list I would also ass-u-me that virtualization is involved somehow.  Knuth only knows how that will affect the timing of events, which will be very much involved in matters of congestion window and such.  I suppose it is even possible that if the packet trace is on a VM receiver that some delays in getting the VM running could mean that GRO would end-up making large segments being pushed up the stack.
> 
> happy benchmarking,
Yes. Using netperf to send tcp packages frome physical nic has the same problems.
Thanks for your explanation!
> 
> rick jones
> .
> 

-- 
Best Wishes!
Zhang Jie

