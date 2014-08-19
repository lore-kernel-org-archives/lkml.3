Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaHSPYD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:24:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbaHSPYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:24:00 -0400
Date: Tue, 19 Aug 2014 17:22:52 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [RFC 0/5] perf tools: Add perf data CTF conversion
Message-ID: <20140819152252.GA12806@krava.brq.redhat.com>
References: <1407327239-3493-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407327239-3493-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 02:13:54PM +0200, Jiri Olsa wrote:
> hi,
> this is initial post of the CTF converter for perf.
> Basically adding 'perf data convert' command to allow
> conversion of perf data file into CTF [1] data.
> 
> To convert perf data file run:
>   $ perf data convert --to-ctf=./ctf-data/
>   [ perf data convert: Converted 'perf.data' into CTF data './ctf-data/' ]
>   [ perf data convert: Converted and wrote 11.268 MB (100230 samples) ]
> 
> To display converted CTF data run [2]:
>   $ babeltrace ./ctf-data/
>   [03:19:13.962125533] (+?.?????????) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 1 }
>   [03:19:13.962130001] (+0.000004468) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 1 }
>   [03:19:13.962131936] (+0.000001935) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 8 }
>   [03:19:13.962133732] (+0.000001796) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 114 }
>   [03:19:13.962135557] (+0.000001825) cycles: { }, { ip = 0xFFFFFFFF8105443A, tid = 20714, pid = 20714, period = 2087 }
>   [03:19:13.962137627] (+0.000002070) cycles: { }, { ip = 0xFFFFFFFF81361938, tid = 20714, pid = 20714, period = 37582 }
>   [03:19:13.962161091] (+0.000023464) cycles: { }, { ip = 0xFFFFFFFF8124218F, tid = 20714, pid = 20714, period = 600246 }
>   [03:19:13.962517569] (+0.000356478) cycles: { }, { ip = 0xFFFFFFFF811A75DB, tid = 20714, pid = 20714, period = 1325731 }
>   [03:19:13.969518008] (+0.007000439) cycles: { }, { ip = 0x34080917B2, tid = 20714, pid = 20714, period = 1144298 }
> 
> It has still some limitations (noted in patches), but it has
> reached the point of the useful perf feature. More features
> and supports are about to come and it'll be better to continue
> publicly.
> 
> Also reachable in here:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   perf/core_ctf_convert

so I've put perf converted CTF stream into the eclipse CTF trace viewer
and got it displayed with the 'Generic CTF trace' type

The other type 'LTTng kernel trace' seems to set some rules for
the CTF fields/format the trace has to obey. Is this described
somewhere?

thanks,
jirka
