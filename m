Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbaLCCAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:00:09 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:18974 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750730AbaLCCAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:00:08 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44386951"
Message-ID: <547E6F8C.1060709@cn.fujitsu.com>
Date: Wed, 3 Dec 2014 10:03:56 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: <paulmck@linux.vnet.ibm.com>
CC: =?UTF-8?B?RMOibmllbCBGcmFnYQ==?= <fragabr@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <CA+55aFy9c2FY2gDw14VU537QJoLHAbf+q_75VUwU33_HLz+F0w@mail.gmail.com>	<20141126024032.GA13246@redhat.com>	<20141126225745.GA30346@redhat.com>	<CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>	<20141127225637.GA24019@redhat.com>	<m5dart$co$1@ger.gmane.org>	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>	<547b8a45.6e608c0a.20f9.1002@mx.google.com>	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>	<547bbe36.48548c0a.105c.779c@mx.google.com>	<20141201191431.GA17385@linux.vnet.ibm.com>	<547D7B05.6080403@cn.fujitsu.com> <547defc3.28568c0a.73eb.1a1e@mx.google.com>
In-Reply-To: <547defc3.28568c0a.73eb.1a1e@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 12:58 AM, Dâniel Fraga wrote:
> On Tue, 2 Dec 2014 16:40:37 +0800
> Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
>> It is needed at lest for testing.
>>
>> CONFIG_TREE_PREEMPT_RCU=y with CONFIG_PREEMPT=n is needed for testing too.
>>
>> Please enable them (or enable them under CONFIG_RCU_TRACE=y)
> 
> 	Lai, sorry but I didn't understand. Do you mean both of them
> enabled? Because how can CONFIG_TREE_PREEMPT_RCU be enabled without
> CONFIG_PREEMPT ?


Sorry, I replied to Paul, and my reply was off-topic, it has nothing
related your reports. Sorry again.

I think we need two combinations for testing (not mainline, but I think
they (combinations) should be enabled for test farms).

So I hope Paul enable them (combinations).

combination1: CONFIG_TREE_PREEMPT_RCU=n & CONFIG_PREEMPT=y
combination2: CONFIG_TREE_PREEMPT_RCU=y & CONFIG_PREEMPT=n

The core code should work correctly in these combinations.
I agree with Paul that these combinations should not be enabled in production,
So my request is: enable these combinations under CONFIG_RCU_TRACE
or CONFIG_TREE_RCU_TRACE.

For myself, I always edit the Kconfig directly, thus it is not a problem
for me.  But there is no way for test farms to test these combinations.

Thanks,
Lai

> 
> 	If you mean both enabled, I already reported a call trace with
> both enabled:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=85941
> 
> 	Please see my previous answer to Linus and Paul too.
> 
> 	Regarding CONFIG_RCU_TRACE, do you mean
> "CONFIG_TREE_RCU_TRACE"? I couldn't find CONFIG_RCU_TRACE.
> 
> 	Thanks.
> 

