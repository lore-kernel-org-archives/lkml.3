Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbaFLJiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:38:21 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:61985 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932740AbaFLJiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:38:19 -0400
Message-ID: <53997503.7040109@mentor.com>
Date: Thu, 12 Jun 2014 10:38:11 +0100
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
References: <Jim Baxter <jim_baxter@mentor.com>	 <1401383543-10181-1-git-send-email-jim_baxter@mentor.com>	 <1401383543-10181-4-git-send-email-jim_baxter@mentor.com> <1401390263.3645.51.camel@edumazet-glaptop2.roam.corp.google.com> <53886ABC.8030303@mentor.com>
In-Reply-To: <53886ABC.8030303@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 12 Jun 2014 09:38:13.0572 (UTC) FILETIME=[07D93840:01CF8622]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/05/14 12:25, Jim Baxter wrote:
> On 29/05/14 20:04, Eric Dumazet wrote:
>> On Thu, 2014-05-29 at 18:12 +0100, Jim Baxter wrote:
>>
>> Note the patch is OK, but changelog a bit misleading ;)
>>
>> Kernel was not running out of memory, because truesize was correct.
>>
>> The problem here is that a frame was consuming more kernel memory than
>> really needed, so chances of hitting socket sk_rcvbuf limit was high.
>>
>> BTW :
>> #define NTB_OUT_SIZE              16384
>>
>> alloc_skb(size) ->
>> 	kmalloc(16384 + sizeof(struct skb_shared_info)) ->
>> 		roundup() => 32768
>>
>> So truesize of the skb was infact ~32KB, which is really insane indeed.
>> After your patch, its back to ~2KB
>>
>> Acked-by: Eric Dumazet <edumazet@google.com>
>>
>>
>>
> 
> Thank you, I will clarify the description.
> 
> Jim
> 

Hi Eric,

Is this commit log more correct?


This fixes a problem with dropped packets over 16k CDC-NCM
when the connection is being heavily used.

The issue was that the extracted frames cloned from the
received frame were consuming more memory than necessary
due to the truesize being ~32KB instead of ~2KB, this
meant there was a high chance of reaching the sk_rcvbuf
limit.

Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jim Baxter <jim_baxter@mentor.com>

Thank you,
Jim

