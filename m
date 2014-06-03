Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaFCCTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 22:19:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:5799 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752627AbaFCCTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 22:19:54 -0400
Date: Mon, 2 Jun 2014 22:19:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: lib: traceevent: parse-filter.c:  Cleaning up
 memory leak
Message-ID: <20140602221947.1c1deb7d@gandalf.local.home>
In-Reply-To: <1401622616-13721-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1401622616-13721-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  1 Jun 2014 13:36:56 +0200
Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:

> There is a risk for memory leak in when something unexpected happens
> and the function returns.
> 
> This was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  tools/lib/traceevent/parse-filter.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> index b502344..5865c9e 100644
> --- a/tools/lib/traceevent/parse-filter.c
> +++ b/tools/lib/traceevent/parse-filter.c
> @@ -1492,8 +1492,10 @@ static int copy_filter_type(struct event_filter *filter,
>  			arg->boolean.value = 0;
>  
>  		filter_type = add_filter_type(filter, event->id);
> -		if (filter_type == NULL)
> +		if (filter_type == NULL) {
> +			free_arg(arg);
>  			return -1;
> +		}
>  
>  		filter_type->filter = arg;
>  

