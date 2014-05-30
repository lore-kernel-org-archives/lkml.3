Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbaE3LZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 07:25:55 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:38266 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaE3LZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 07:25:53 -0400
Message-ID: <53886ABC.8030303@mentor.com>
Date: Fri, 30 May 2014 12:25:48 +0100
From: Jim Baxter <jim_baxter@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QmrDuA==?= =?UTF-8?B?cm4gTW9yaw==?= <bjorn@mork.no>,
        David Laight <David.Laight@ACULAB.COM>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 3/3] usb: gadget: NCM: Stop RX TCP Bursts getting dropped.
References: <Jim Baxter <jim_baxter@mentor.com>	 <1401383543-10181-1-git-send-email-jim_baxter@mentor.com>	 <1401383543-10181-4-git-send-email-jim_baxter@mentor.com> <1401390263.3645.51.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1401390263.3645.51.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 30 May 2014 11:25:50.0915 (UTC) FILETIME=[E95AD130:01CF7BF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/14 20:04, Eric Dumazet wrote:
> On Thu, 2014-05-29 at 18:12 +0100, Jim Baxter wrote:
>> This fixes a problem with dropped packets over 16k CDC-NCM
>> when the connection is being heavily used.
>>
>> The issue was that the skb truesize for the unpacked NCM
>> packets was too high after they were cloned from the 16k
>> skb, this lead to the potential memory calculated by the
>> Kernel running out of memory earlier then it should.
>>
>> Signed-off-by: Jim Baxter <jim_baxter@mentor.com>
>> ---
> 
> Note the patch is OK, but changelog a bit misleading ;)
> 
> Kernel was not running out of memory, because truesize was correct.
> 
> The problem here is that a frame was consuming more kernel memory than
> really needed, so chances of hitting socket sk_rcvbuf limit was high.
> 
> BTW :
> #define NTB_OUT_SIZE              16384
> 
> alloc_skb(size) ->
> 	kmalloc(16384 + sizeof(struct skb_shared_info)) ->
> 		roundup() => 32768
> 
> So truesize of the skb was infact ~32KB, which is really insane indeed.
> After your patch, its back to ~2KB
> 
> Acked-by: Eric Dumazet <edumazet@google.com>
> 
> 
> 

Thank you, I will clarify the description.

Jim

