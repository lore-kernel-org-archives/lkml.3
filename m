Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3HZJbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 05:31:14 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:59077 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3HZJbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 05:31:13 -0400
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <alpine.DEB.2.10.1308231544420.1889@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1307081520520.10386@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1308231544420.1889@vincent-weaver-1.um.maine.edu>
Date: Mon, 26 Aug 2013 11:31:11 +0200
Message-ID: <CAMsRxf+FU4UhVvgVCww5CuNwfqOk915_-TKK4fC7daFoweMnQQ@mail.gmail.com>
Subject: Re: [patch, resend] perf: export struct perf_branch_entry to userspace
From: Stephane Eranian <eranian@googlemail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 9:51 PM, Vince Weaver <vincent.weaver@maine.edu> wrote:
>
> On Mon, 8 Jul 2013, Vince Weaver wrote:
>
> If PERF_SAMPLE_BRANCH_STACK is enabled then samples are returned
> with the format { u64 from, to, flags } but the flags layout
> is not specified.
>
> This field has the type struct perf_branch_entry; move this
> definition into include/uapi/linux/perf_event.h so users can
> access these fields.
>
> This is similar to the existing inclusion of perf_mem_data_src in
> the include/uapi/linux/perf_event.h file.
>
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
>
This makes sense.
Acked-by: Stephane Eranian <eranian@google.com>

>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 8873f82..65b2553 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -64,30 +64,6 @@ struct perf_raw_record {
>  };
>
>  /*
> - * single taken branch record layout:
> - *
> - *      from: source instruction (may not always be a branch insn)
> - *        to: branch target
> - *   mispred: branch target was mispredicted
> - * predicted: branch target was predicted
> - *
> - * support for mispred, predicted is optional. In case it
> - * is not supported mispred = predicted = 0.
> - *
> - *     in_tx: running in a hardware transaction
> - *     abort: aborting a hardware transaction
> - */
> -struct perf_branch_entry {
> -       __u64   from;
> -       __u64   to;
> -       __u64   mispred:1,  /* target mispredicted */
> -               predicted:1,/* target predicted */
> -               in_tx:1,    /* in transaction */
> -               abort:1,    /* transaction abort */
> -               reserved:60;
> -};
> -
> -/*
>   * branch stack layout:
>   *  nr: number of taken branches stored in entries[]
>   *
> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> index 0b1df41..c6e2f76 100644
> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -685,4 +685,28 @@ union perf_mem_data_src {
>  #define PERF_MEM_S(a, s) \
>         (((u64)PERF_MEM_##a##_##s) << PERF_MEM_##a##_SHIFT)
>
> +/*
> + * single taken branch record layout:
> + *
> + *      from: source instruction (may not always be a branch insn)
> + *        to: branch target
> + *   mispred: branch target was mispredicted
> + * predicted: branch target was predicted
> + *
> + * support for mispred, predicted is optional. In case it
> + * is not supported mispred = predicted = 0.
> + *
> + *     in_tx: running in a hardware transaction
> + *     abort: aborting a hardware transaction
> + */
> +struct perf_branch_entry {
> +       __u64   from;
> +       __u64   to;
> +       __u64   mispred:1,  /* target mispredicted */
> +               predicted:1,/* target predicted */
> +               in_tx:1,    /* in transaction */
> +               abort:1,    /* transaction abort */
> +               reserved:60;
> +};
> +
>  #endif /* _UAPI_LINUX_PERF_EVENT_H */
