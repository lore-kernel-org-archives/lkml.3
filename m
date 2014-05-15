Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaEOHox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:44:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbaEOHow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:44:52 -0400
Date: Thu, 15 May 2014 09:44:40 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Masanari Iida <standby24x7@gmail.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, acme@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf session: Fix possible null pointer dereference in
 session.c
Message-ID: <20140515074440.GA1101@krava.brq.redhat.com>
References: <1400087618-13628-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400087618-13628-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 02:13:38AM +0900, Masanari Iida wrote:
> cppcheck detected following warning.
> [tools/perf/util/session.c:1628] -> [tools/perf/util/session.c:1632]:
>  (warning) Possible null pointer dereference: session - otherwise it
>  is redundant to check it against null.
> 
> In order to avoide null pointer, check the pointer before use.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

applied, thanks

jirka

> ---
>  tools/perf/util/session.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 55960f2..64a186e 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -1625,13 +1625,14 @@ out_delete_map:
>  void perf_session__fprintf_info(struct perf_session *session, FILE *fp,
>  				bool full)
>  {
> -	int fd = perf_data_file__fd(session->file);
>  	struct stat st;
> -	int ret;
> +	int fd, ret;
>  
>  	if (session == NULL || fp == NULL)
>  		return;
>  
> +	fd = perf_data_file__fd(session->file);
> +
>  	ret = fstat(fd, &st);
>  	if (ret == -1)
>  		return;
> -- 
> 2.0.0.rc3.2.g998f840
> 
