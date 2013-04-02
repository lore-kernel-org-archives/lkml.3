Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761801Ab3DBQ2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:28:18 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:37957 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761761Ab3DBQ2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:28:13 -0400
Message-ID: <515B0718.3060305@atmel.com>
Date: Tue, 2 Apr 2013 18:28:08 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: <dgilbert@interlog.com>, <jhovold@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] rtc: rtc-at91rm9200: manage IMR depending on revision
References: <1364573029-19346-5-git-send-email-jhovold@gmail.com> <1364908007-5150-1-git-send-email-nicolas.ferre@atmel.com> <515AFA0B.7020509@interlog.com>
In-Reply-To: <515AFA0B.7020509@interlog.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 05:32 PM, Douglas Gilbert :
> On 13-04-02 09:06 AM, Nicolas Ferre wrote:
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>> Hi all,
>>
>> The funny thing is that I was writing exactly the same code as Johan's
>> when he posted his series.
>>
>> So, here is my single patch, with the comment about the readback
>> stolen from
>> Johan's, but without the way to determine with IP is buggy and which
>> one is
>> not...
>> After having dug the possibility to read the IP revision, I discovered
>> that it
>> is not possible to use this information ("version" register offset
>> changing
>> according to... IP version number: well done!).
>> In conclusion, I guess that the only way to determine if we need the
>> workaround
>> is to use the DT.
>> One remark though: if we use the compatibility string for this
>> purpose, I fear
>> that we would twist the meaning of this information: SoC using an
>> "atmel,at91sam9x5-rtc" compatible RTC will not necessarily be touched
>> by the
>> "non responding IMR" bug: at91sam9n12 or upcoming sama5d3 are not
>> affected for
>> instance, and we need to cling to "atmel,at91rm9200-rtc" for them...
>> I think that we can use this method for the moment and move to another
>> compatibility string later if it is needed.
> 
> Rather than have so many people working on rtc-at91rm9200.c,
> how about someone bring its "RTT" sibling into the DT
> world. I'm talking about drivers/rtc/rtc-at91sam9.c ...

I am currently trying to fix the issue that I have created by pushing a
boggus fix to Andrew's patch series (and "stable" incidentally).
So I am trying to find the best way to address this and:
- a correct
- a smallest possible
path or patch series (I admit that I prefer a single patch).

So, I am still posting rtc-at91rm9200.c patches and hoping from a
feedback. Once we have a good solution I will try to include it in 3.9
and the stable trees affected.

Best regards,
-- 
Nicolas Ferre
