Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaG2Gwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 02:52:49 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:36613 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaG2Gws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 02:52:48 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 22/27] perf tools: Enable --children option by default
References: <1401335910-16832-1-git-send-email-namhyung@kernel.org>
	<1401335910-16832-23-git-send-email-namhyung@kernel.org>
	<20140728192326.GS17793@alap3.anarazel.de>
Date: Tue, 29 Jul 2014 15:52:46 +0900
In-Reply-To: <20140728192326.GS17793@alap3.anarazel.de> (Andres Freund's
	message of "Mon, 28 Jul 2014 21:23:26 +0200")
Message-ID: <8738dkirlt.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andres,

On Mon, 28 Jul 2014 21:23:26 +0200, Andres Freund wrote:
> Hi,
>
> On 2014-05-29 12:58:25 +0900, Namhyung Kim wrote:
>> Now perf top and perf report will show children column by default if
>> it has callchain information.
>> 
>> Requested-by: Ingo Molnar <mingo@kernel.org>
>> Tested-by: Rodrigo Campos <rodrigo@sdfg.com.ar>
>> Tested-by: Arun Sharma <asharma@fb.com>
>> Acked-by: Jiri Olsa <jolsa@redhat.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>
> Stupid question: Why? This breaks user's usage pattern in a rather
> significant way because the new output is pretty much entirely useless
> in many cases, especially for userland programs. I think the new option
> is great, but why is it suddenly the default?

Yes, I knew it'd annoy some existing users like you :)  But I hoped it'd
be useful for new and (at least, some of) old users to see children/
cumulative overheads by default.  If it lies under an option, it
wouldn't have a chance to be used by normal users who simply run perf
record and report most of time.

If you think it's entirely useless for you cases, you can set it to off
using ~/.perfconfig file:

  [report]
  children = false


Thanks,
Namhyung
