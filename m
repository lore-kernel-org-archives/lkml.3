Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136Ab3LIQYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:24:16 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:7145 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933653Ab3LIQYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:24:12 -0500
Date: Mon, 9 Dec 2013 11:24:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 14/14] tools lib traceevent: Get rid of die() in some
 string conversion funcitons
Message-ID: <20131209112410.2ca63d45@gandalf.local.home>
In-Reply-To: <1386567251-22751-15-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-15-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Dec 2013 14:34:11 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> @@ -2231,12 +2238,13 @@ static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
>  		op = "^";
>  		break;
>  	default:
> -		die("oops in exp");
> +		break;
>  	}

This looks like we silently ignored the warning. Perhaps we should have:

	default:
		op = "[ERROR IN EXPRESSION TYPE]";
		break;


-- Steve

>  
>  	len = strlen(op) + strlen(lstr) + strlen(rstr) + 4;
> -	str = malloc_or_die(len);
> -	snprintf(str, len, "%s %s %s", lstr, op, rstr);
> +	str = malloc(len);
> +	if (str)
> +		snprintf(str, len, "%s %s %s", lstr, op, rstr);
>  out:
>  	free(lstr);
>  	free(rstr);
