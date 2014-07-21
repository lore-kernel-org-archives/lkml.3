Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107AbaGUNAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:00:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:50763 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753934AbaGUNAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:00:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,701,1400050800"; 
   d="scan'208";a="564908976"
Message-ID: <53CD0E91.9020100@intel.com>
Date: Mon, 21 Jul 2014 15:58:57 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCHv3 00/19] perf tools: Factor ordered samples queue
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org> <53CCB6AE.6020505@intel.com> <20140721080219.GA4183@krava.redhat.com> <53CCD3A7.5070002@intel.com> <20140721095415.GB8865@krava.redhat.com> <53CD02E3.6090509@intel.com> <20140721123513.GA14929@krava.redhat.com>
In-Reply-To: <20140721123513.GA14929@krava.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 03:35 PM, Jiri Olsa wrote:
> On Mon, Jul 21, 2014 at 03:09:07PM +0300, Adrian Hunter wrote:
> 
> SNIP
> 
>>>>
>>>> ...so is the 100MB limit needed at all if you have ROUND
>>>> events?
>>>
>>> for data files captured without the ROUND events fix
>>
>> I am not sure it should be the default then, if it is
>> not needed going forward.
> 
> I'd be ok with not setting 100MB limit by default, just need a way
> to configure it.. so without following patch:
>   perf tools: Limit the ordered events queue by default to 100MB

Ok then.  Also it would be good to have a warning if a premature flush
is forced, so that you can distinguish the cause of out-of-order
messages.

