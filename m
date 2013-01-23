Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab3AWJ0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:26:47 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:33356 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab3AWJ0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:26:46 -0500
Message-ID: <50FFACC5.7060405@linux.vnet.ibm.com>
Date: Wed, 23 Jan 2013 17:26:29 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com> <50FCCCF5.30504@linux.vnet.ibm.com> <1358750523.4994.55.camel@marge.simpson.net> <1358752180.4994.65.camel@marge.simpson.net> <50FCF212.3010504@linux.vnet.ibm.com> <1358759355.4994.108.camel@marge.simpson.net> <50FD08E1.8000302@linux.vnet.ibm.com> <1358761496.4994.118.camel@marge.simpson.net> <50FE0ADC.6060701@linux.vnet.ibm.com> <1358841795.5782.255.camel@marge.simpson.net> <50FE5433.1070801@linux.vnet.ibm.com> <1358865692.5782.420.camel@marge.simpson.net> <50FF4EA0.1070000@linux.vnet.ibm.com> <1358915494.5752.46.camel@marge.simpson.net> <50FF7086.4020509@linux.vnet.ibm.com> <1358922520.5752.91.camel@marge.simpson.net> <50FF8CD8.4060105@linux.vnet.ibm.com>	 <1358929257.5752.109.camel@marge.simp! son.net>	 <50FF9F92.60202@linux.vnet.ibm.com> <1358930968.5752.123.camel@marge.simpson.net> <50FFA695.6010407@linux.vnet.ibm.com> <1358932694.5752.126.camel@marge.simpson.net>
In-Reply-To: <1358932694.5752.126.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012309-1396-0000-0000-000002744F2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 05:18 PM, Mike Galbraith wrote:
> On Wed, 2013-01-23 at 17:00 +0800, Michael Wang wrote: 
>> On 01/23/2013 04:49 PM, Mike Galbraith wrote:
>>> On Wed, 2013-01-23 at 16:30 +0800, Michael Wang wrote: 
>>>> On 01/23/2013 04:20 PM, Mike Galbraith wrote:
>>>>> On Wed, 2013-01-23 at 15:10 +0800, Michael Wang wrote: 
>>>>>> On 01/23/2013 02:28 PM, Mike Galbraith wrote:
>>>>>
>>>>>>> Abbreviated test run:
>>>>>>> Tasks    jobs/min  jti  jobs/min/task      real       cpu
>>>>>>>   640   158044.01   81       246.9438     24.54    577.66   Wed Jan 23 07:14:33 2013
>>>>>>>  1280    50434.33   39        39.4018    153.80   5737.57   Wed Jan 23 07:17:07 2013
>>>>>>>  2560    47214.07   34        18.4430    328.58  12715.56   Wed Jan 23 07:22:36 2013
>>>>>>
>>>>>> So still not works... and not going to balance path while waking up will
>>>>>> fix it, looks like that's the only choice if no error on balance path
>>>>>> could be found...benchmark wins again, I'm feeling bad...
>>>>>>
>>>>>> I will conclude the info we collected and make a v3 later.
>>>>>
>>>>> FWIW, I hacked virgin to do full balance if an idle CPU was not found,
>>>>> leaving the preference to wake cache affine intact though, turned on
>>>>> WAKE_BALANCE in all domains, and it did not collapse.  In fact, the high
>>>>> load end, where the idle search will frequently be a waste of cycles,
>>>>> actually improved a bit.  Things that make ya go hmmm.
>>>>
>>>> Oh, does that means the old balance path is good while the new is really
>>>> broken, I mean, compared this with the previously results, could we say
>>>> that all the collapse was just caused by the change of balance path?
>>>
>>> That's a good supposition.  I'll see if it holds.
>>
>> I just notice that there is no sd support the WAKE flag at all according
>> to your debug info, isn't it?
> 
> There is, I turned it on in all domains.

So is the debug info show the changes? May be I missed some timing which
need to rebuild the sbm.

Regards,
Michael Wang

> 
> -Mike
> 

