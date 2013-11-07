Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3KGIEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 03:04:33 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:44130 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3KGIEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 03:04:21 -0500
Date: Thu, 7 Nov 2013 09:04:18 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/4] perf record: Remove post_processing_offset variable
Message-ID: <20131107080418.GE31926@gmail.com>
References: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
 <1383763297-27066-4-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383763297-27066-4-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> Duplicates the data_offset from header in the session.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/builtin-record.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 19c4db6bdd6f..15280b5e5574 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -74,7 +74,6 @@ struct perf_record {
>  	bool			no_buildid;
>  	bool			no_buildid_cache;
>  	long			samples;
> -	off_t			post_processing_offset;
>  };
>  
>  static int write_output(struct perf_record *rec, void *buf, size_t size)
> @@ -247,13 +246,14 @@ static int process_buildids(struct perf_record *rec)
>  {
>  	struct perf_data_file *file  = &rec->file;
>  	struct perf_session *session = rec->session;
> +	u64 start = session->header.data_offset;
>  
>  	u64 size = lseek(file->fd, 0, SEEK_CUR);
>  	if (size == 0)
>  		return 0;
>  
> -	return __perf_session__process_events(session, rec->post_processing_offset,
> -					      size - rec->post_processing_offset,
> +	return __perf_session__process_events(session, start,
> +					      size - start,
>  					      size, &build_id__mark_dso_hit_ops);
>  }
>  
> @@ -429,8 +429,6 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
>  		goto out_delete_session;
>  	}
>  
> -	rec->post_processing_offset = lseek(file->fd, 0, SEEK_CUR);
> -
>  	machine = &session->machines.host;
>  
>  	if (file->is_pipe) {
> -- 
> 1.8.3.4 (Apple Git-47)

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
