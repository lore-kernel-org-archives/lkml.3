Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3HGGox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:44:53 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55370 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805Ab3HGGov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:44:51 -0400
X-AuditID: 9c930197-b7b17ae000000a07-d0-5201ece16399
From: Namhyung Kim <namhyung@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V9 01/14] perf tools: add debug prints
References: <1375719994-26482-1-git-send-email-adrian.hunter@intel.com>
	<1375719994-26482-2-git-send-email-adrian.hunter@intel.com>
Date: Wed, 07 Aug 2013 15:44:49 +0900
In-Reply-To: <1375719994-26482-2-git-send-email-adrian.hunter@intel.com>
	(Adrian Hunter's message of "Mon, 5 Aug 2013 19:26:21 +0300")
Message-ID: <8738qmyp7i.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

On Mon,  5 Aug 2013 19:26:21 +0300, Adrian Hunter wrote:
> It is useful to see the arguments to perf_event_open
> and whether the perf events ring buffer was mmapped
> per-cpu or per-thread.  That information will now be
> displayed when verbose is 2 i.e option -vv
>
[SNIP]
>  
> +static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
> +{
> +	size_t ret;
> +
> +	ret = fprintf(fp, "------------------------------------------------------------\n");
> +	ret += fprintf(fp, "perf_event_attr:\n");
> +	ret += fprintf(fp, "  type                %u\n", attr->type);
> +	ret += fprintf(fp, "  size                %u\n", attr->size);
> +	ret += fprintf(fp, "  config              %#"PRIx64"\n", (uint64_t)attr->config);
> +	ret += fprintf(fp, "  sample_period       %"PRIu64"\n", (uint64_t)attr->sample_period);
> +	ret += fprintf(fp, "  sample_freq         %"PRIu64"\n", (uint64_t)attr->sample_freq);
> +	ret += fprintf(fp, "  sample_type         %#"PRIx64"\n", (uint64_t)attr->sample_type);
> +	ret += fprintf(fp, "  read_format         %#"PRIx64"\n", (uint64_t)attr->read_format);
> +
> +	ret += fprintf(fp, "  disabled            %u    ", attr->disabled);
> +	ret += fprintf(fp, "inherit             %u\n", attr->inherit);
> +	ret += fprintf(fp, "  pinned              %u    ", attr->pinned);
> +	ret += fprintf(fp, "exclusive           %u\n", attr->exclusive);
> +	ret += fprintf(fp, "  exclude_user        %u    ", attr->exclude_user);
> +	ret += fprintf(fp, "exclude_kernel      %u\n", attr->exclude_kernel);
> +	ret += fprintf(fp, "  exclude_hv          %u    ", attr->exclude_hv);
> +	ret += fprintf(fp, "exclude_idle        %u\n", attr->exclude_idle);
> +	ret += fprintf(fp, "  mmap                %u    ", attr->mmap);
> +	ret += fprintf(fp, "comm                %u\n", attr->comm);
> +	ret += fprintf(fp, "  freq                %u    ", attr->freq);
> +	ret += fprintf(fp, "inherit_stat        %u\n", attr->inherit_stat);
> +	ret += fprintf(fp, "  enable_on_exec      %u    ", attr->enable_on_exec);
> +	ret += fprintf(fp, "task                %u\n", attr->task);
> +	ret += fprintf(fp, "  watermark           %u    ", attr->watermark);
> +	ret += fprintf(fp, "precise_ip          %u\n", attr->precise_ip);
> +	ret += fprintf(fp, "  mmap_data           %u    ", attr->mmap_data);
> +	ret += fprintf(fp, "sample_id_all       %u\n", attr->sample_id_all);
> +	ret += fprintf(fp, "  exclude_host        %u    ", attr->exclude_host);
> +	ret += fprintf(fp, "exclude_guest       %u\n", attr->exclude_guest);
> +	ret += fprintf(fp, "  excl.callchain.kern %u    ", attr->exclude_callchain_kernel);
> +	ret += fprintf(fp, "excl.callchain.user %u\n", attr->exclude_callchain_user);
> +
> +	ret += fprintf(fp, "  wakeup_events       %u\n", attr->wakeup_events);
> +	ret += fprintf(fp, "  wakeup_watermark    %u\n", attr->wakeup_watermark);
> +	ret += fprintf(fp, "  bp_type             %#x\n", attr->bp_type);
> +	ret += fprintf(fp, "  bp_addr             %#"PRIx64"\n", (uint64_t)attr->bp_addr);
> +	ret += fprintf(fp, "  config1             %#"PRIx64"\n", (uint64_t)attr->config1);
> +	ret += fprintf(fp, "  bp_len              %"PRIu64"\n", (uint64_t)attr->bp_len);
> +	ret += fprintf(fp, "  config2             %#"PRIx64"\n", (uint64_t)attr->config2);
> +	ret += fprintf(fp, "  branch_sample_type  %#"PRIx64"\n", (uint64_t)attr->branch_sample_type);
> +	ret += fprintf(fp, "  sample_regs_user    %#"PRIx64"\n", (uint64_t)attr->sample_regs_user);
> +	ret += fprintf(fp, "  sample_stack_user   %u\n", attr->sample_stack_user);

Things like this likely being ended up with typo.  How about this? (not tested)

#define __PRINT_ATTR(fmt, cast, field)  \
	fprintf(fp, "  %-28s  "fmt"\n", #field, cast attr->field)

#define PRINT_ATTR(field)  __PRINT_ATTR("%u", ,field)
#define PRINT_ATTR_X64(field)  __PRINT_ATTR("%#"PRIx64, (uint64_t), field)
#define PRINT_ATTR2(field1, field2)  \
	fprintf(fp, "  %-28s  %u    %-28s  %u\n", \
		#field1, attr->field1, #field2, attr->field2)

Thanks,
Namhyung


> +	ret += fprintf(fp, "------------------------------------------------------------\n");
> +
> +	return ret;
> +}
