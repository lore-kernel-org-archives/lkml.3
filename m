Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3JJHP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:15:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab3JJHPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:15:25 -0400
Date: Thu, 10 Oct 2013 09:15:06 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Felipe Pena <felipensp@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/perf/tests: Fix memory leak in dso-data.c
Message-ID: <20131010071506.GA7997@krava.redhat.com>
References: <1381370438-4209-1-git-send-email-felipensp@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381370438-4209-1-git-send-email-felipensp@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 11:00:38PM -0300, Felipe Pena wrote:
> Fix for a memory leak on test_file() function in dso-data.c

oops, thanks ;-)

Acked-by: Jiri Olsa <jolsa@redhat.com>

> 
> Signed-off-by: Felipe Pena <felipensp@gmail.com>
> ---
>  tools/perf/tests/dso-data.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
> index dffe055..9cc81a3 100644
> --- a/tools/perf/tests/dso-data.c
> +++ b/tools/perf/tests/dso-data.c
> @@ -35,6 +35,7 @@ static char *test_file(int size)
>  	if (size != write(fd, buf, size))
>  		templ = NULL;
> 
> +	free(buf);
>  	close(fd);
>  	return templ;
>  }
> --
> 1.7.10.4
> 
