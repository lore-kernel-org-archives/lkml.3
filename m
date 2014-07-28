Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaG1Anl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 20:43:41 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46760 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaG1Ani (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 20:43:38 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf report: Honor column width setting
References: <1406251138-6574-1-git-send-email-namhyung@kernel.org>
	<1406251138-6574-5-git-send-email-namhyung@kernel.org>
	<20140725111302.GB1214@krava.brq.redhat.com>
Date: Mon, 28 Jul 2014 09:43:37 +0900
In-Reply-To: <20140725111302.GB1214@krava.brq.redhat.com> (Jiri Olsa's message
	of "Fri, 25 Jul 2014 13:13:02 +0200")
Message-ID: <87k36yia86.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014 13:13:02 +0200, Jiri Olsa wrote:
> On Fri, Jul 25, 2014 at 10:18:55AM +0900, Namhyung Kim wrote:
>> Set column width and do not change it if user gives -w/--column-widths
>> option.  It'll truncate longer symbols than the width if exists.
>> 
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>
> SNIP
>
>>  
>>  __HPP_COLOR_PERCENT_FN(overhead, period)
>> @@ -797,8 +798,11 @@ static int hist_browser__show_entry(struct hist_browser *browser,
>>  			if (fmt->color) {
>>  				width -= fmt->color(fmt, &hpp, entry);
>>  			} else {
>> -				width -= fmt->entry(fmt, &hpp, entry);
>> +				int ret = fmt->entry(fmt, &hpp, entry);
>> +				s[ret] = '\0';
>>  				slsmg_printf("%s", s);
>
> from quick check it seems like all entry callback functions
> use some sort of snprint which should already handle the string
> length properly.. if not, we should fix that instead, no?

It was 'symbol' sort entry (_hist_entry__sym_snprintf) which has several
snprint calls in it.  So I changed here rather than adding complexity
the print function.  I can change it if you want. ;)

Thanks,
Namhyung
