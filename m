Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3B1Iip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:38:45 -0500
Received: from mga14.intel.com ([143.182.124.37]:47928 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab3B1Iin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:38:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,754,1355126400"; 
   d="scan'208";a="207220957"
Message-ID: <512F178D.5090601@linux.intel.com>
Date: Thu, 28 Feb 2013 10:38:37 +0200
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Rick Jones <rick.jones2@hp.com>,
        Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [RFC PATCH 0/5] net: low latency Ethernet device polling
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com> <512E654A.2010209@hp.com> <512E6F23.3090003@linux.intel.com> <512E7DD1.1010209@candelatech.com>
In-Reply-To: <512E7DD1.1010209@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/2013 23:42, Ben Greear wrote:
> On 02/27/2013 12:40 PM, Eliezer Tamir wrote:
>> On 27/02/2013 21:58, Rick Jones wrote:
>>> On 02/27/2013 09:55 AM, Eliezer Tamir wrote:
>>>> *rx-usecs=0 is usually not useful in a production environment.
>>>
>>> I would think that latency-sensitive folks would be using rx-usecs=0 in
>>> production - at least if the NIC in use didn't have low enough latency
>>> with its default interrupt coalescing/avoidance heuristics.
>>
>> It will only work well if you have no bulk traffic on the same port as
>> the low latency traffic at all.
>
> Have you done any tests for bulk throughput with busy-poll?  Yes, it
> will eat a core,
> but that might be worth it in some cases if there was significant
> throughput increase...

My impression was that most bulk use cases are handled exceptionally 
well by napi along with some kind of adaptive moderation scheme, esp. if 
you compare to cases where napi is not being used.

If you can recommend a specific use case where busy polling will be an 
advantage for bulk traffic, I will happily try it out.

Thanks,
Eliezer
