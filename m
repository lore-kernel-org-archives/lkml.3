Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbaGWQqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:46:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:54065 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271AbaGWQqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:46:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,718,1400050800"; 
   d="scan'208";a="547852961"
Message-ID: <53CFE6F3.4010605@intel.com>
Date: Wed, 23 Jul 2014 19:46:43 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 05/41] perf tools: Identify which comms are from exec
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com> <1405332185-4050-6-git-send-email-adrian.hunter@intel.com> <20140714203237.GA18133@kernel.org> <53C513CC.1010202@intel.com> <20140723140752.GJ20303@kernel.org> <20140723140908.GK20303@kernel.org>
In-Reply-To: <20140723140908.GK20303@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/07/2014 5:09 p.m., Arnaldo Carvalho de Melo wrote:
> Em Wed, Jul 23, 2014 at 11:07:52AM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Tue, Jul 15, 2014 at 02:43:08PM +0300, Adrian Hunter escreveu:
>>>>> @@ -106,6 +107,8 @@ int comm__override(struct comm *comm, const char *str, u64 timestamp)
>>>>>   	comm_str__put(old);
>>>>>   	comm->comm_str = new;
>>>>>   	comm->start = timestamp;
>>>>> +	if (exec && !comm->exec)
>>>>> +		comm->exec = true;
>>
>>>> Why do you need the !comm->exec test?
>>
>>> Dunno
>>
>> I saw that you kept it in the last patchkit submitted, I'll just drop
>> it, needless obfuscation.

Sorry I forgot.

>
> Also why do you need to "identify which comms are from exec", was it
> good for?

It is for grouping together all the data from a single execution, which
is needed for pairing calls and returns e.g. any outstanding calls when
a process exec's will never return.
