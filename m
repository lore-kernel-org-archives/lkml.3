Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab3JUGIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 02:08:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:47555 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab3JUGH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 02:07:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="377534206"
Message-ID: <5264C494.9070003@intel.com>
Date: Mon, 21 Oct 2013 09:07:16 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 03/19] perf record: Improve write_output error message
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com> <1382099356-4918-4-git-send-email-adrian.hunter@intel.com> <20131020204316.GB12044@krava>
In-Reply-To: <20131020204316.GB12044@krava>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/10/13 23:43, Jiri Olsa wrote:
> On Fri, Oct 18, 2013 at 03:29:00PM +0300, Adrian Hunter wrote:
>> Improve the error message from write_output() to say
>> what failed to write and give the error number.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/builtin-record.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
>> index 92ca541..d269dfa 100644
>> --- a/tools/perf/builtin-record.c
>> +++ b/tools/perf/builtin-record.c
>> @@ -88,7 +88,7 @@ static int write_output(struct perf_record *rec, void *buf, size_t size)
>>  		int ret = write(rec->output, buf, size);
>>  
>>  		if (ret < 0) {
>> -			pr_err("failed to write\n");
>> +			pr_err("failed to write perf data, error: %m\n");
> 
> is this some kind of format magic? ;-) you wanted

It is a glibc extension.

> to print out 'ret' value, right?

No, errno

