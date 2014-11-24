Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaKXHk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 02:40:29 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:52647 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbaKXHk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 02:40:28 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        "Liang\, Kan" <kan.liang@intel.com>
Subject: Re: Implement lbr-as-callgraph v10
References: <20141118104416.GE27645@krava.brq.redhat.com>
	<20141118110007.GF27645@krava.brq.redhat.com>
	<87zjbnpv64.fsf@sejong.aot.lge.com>
	<20141119092323.GC2592@krava.brq.redhat.com>
	<20141119105450.GA22132@krava.brq.redhat.com>
	<20141119141027.GF3790@kernel.org> <20141119160458.GG3790@kernel.org>
	<20141119214822.GM12538@two.firstfloor.org>
	<20141120193347.GL3790@kernel.org> <20141121203057.GD18625@kernel.org>
	<20141122012519.GP12538@two.firstfloor.org>
Date: Mon, 24 Nov 2014 16:40:25 +0900
In-Reply-To: <20141122012519.GP12538@two.firstfloor.org> (Andi Kleen's message
	of "Sat, 22 Nov 2014 02:25:19 +0100")
Message-ID: <87sih9nj12.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi and Arnaldo,

On Sat, 22 Nov 2014 02:25:19 +0100, Andi Kleen wrote:
>>      f1 tcall.c:9
>>      main tcall.c:17
>>      main tcall.c:17
>>      main tcall.c:16
>>      main tcall.c:16
>>      f1 tcall.c:12
>>      f1 tcall.c:12
>>      f2 tcall.c:6
>>      f2 tcall.c:4
>>      f1 tcall.c:11
>>      f1 tcall.c:11
>>      f2 tcall.c:6
>>      f2 tcall.c:4
>>      f1 tcall.c:10
>>      f1 tcall.c:9
>>      main tcall.c:17
>> <SNIP>
>> 
>> 
>> Do you see the diff?  The 87.65% and 12.35% doesn't appear on the --tui
>> output.
>
> I see the problem. It's some issue in hist_browser__show_callchain.
> --stdio doesn't show it because it doesn't seem to use that (?)
>
> With this patch it shows percent for the first entry
>
> @@ -791,7 +791,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
>                 };
>  
>                 printed += hist_browser__show_callchain(browser,
> -                                       &entry->sorted_chain, 1, row, total,
> +                                       &entry->sorted_chain, 2, row, total,
>                                         hist_browser__show_callchain_entry, &arg,
>                                         hist_browser__check_output_full);
>
> But the numbers are still different from what --stdio outputs,
> so there are some deeper issues.
>
> I doubt I caused this, probably some latent bug that just got triggered.
>
> Namhyung?

I think it's an old bug even before my callchain cleanup patch series.
It only prints percent if the level is greater than 1 which I guess it
assumes there's only a single callchain path for the first level.

I'll post a patch for that soon.

Thanks,
Namhyung
