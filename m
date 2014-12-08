Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaLHISI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:18:08 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:38655 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaLHISG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:18:06 -0500
MIME-Version: 1.0
In-Reply-To: <1417623842-14331-7-git-send-email-jolsa@kernel.org>
References: <1417623842-14331-1-git-send-email-jolsa@kernel.org> <1417623842-14331-7-git-send-email-jolsa@kernel.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Mon, 8 Dec 2014 17:17:44 +0900
X-Google-Sender-Auth: URs8BI-js0lpEi9iSrNgiu45s-c
Message-ID: <CAM9d7cg7EdhQ8f_yA_aHrOgbM9axW1sr+Jzw+Mfwr1kkwQZGpg@mail.gmail.com>
Subject: Re: [PATCH 6/8] perf data: Switch to multiple cpu stream files
To: Jiri Olsa <jolsa@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 1:24 AM, Jiri Olsa <jolsa@kernel.org> wrote:
> +static int setup_streams(struct ctf_writer *cw, struct perf_session *session)
> +{
> +       struct ctf_stream **stream;
> +       struct perf_header *ph = &session->header;
> +       int ncpus;
> +
> +       /*
> +        * Try to get the number of cpus used in the data file,
> +        * if not present fallback to the MAX_CPUS.
> +        */
> +       if (!ph)

I think this check is meaningless since perf_header struct is embedded
in perf_session so it shouldn't be NULL when refered from a session..

Thanks,
Namhyung


> +               ncpus = MAX_CPUS;
> +       else
> +               ncpus = ph->env.nr_cpus_avail;
> +
> +       stream = zalloc(sizeof(*stream) * ncpus);
> +       if (!stream) {
> +               pr_err("Failed to allocate streams.\n");
> +               return -ENOMEM;
> +       }
> +
> +       cw->stream     = stream;
> +       cw->stream_cnt = ncpus;
> +       return 0;
> +}
