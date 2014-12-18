Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345AbaLROiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:38:11 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:52235 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaLROiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:38:10 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412170935480.2047@gentwo.org>
References: <20141210163017.092096069@linux.com>
	<20141215075933.GD4898@js1304-P5Q-DELUXE>
	<CAAmzW4NCpx5aJyW36fgOfu3EaDj6=uv6MUiBC+a0ggePWPXndQ@mail.gmail.com>
	<alpine.DEB.2.11.1412170935480.2047@gentwo.org>
Date: Thu, 18 Dec 2014 23:38:09 +0900
Message-ID: <CAAmzW4Oyw974Zg274C2-1BcOphEJY63gx7v2QTQuULOJBzknig@mail.gmail.com>
Subject: Re: [PATCH 0/7] slub: Fastpath optimization (especially for RT) V1
From: Joonsoo Kim <js1304@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, akpm@linuxfoundation.org,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-18 0:36 GMT+09:00 Christoph Lameter <cl@linux.com>:
> On Wed, 17 Dec 2014, Joonsoo Kim wrote:
>
>> Ping... and I found another way to remove preempt_disable/enable
>> without complex changes.
>>
>> What we want to ensure is getting tid and kmem_cache_cpu
>> on the same cpu. We can achieve that goal with below condition loop.
>>
>> I ran Jesper's benchmark and saw 3~5% win in a fast-path loop over
>> kmem_cache_alloc+free in CONFIG_PREEMPT.
>>
>> 14.5 ns -> 13.8 ns
>>
>> See following patch.
>
> Good idea. How does this affect the !CONFIG_PREEMPT case?

One more this_cpu_xxx makes fastpath slow if !CONFIG_PREEMPT.
Roughly 3~5%.

We can deal with each cases separately although it looks dirty.

#ifdef CONFIG_PREEMPT
XXX
#else
YYY
#endif

Thanks.
