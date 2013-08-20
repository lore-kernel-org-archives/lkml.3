Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab3HTFJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 01:09:05 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33189 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751779Ab3HTFJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 01:09:03 -0400
Message-ID: <1376975340.2016.42.camel@joe-AO722>
Subject: Re: [PATCH 1/2] kernel/sysctl.c: check return value after call
 proc_put_char() in __do_proc_doulongvec_minmax()
From: Joe Perches <joe@perches.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Mel Gorman <mgorman@suse.de>, riel@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 19 Aug 2013 22:09:00 -0700
In-Reply-To: <5212E4B2.5020708@asianux.com>
References: <5212E481.9080204@asianux.com> <5212E4B2.5020708@asianux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 11:38 +0800, Chen Gang wrote:
> Need check the return value of proc_put_char(), just like another have
> done in __do_proc_doulongvec_minmax().
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/sysctl.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 7822cd8..ee00986 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -2214,8 +2214,11 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
>  			*i = val;
>  		} else {
>  			val = convdiv * (*i) / convmul;
> -			if (!first)
> +			if (!first) {
>  				err = proc_put_char(&buffer, &left, '\t');
> +				if (err)
> +					goto free;
> +			}

I think you should use break and convert it in
to goto free in patch 2/2.

Otherwise, this style looks out of place.

>  			err = proc_put_long(&buffer, &left, val, false);
>  			if (err)
>  				break;



