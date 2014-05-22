Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaEVUVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:21:41 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:53676 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbaEVUVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:21:40 -0400
Message-ID: <537E5C4D.4040209@mentor.com>
Date: Thu, 22 May 2014 21:21:33 +0100
From: Jim Baxter <jim_baxter@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Vlad Yasevich <vyasevich@gmail.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <kamal@canonical.com>,
        Ben Hutchings <bhutchings@solarflare.com>, <edumazet@google.com>,
        <mszeredi@suse.cz>, <fw@strlen.de>
Subject: Re: skbuff truesize incorrect.
References: <537E4AFD.20304@mentor.com> <537E4F29.9080103@gmail.com>	 <537E526F.8060608@mentor.com> <1400788778.5367.163.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1400788778.5367.163.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 22 May 2014 20:21:36.0330 (UTC) FILETIME=[6E35E2A0:01CF75FB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/05/14 20:59, Eric Dumazet wrote:
> On Thu, 2014-05-22 at 20:39 +0100, Jim Baxter wrote:
> 
>> I now think that the correct solution here is to create a new smaller
>> skb and copy the data from the sub packets into it.
> 
> For low speed devices, this is indeed the best way.
> 
> (this is called copybreak in some nic drivers)
> 
> 
> 
Thank you Eric.

It is USB device that can handle 480Mbits/s so a middle speed device.

It looks like it is the normal trade off of speed versus memory. Either
I can use skb_clone for speed but that will impact memory with multiple
skb's of 16k or I copy the data to keep the memory usage low. Though
copying 2k of data into an skb will not likely be a massive overhead.

Jim
