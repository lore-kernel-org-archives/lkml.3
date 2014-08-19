Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaHSGD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 02:03:57 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:37810 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaHSGD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 02:03:56 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 03/13] perf annotate: Move session handling out of __cmd_annotate()
References: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
	<1407825645-24586-4-git-send-email-namhyung@kernel.org>
	<20140813114822.GD2370@krava.brq.redhat.com>
Date: Tue, 19 Aug 2014 15:03:54 +0900
In-Reply-To: <20140813114822.GD2370@krava.brq.redhat.com> (Jiri Olsa's message
	of "Wed, 13 Aug 2014 13:48:22 +0200")
Message-ID: <87ha19c8xh.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014 13:48:22 +0200, Jiri Olsa wrote:
> On Tue, Aug 12, 2014 at 03:40:35PM +0900, Namhyung Kim wrote:
>> +	annotate.session = perf_session__new(&file, false, &annotate.tool);
>> +	if (annotate.session == NULL)
>> +		return -ENOMEM;
>
> I know you're just moving code, but perf_session__new could
> fail for more reasons than just ENOMEM, which is the most
> unlikely case ;-) -1 is probably better option here

Okay, will change as a separate fix later.

Thanks,
Namhyung
