Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaL3Oq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 09:46:58 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:13057 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbaL3Oq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 09:46:57 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-ca-54a2bade3db6
Message-id: <54A2BADB.4090105@partner.samsung.com>
Date: Tue, 30 Dec 2014 17:46:51 +0300
From: Safonov Dmitry <d.safonov@partner.samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Stefan I. Strogin" <s.strogin@partner.samsung.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        SeongJae Park <sj38.park@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>,
        Minchan Kim <minchan@kernel.org>, Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Subject: Re: [PATCH 3/3] cma: add functions to get region pages counters
References: <cover.1419602920.git.s.strogin@partner.samsung.com>
 <dfddb08aba9a05e6e7b43e9861ab09b7ac1c89cd.1419602920.git.s.strogin@partner.samsung.com>
 <20141230022625.GA4588@js1304-P5Q-DELUXE> <xa1th9wdtd32.fsf@mina86.com>
In-reply-to: <xa1th9wdtd32.fsf@mina86.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t/xy7r3di0KMXjz38hizvo1bBaPX89j
	sfi08imbxcruZjaL7Z0z2C06Jy5ht7i8aw6bxb01/1kt1h65y26x4HgLq8Wyr+/ZLfq+H2a3
	mDxbyuLbyTnMFtd29DNZTJ3xg93i5IazrBYbmrkchDwu9/UyeeycdZfdY3bHTFaPTas62Tw2
	fZrE7tH19gqTx4kZv1k8HhzazOKx7s8rJo+D7/YwefRtWcXo8XmTnEfXxl+sAbxRXDYpqTmZ
	ZalF+nYJXBmbe6+yFFxnr7j1+SBLA2MPWxcjJ4eEgInEywnHWCFsMYkL99YDxbk4hASWMkoc
	ndLAAuF8ZJS4fvEQM0gVr4CRxITPq4ASHBwsAqoSz1rDQUw2oEHzmmNAKkQFIiQ+rPrKBlEt
	KPFj8j2wMSICHYwS/9fuYgRxmAWmskic+PqBEaRKWMBDYvPVR2AdQgJPGCVmPHUCsTkFtCS2
	9f5kB7GZBcwkvrw8zAphy0tsXvOWeQKjwCwkS2YhKZuFpGwBI/MqRtHU0uSC4qT0XCO94sTc
	4tK8dL3k/NxNjJAI/bqDcekxq0OMAhyMSjy8G94vDBFiTSwrrsw9xCjBwawkwttosChEiDcl
	sbIqtSg/vqg0J7X4ECMTB6dUA+O+Hq/LaxTksyNDv23/ujx68t2pBdkNXH96Vmoz+RacfhK1
	ym2umsnZBXumzjBLMds2ZfKq19bO91ZzPwvdktG/8PO8FW2b2JyPB6qlnbXL9d/FV/q+9Sa7
	ynfuxdJqZZPn7vn+vuHkm96jTz08i5rObOm/x77e5rXx4dpbBrXhc99PXnSoeL6/EktxRqKh
	FnNRcSIANFppzq4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/30/2014 05:41 PM, Michal Nazarewicz wrote:
>> On Fri, Dec 26, 2014 at 05:39:04PM +0300, Stefan I. Strogin wrote:
>>> From: Dmitry Safonov <d.safonov@partner.samsung.com>
>>> @@ -591,6 +621,10 @@ static int s_show(struct seq_file *m, void *p)
>>>   	struct cma_buffer *cmabuf;
>>>   	struct stack_trace trace;
>>>   
>>> +	seq_printf(m, "CMARegion stat: %8lu kB total, %8lu kB used, %8lu kB max contiguous chunk\n\n",
>>> +		   cma_get_size(cma) >> 10,
>>> +		   cma_get_used(cma) >> 10,
>>> +		   cma_get_maxchunk(cma) >> 10);
>>>   	mutex_lock(&cma->list_lock);
>>>   
>>>   	list_for_each_entry(cmabuf, &cma->buffers_list, list) {
> On Tue, Dec 30 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
>> How about changing printing format like as meminfo or zoneinfo?
>>
>> CMARegion #
>> Total: XXX
>> Used: YYY
>> MaxContig: ZZZ
> +1.  I was also thinking about this actually.
>
Yeah, I thought about it. Sure.

-- 
Best regards,
Safonov Dmitry.

