Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaJGF0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 01:26:23 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:55156 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaJGF0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 01:26:21 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Taeung Song <treeze.taeung@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org,
        jolsa@redhat.com, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH] perf top: Add a visual cue for toggle zeroing of samples
References: <1412491774-2971-1-git-send-email-treeze.taeung@gmail.com>
Date: Tue, 07 Oct 2014 14:26:19 +0900
In-Reply-To: <1412491774-2971-1-git-send-email-treeze.taeung@gmail.com>
	(Taeung Song's message of "Sun, 5 Oct 2014 15:49:34 +0900")
Message-ID: <87a958h2mc.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Taeung,

On Sun,  5 Oct 2014 15:49:34 +0900, Taeung Song wrote:
> When 'perf top' is run, one can't easily find a difference
> between -z option and normal output.
> So I added a visual cue to know whether it is the zeroing or not.


[SNIP]
> +static int hists__browser_title(struct hists *hists,
> +				struct hist_browser_timer *hbt,
> +				char *bf,
> +				size_t size)

You don't need to align arguments like this.


>  {
>  	char unit;
>  	int printed;
> @@ -1256,6 +1268,14 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size)
>  	if (dso)
>  		printed += scnprintf(bf + printed, size - printed,
>  				    ", DSO: %s", dso->short_name);
> +	if (!is_report_browser(hbt)) {
> +		struct perf_top *top = hbt->arg;
> +
> +		if (top->zero)
> +			printed += scnprintf(bf + printed, size - printed,
> +					     ", [z]", "");

It seems the final empty string can go away.  And personally I'd like to
get rid of "," before "[z]" also.

Otherwise looks good to me.  Could you please take a look at the stdio
output too?

Thanks,
Namhyung


> +	}
> +
>  	return printed;
>  }
>  
> @@ -1267,12 +1287,6 @@ static inline void free_popup_options(char **options, int n)
>  		zfree(&options[i]);
>  }
>  
> -/* Check whether the browser is for 'top' or 'report' */
> -static inline bool is_report_browser(void *timer)
> -{
> -	return timer == NULL;
> -}
> -
>  /*
>   * Only runtime switching of perf data file will make "input_name" point
>   * to a malloced buffer. So add "is_input_name_malloced" flag to decide
