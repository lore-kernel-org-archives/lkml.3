Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935222Ab3GSC0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 22:26:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:4710 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935116Ab3GSC0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 22:26:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,697,1367996400"; 
   d="scan'208";a="333641510"
Message-ID: <51E8A3CA.7010104@intel.com>
Date: Fri, 19 Jul 2013 10:26:18 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf, x86: Add Silvermont (22nm Atom) support
References: <1374125767-9411-1-git-send-email-zheng.z.yan@intel.com> <20130718082324.GA27075@twins.programming.kicks-ass.net> <51E7A6F3.10109@intel.com>
In-Reply-To: <51E7A6F3.10109@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 04:27 PM, Yan, Zheng wrote:
> On 07/18/2013 04:23 PM, Peter Zijlstra wrote:
>> On Thu, Jul 18, 2013 at 01:36:07PM +0800, Yan, Zheng wrote:
>>> +static struct event_constraint intel_slm_event_constraints[] __read_mostly =
>>> +{
>>> +	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
>>> +	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
>>> +	FIXED_EVENT_CONSTRAINT(0x013c, 2), /* CPU_CLK_UNHALTED.REF */
>>> +	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* pseudo CPU_CLK_UNHALTED.REF */
>>
>> So the normal event 0x13c and the fixed counter 2 are normally _not_ the
>> same. Are they for slm? Are you sure?
>>
> 
> yes, I'm sure. see page 15-15 of http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-optimization-manual.pdf
> 

I'm sorry, I was wrong.

---
perf stat -e ref-cycles -e cpu/config=0x013c/ sleep 1

 Performance counter stats for 'sleep 1':

         1,181,220 ref-cycles                                                  
            98,434 cpu/config=0x013c/                                          

       0.196653863 seconds time elapsed



