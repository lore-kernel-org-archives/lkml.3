Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaKVBZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 20:25:23 -0500
Received: from one.firstfloor.org ([193.170.194.197]:60191 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaKVBZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 20:25:22 -0500
Date: Sat, 22 Nov 2014 02:25:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org, "Liang, Kan" <kan.liang@intel.com>
Subject: Re: Implement lbr-as-callgraph v10
Message-ID: <20141122012519.GP12538@two.firstfloor.org>
References: <20141118104416.GE27645@krava.brq.redhat.com>
 <20141118110007.GF27645@krava.brq.redhat.com>
 <87zjbnpv64.fsf@sejong.aot.lge.com>
 <20141119092323.GC2592@krava.brq.redhat.com>
 <20141119105450.GA22132@krava.brq.redhat.com>
 <20141119141027.GF3790@kernel.org>
 <20141119160458.GG3790@kernel.org>
 <20141119214822.GM12538@two.firstfloor.org>
 <20141120193347.GL3790@kernel.org>
 <20141121203057.GD18625@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141121203057.GD18625@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>      f1 tcall.c:9
>      main tcall.c:17
>      main tcall.c:17
>      main tcall.c:16
>      main tcall.c:16
>      f1 tcall.c:12
>      f1 tcall.c:12
>      f2 tcall.c:6
>      f2 tcall.c:4
>      f1 tcall.c:11
>      f1 tcall.c:11
>      f2 tcall.c:6
>      f2 tcall.c:4
>      f1 tcall.c:10
>      f1 tcall.c:9
>      main tcall.c:17
> <SNIP>
> 
> 
> Do you see the diff?  The 87.65% and 12.35% doesn't appear on the --tui
> output.

I see the problem. It's some issue in hist_browser__show_callchain.
--stdio doesn't show it because it doesn't seem to use that (?)

With this patch it shows percent for the first entry

@@ -791,7 +791,7 @@ static int hist_browser__show_entry(struct hist_browser *browser,
                };
 
                printed += hist_browser__show_callchain(browser,
-                                       &entry->sorted_chain, 1, row, total,
+                                       &entry->sorted_chain, 2, row, total,
                                        hist_browser__show_callchain_entry, &arg,
                                        hist_browser__check_output_full);

But the numbers are still different from what --stdio outputs,
so there are some deeper issues.

I doubt I caused this, probably some latent bug that just got triggered.

Namhyung?

-Andi
