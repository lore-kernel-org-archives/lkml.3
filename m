Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbaEIALH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 20:11:07 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:57110 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbaEIALF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 20:11:05 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v5 1/2] perf record: Propagate exit status of a command line workload
References: <1399535994-8027-1-git-send-email-namhyung@kernel.org>
	<20140508103225.GA10851@krava.brq.redhat.com>
Date: Fri, 09 May 2014 09:11:03 +0900
In-Reply-To: <20140508103225.GA10851@krava.brq.redhat.com> (Jiri Olsa's
	message of "Thu, 8 May 2014 12:32:25 +0200")
Message-ID: <87a9arolpk.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 8 May 2014 12:32:25 +0200, Jiri Olsa wrote:
> On Thu, May 08, 2014 at 04:59:53PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>> +
>> +	if (!err && !file->is_pipe) {
>> +		rec->session->header.data_size += rec->bytes_written;
>> +
>> +		if (!rec->no_buildid)
>> +			process_buildids(rec);
>> +		perf_session__write_header(rec->session, rec->evlist,
>> +					   file->fd, true);
>> +	}
>> +
>> +	if (signr != -1) {
>> +		signal(signr, SIG_DFL);
>> +		raise(signr);
>> +	}
>
> hum.. so we dont call perf_session__delete in case we propagate
> the signal.. also the outer function's cleanups are not called:
>
>         perf_evlist__delete(rec->evlist);
>         symbol__exit();
>
> the only cleanup I found that actually matters here and won't be
> called is 'vdso__exit' which removes the temp vdso library file.

Ah.. missed that.

>
> Maybe we could have one on_exit callback raising the signal
> if needed.. at the time we are sure we called all out cleanup
> functions.

Sounds like a good idea.  I'll send v6.

Thanks,
Namhyung
