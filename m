Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757090Ab3EWCh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 22:37:28 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:57366 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756493Ab3EWCh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 22:37:27 -0400
X-AuditID: 9c93016f-b7cfdae000002fc1-d1-519d80e4651d
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 3/5] perf gtk/hists: Display callchain overhead also
References: <1369211258-3163-1-git-send-email-namhyung@kernel.org>
	<1369211258-3163-4-git-send-email-namhyung@kernel.org>
	<20130522095215.GA2386@ghostprotocols.net>
Date: Thu, 23 May 2013 11:37:24 +0900
In-Reply-To: <20130522095215.GA2386@ghostprotocols.net> (Arnaldo Carvalho de
	Melo's message of "Wed, 22 May 2013 11:52:15 +0200")
Message-ID: <87r4gy2zh7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

Good to see you :)

On Wed, 22 May 2013 11:52:15 +0200, Arnaldo Carvalho de Melo wrote:
> Em Wed, May 22, 2013 at 05:27:36PM +0900, Namhyung Kim escreveu:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Add a new column for showing callchain overhead.  I feel like it's
>> more natural than having those overhead next to a first child in a
>> same column.
>
> Callchains in GTK, great! Some observations tho:
>
> All those leaves with 0.00% looks ugly/not needed, right?

Right.  But I'd rather say it's a bug of callchain code. :)

>
> I took a screenshot and put at:
>
> http://vger.kernel.org/~acme/perf-gtk-callchains.png
>
> all those duplicated "+ callchain" when the callchain is folded, can you
> remove those? I.e. leaving just the '+' to allow unfolding.

Sure.

>
> About using an extra column for the callchains... Can't it be like in
> the TUI and in the stdio modes? Think about C++ long symbol names :-) 

That's why I made the columns resizable.

I also thought about reusing the existing overhead and symbols columns.
But I thought it might be confusing to contains two different info in a
same column.  But I'm not sure what's the better.

>
> I'll do some more testing on it and provide further comments, thanks for
> doing this work!

Thanks a lot!
Namhyung
