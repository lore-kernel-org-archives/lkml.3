Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426Ab3HGIH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:07:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:7895 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346Ab3HGIHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:07:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,831,1367996400"; 
   d="scan'208";a="382522471"
Message-ID: <520201A3.4030606@intel.com>
Date: Wed, 07 Aug 2013 11:13:23 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V9 01/14] perf tools: add debug prints
References: <1375719994-26482-1-git-send-email-adrian.hunter@intel.com> <1375719994-26482-2-git-send-email-adrian.hunter@intel.com> <8738qmyp7i.fsf@sejong.aot.lge.com>
In-Reply-To: <8738qmyp7i.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/13 09:44, Namhyung Kim wrote:
> Hi Adrian,
> 
> On Mon,  5 Aug 2013 19:26:21 +0300, Adrian Hunter wrote:
>> It is useful to see the arguments to perf_event_open
>> and whether the perf events ring buffer was mmapped
>> per-cpu or per-thread.  That information will now be
>> displayed when verbose is 2 i.e option -vv
>>
> [SNIP]
>>  
>> +static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
>> +{
>> +	size_t ret;
>> +
>> +	ret = fprintf(fp, "------------------------------------------------------------\n");
>> +	ret += fprintf(fp, "perf_event_attr:\n");
>> +	ret += fprintf(fp, "  type                %u\n", attr->type);
>> +	ret += fprintf(fp, "  size                %u\n", attr->size);
>> +	ret += fprintf(fp, "  config              %#"PRIx64"\n", (uint64_t)attr->config);
>> +	ret += fprintf(fp, "  sample_period       %"PRIu64"\n", (uint64_t)attr->sample_period);
>> +	ret += fprintf(fp, "  sample_freq         %"PRIu64"\n", (uint64_t)attr->sample_freq);
>> +	ret += fprintf(fp, "  sample_type         %#"PRIx64"\n", (uint64_t)attr->sample_type);
>> +	ret += fprintf(fp, "  read_format         %#"PRIx64"\n", (uint64_t)attr->read_format);
>> +
>> +	ret += fprintf(fp, "  disabled            %u    ", attr->disabled);
>> +	ret += fprintf(fp, "inherit             %u\n", attr->inherit);
>> +	ret += fprintf(fp, "  pinned              %u    ", attr->pinned);
>> +	ret += fprintf(fp, "exclusive           %u\n", attr->exclusive);
>> +	ret += fprintf(fp, "  exclude_user        %u    ", attr->exclude_user);
>> +	ret += fprintf(fp, "exclude_kernel      %u\n", attr->exclude_kernel);
>> +	ret += fprintf(fp, "  exclude_hv          %u    ", attr->exclude_hv);
>> +	ret += fprintf(fp, "exclude_idle        %u\n", attr->exclude_idle);
>> +	ret += fprintf(fp, "  mmap                %u    ", attr->mmap);
>> +	ret += fprintf(fp, "comm                %u\n", attr->comm);
>> +	ret += fprintf(fp, "  freq                %u    ", attr->freq);
>> +	ret += fprintf(fp, "inherit_stat        %u\n", attr->inherit_stat);
>> +	ret += fprintf(fp, "  enable_on_exec      %u    ", attr->enable_on_exec);
>> +	ret += fprintf(fp, "task                %u\n", attr->task);
>> +	ret += fprintf(fp, "  watermark           %u    ", attr->watermark);
>> +	ret += fprintf(fp, "precise_ip          %u\n", attr->precise_ip);
>> +	ret += fprintf(fp, "  mmap_data           %u    ", attr->mmap_data);
>> +	ret += fprintf(fp, "sample_id_all       %u\n", attr->sample_id_all);
>> +	ret += fprintf(fp, "  exclude_host        %u    ", attr->exclude_host);
>> +	ret += fprintf(fp, "exclude_guest       %u\n", attr->exclude_guest);
>> +	ret += fprintf(fp, "  excl.callchain.kern %u    ", attr->exclude_callchain_kernel);
>> +	ret += fprintf(fp, "excl.callchain.user %u\n", attr->exclude_callchain_user);
>> +
>> +	ret += fprintf(fp, "  wakeup_events       %u\n", attr->wakeup_events);
>> +	ret += fprintf(fp, "  wakeup_watermark    %u\n", attr->wakeup_watermark);
>> +	ret += fprintf(fp, "  bp_type             %#x\n", attr->bp_type);
>> +	ret += fprintf(fp, "  bp_addr             %#"PRIx64"\n", (uint64_t)attr->bp_addr);
>> +	ret += fprintf(fp, "  config1             %#"PRIx64"\n", (uint64_t)attr->config1);
>> +	ret += fprintf(fp, "  bp_len              %"PRIu64"\n", (uint64_t)attr->bp_len);
>> +	ret += fprintf(fp, "  config2             %#"PRIx64"\n", (uint64_t)attr->config2);
>> +	ret += fprintf(fp, "  branch_sample_type  %#"PRIx64"\n", (uint64_t)attr->branch_sample_type);
>> +	ret += fprintf(fp, "  sample_regs_user    %#"PRIx64"\n", (uint64_t)attr->sample_regs_user);
>> +	ret += fprintf(fp, "  sample_stack_user   %u\n", attr->sample_stack_user);
> 
> Things like this likely being ended up with typo.  How about this? (not tested)

And yet there aren't any typos.

> 
> #define __PRINT_ATTR(fmt, cast, field)  \
> 	fprintf(fp, "  %-28s  "fmt"\n", #field, cast attr->field)
> 
> #define PRINT_ATTR_D32(field)  __PRINT_ATTR("%u", ,field)
> #define PRINT_ATTR_X32(field)  __PRINT_ATTR("%#x", ,field)
> #define PRINT_ATTR_D64(field)  __PRINT_ATTR("%"PRIu64, (uint64_t), field)
> #define PRINT_ATTR_X64(field)  __PRINT_ATTR("%#"PRIx64, (uint64_t), field)
> #define PRINT_ATTR2(field1, field2)  \
> 	fprintf(fp, "  %-28s  %u    %-28s  %u\n", \
> 		#field1, attr->field1, #field2, attr->field2)

That does not allow the output to be nicely formatted.  In some cases the
field name is just too long and I have abbreviated it.

When you add in all the variations you just get a macro mess.

> 
> Thanks,
> Namhyung
> 
> 
>> +	ret += fprintf(fp, "------------------------------------------------------------\n");
>> +
>> +	return ret;
>> +}
> 
> 

