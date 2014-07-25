Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbaGYLNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:13:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaGYLNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:13:53 -0400
Date: Fri, 25 Jul 2014 13:13:02 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf report: Honor column width setting
Message-ID: <20140725111302.GB1214@krava.brq.redhat.com>
References: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
 <1406251138-6574-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406251138-6574-5-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 10:18:55AM +0900, Namhyung Kim wrote:
> Set column width and do not change it if user gives -w/--column-widths
> option.  It'll truncate longer symbols than the width if exists.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---

SNIP

>  
>  __HPP_COLOR_PERCENT_FN(overhead, period)
> @@ -797,8 +798,11 @@ static int hist_browser__show_entry(struct hist_browser *browser,
>  			if (fmt->color) {
>  				width -= fmt->color(fmt, &hpp, entry);
>  			} else {
> -				width -= fmt->entry(fmt, &hpp, entry);
> +				int ret = fmt->entry(fmt, &hpp, entry);
> +				s[ret] = '\0';
>  				slsmg_printf("%s", s);

from quick check it seems like all entry callback functions
use some sort of snprint which should already handle the string
length properly.. if not, we should fix that instead, no?

jirka
