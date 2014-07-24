Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbaGXA5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 20:57:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:20117 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756474AbaGXA5I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 20:57:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,720,1400050800"; 
   d="scan'208";a="566329927"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH v7 03/10] x86, mpx: add macro cpu_has_mpx
Thread-Topic: [PATCH v7 03/10] x86, mpx: add macro cpu_has_mpx
Thread-Index: AQHPpKaZ7P+lz+nalUOxAx0M9XXWLpurwdcAgAEwxJCAAFzbgIABGsRg
Date: Thu, 24 Jul 2014 00:56:36 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE01703028@shsmsx102.ccr.corp.intel.com>
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com>
 <1405921124-4230-4-git-send-email-qiaowei.ren@intel.com>
 <53CE8EEC.2090402@intel.com>
 <9E0BE1322F2F2246BD820DA9FC397ADE0170079E@shsmsx102.ccr.corp.intel.com>
 <53CFDC79.8040804@intel.com>
In-Reply-To: <53CFDC79.8040804@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014-07-24, Hansen, Dave wrote:
> On 07/22/2014 07:35 PM, Ren, Qiaowei wrote:
>> The checking about MPX feature should be as follow:
>> 
>>         if (pcntxt_mask & XSTATE_EAGER) {
>>                 if (eagerfpu == DISABLE) {
>>                         pr_err("eagerfpu not present, disabling some
> xstate features: 0x%llx\n",
>>                                         pcntxt_mask &
> XSTATE_EAGER);
>>                         pcntxt_mask &= ~XSTATE_EAGER; } else { eagerfpu
>>                         = ENABLE;
>>                 }
>>         }
>> This patch was merged into kernel the ending of last year
>> (https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/com
>> mi
>> t/?id=e7d820a5e549b3eb6c3f9467507566565646a669 )
> 
> Should we be doing a clear_cpu_cap(X86_FEATURE_MPX) in here?
> 
> This isn't major, but I can't _ever_ imagine a user being able to
> track down why MPX is not working from this message.  Should we spruce it up somehow?

Maybe. If the error log "disabling some xstate features:" is changed to "disabling MPX xstate features:", do you think it is OK?

Thanks,
Qiaowei

