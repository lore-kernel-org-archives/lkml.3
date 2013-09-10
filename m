Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3IJGrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:47:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:16963 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab3IJGrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:47:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,876,1371106800"; 
   d="scan'208";a="401032624"
Message-ID: <522EC22E.8080805@intel.com>
Date: Tue, 10 Sep 2013 09:54:38 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 00/25] perf tool: Add support for multiple data file
 storage
References: <1378031796-17892-1-git-send-email-jolsa@redhat.com> <20130909111749.GP31370@twins.programming.kicks-ass.net>
In-Reply-To: <20130909111749.GP31370@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/13 14:17, Peter Zijlstra wrote:
> On Sun, Sep 01, 2013 at 12:36:11PM +0200, Jiri Olsa wrote:
>> hi,
>> sending the support for multiple file storage. Initial
>> RFC is here:
>> http://marc.info/?l=linux-kernel&m=137408381902423&w=2
>>
>> v2 changes:
>>   - reworked perf mmap size setup to be able to get
>>     the mmap size value easily later
>>   - added perf.data read/write test for v2 and v3
>>     for both endianity
>>   - added record '-M time' support
> 
> So this 0/n post seems to have forgotten to list the rationale for doing
> all this.. 
> 
> The only reason I wanted this is so that each thread can write its own
> data. The current one file thing is an immense bottle-neck for big
> machines.

Do you need multiple files for that?  Why not just feed writes to a pool of
threads?

