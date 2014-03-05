Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbaCEATF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 19:19:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47379 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbaCEATD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 19:19:03 -0500
Message-ID: <53166D4D.1090004@zytor.com>
Date: Tue, 04 Mar 2014 16:18:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hedi Berriche <hedi@sgi.com>,
        Mike Travis <travis@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 31/48] uv: Replace __get_cpu_var
References: <20140214201841.826179349@linux.com>	<20140214201907.228035121@linux.com> <20140304150217.ac9d364008a3c95cb2a79b34@linux-foundation.org>
In-Reply-To: <20140304150217.ac9d364008a3c95cb2a79b34@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 03:02 PM, Andrew Morton wrote:
> On Fri, 14 Feb 2014 14:19:12 -0600 Christoph Lameter <cl@linux.com> wrote:
> 
>> Use __this_cpu_read instead.
>>
>>
>> --- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2014-02-03 14:16:53.987889372 -0600
>> +++ linux/arch/x86/include/asm/uv/uv_hub.h	2014-02-03 14:16:53.987889372 -0600
>> @@ -618,7 +618,7 @@
>>  };
>>  
>>  DECLARE_PER_CPU(struct uv_cpu_nmi_s, __uv_cpu_nmi);
>> -#define uv_cpu_nmi			(__get_cpu_var(__uv_cpu_nmi))
>> +#define uv_cpu_nmi			__this_cpu_read(_uv_cpu_nmi)
> 
> arch/x86/platform/uv/uv_nmi.c: In function 'uv_check_nmi':
> arch/x86/platform/uv/uv_nmi.c:218: error: '_uv_cpu_nmi' undeclared (first use in this function)
> arch/x86/platform/uv/uv_nmi.c:218: error: (Each undeclared identifier is reported only once
> arch/x86/platform/uv/uv_nmi.c:218: error: for each function it appears in.)
> 
> 
> This?
> 

More likely just add the missing second underscore.

	-hpa

