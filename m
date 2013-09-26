Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab3IZSDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:03:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29676 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab3IZSDt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:03:49 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <524467CC.7040908@citrix.com>
References: <1378325465-10384-1-git-send-email-zoltan.kiss@citrix.com> <5239CF01.1010001@citrix.com> <20130925175649.GC7253@phenom.dumpdata.com> <524467CC.7040908@citrix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCHv2] tracing/events: Add bounce tracing to swiotbl
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 26 Sep 2013 14:03:25 -0400
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Message-ID: <ce4d1787-5f83-4710-9f88-9349620eda28@email.android.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
>On 25/09/13 18:56, Konrad Rzeszutek Wilk wrote:
>> On Wed, Sep 18, 2013 at 05:04:17PM +0100, Zoltan Kiss wrote:
>>> Hi,
>>>
>>> I haven't got a reply in the past 2 weeks, so I would like to bump
>>> the patch, just to make sure it haven't fell off the radar.
>>
>> Hey,
>>
>> I have this in my queue to put on 3.13 as it is past the merge
>window.
>> .. with that in mind:
>>
>>
>> .. snip..
>>>> +	TP_printk("dev_name: %s dma_mask=%llx dev_addr=%llx "
>>>> +		"size=%zu swiotlb_force=%x",
>>>> +		__get_str(dev_name),
>>>> +		__entry->dma_mask,
>>>> +		(unsigned long long)__entry->dev_addr,
>>>> +		__entry->size,
>>>> +		__entry->swiotlb_force)
>>
>> Would it make sense to do something like this:
>>
>> 		__entry->swiotlb_force ? "swiotlb_force" : "")
>>
>
>I would then rather do:
>
>+	TP_printk("dev_name: %s dma_mask=%llx dev_addr=%llx "
>+		"size=%zu swiotlb_force=",
>+               __entry->swiotlb_force ? " yes" : "no",
>+		__get_str(dev_name),
>
>Or do you mean?:
>
>+	TP_printk("dev_name: %s dma_mask=%llx dev_addr=%llx "
>+		"size=%zu",
>+               __entry->swiotlb_force ? " swiotlb_force" : "",
>+		__get_str(dev_name),
>
>This one doesn't tell you explicitly if swiotlb_force is NOT set, maybe
>
>that's not so good? And adds a bit of complexity to your grep regexp?
>Either way is fine with me, but I think "swiotlb_force=0|1" is also 
>pretty straightforward to understand, and I guess it makes printk 
>slightly faster (I assume the conditional operator gives a little bit
>of 
>overhead)
>
>Regards,
>
>Zoli

I was thinking it would be good to print the swiotlb-force only when it is enabled. So your second one would be it. 
