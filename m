Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaCLSuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:50:04 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:39082 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaCLSuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:50:01 -0400
X-IronPort-AV: E=Sophos;i="4.97,639,1389744000"; 
   d="scan'208";a="109293435"
Message-ID: <5320AC3B.5090704@citrix.com>
Date: Wed, 12 Mar 2014 18:49:31 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>, David Miller <davem@davemloft.net>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>, <andrew.bennieston@citrix.com>
Subject: Re: [PATCH net-next v7 0/9] xen-netback: TX grant mapping with SKBTX_DEV_ZEROCOPY
 instead of copy
References: <1394142511-14827-1-git-send-email-zoltan.kiss@citrix.com>	 <20140307.160552.282750558679341658.davem@davemloft.net>	 <531B2B3E.5050800@citrix.com>	 <20140308.185759.494043114567727021.davem@davemloft.net> <1394638843.3457.11.camel@kazak.uk.xensource.com>
In-Reply-To: <1394638843.3457.11.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/14 15:40, Ian Campbell wrote:
> On Sat, 2014-03-08 at 18:57 -0500, David Miller wrote:
>> From: Zoltan Kiss <zoltan.kiss@citrix.com>
>> Date: Sat, 8 Mar 2014 14:37:50 +0000
>>
>>> Maybe you mixed up mine with that? But that's also not eligible to be
>>> applied yet.
>>
>> I can always revert the series if there are major objections.
>
> Zoltan -- does this patch series suffer from/expose the confusion
> regarding RING_HAS_UNCONSUMED_REQUESTS which we are discussing
> separately on xen-devel? If the answer is yes then I think this series
> should be reverted for the time being because there seems to be some
> fairly fundamental questions about the semantics of that macro.
I haven't seen it causing any issue during my testing, although it went 
through several XenRT nighlies. That topic 
("RING_HAS_UNCONSUMED_REQUESTS oddness" on xen-devel) came from 
theoretical grounds. One outcome of it is that we should move that 
napi_schedule from the callback to the end of the dealloc thread to be 
on the safe side. I can post a short patch for that.

>
> If the answer is no then I will endeavour to review this version of the
> series ASAP (hopefully tomorrow) and determine if I have any other major
> objections which would warrant a revert.
>
> Ian.
>

