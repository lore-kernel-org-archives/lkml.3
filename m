Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3JIMoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:44:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:44422 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab3JIMoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:44:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1063,1371106800"; 
   d="scan'208";a="305614733"
Message-ID: <52554F5E.2090200@intel.com>
Date: Wed, 09 Oct 2013 15:43:10 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V5 3/9] perf tools: workaround objdump difficulties with
 kcore
References: <1381221956-16699-1-git-send-email-adrian.hunter@intel.com> <1381221956-16699-4-git-send-email-adrian.hunter@intel.com> <20131008140236.GD1348@krava.redhat.com> <525506C5.3020101@intel.com> <20131009101249.GC1005@krava.redhat.com> <5255320C.9020009@intel.com> <20131009121624.GA5459@krava.redhat.com>
In-Reply-To: <20131009121624.GA5459@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/13 15:16, Jiri Olsa wrote:
> On Wed, Oct 09, 2013 at 01:38:04PM +0300, Adrian Hunter wrote:
>> On 09/10/13 13:12, Jiri Olsa wrote:
>>> On Wed, Oct 09, 2013 at 10:33:25AM +0300, Adrian Hunter wrote:
>>>> On 08/10/13 17:02, Jiri Olsa wrote:
>>>>> On Tue, Oct 08, 2013 at 11:45:50AM +0300, Adrian Hunter wrote:
> 
> SNIP
> 
>>>
>>> so.. the name of the section, name of the <function> plus the first
>>> instruction decode seem wrong.. I can see that in every symbol I
>>> annotate in the report and in annotate command as well.
>>
>> If you use the --asm-raw option you can see the bytes:
>>
>> 	66 66 66 90 
>>
>> That looks like a "nop" e.g. K8_NOP4 in arch/x86/include/asm/nops.h
>>
> 
> hum, wierd for all those functions to start with nop

I guess it is for ftrace.

> 
> ok, how about the '<load0>' function name?

That is because kcore (and its copies) have no symbols
so objdump has nothing meaningful to put there.  The function
name and file appear at the top of the screen instead.

