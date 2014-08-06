Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaHFKAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:00:13 -0400
Received: from [195.154.187.82] ([195.154.187.82]:55287 "EHLO ou.quest-ce.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbaHFKAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:00:11 -0400
Message-ID: <1407319200.3467.1.camel@localhost.localdomain>
From: Yann Droneaud <ydroneaud@opteya.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        William Cohen <wcohen@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>
Date: Wed, 06 Aug 2014 12:00:00 +0200
In-Reply-To: <20140803121036.GA1181@krava.brq.redhat.com>
References: <1406908014-8312-1-git-send-email-jolsa@kernel.org>
	 <1407002305.3573.12.camel@dworkin>
	 <20140803121036.GA1181@krava.brq.redhat.com>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 37.161.28.126
X-SA-Exim-Mail-From: ydroneaud@opteya.com
Subject: Re: [PATCH] perf tools: Fix PERF_FLAG_FD_CLOEXEC flag probing event
 type open counters due to EBUSY error
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le dimanche 03 août 2014 à 14:10 +0200, Jiri Olsa a écrit :
> On Sat, Aug 02, 2014 at 07:58:25PM +0200, Yann Droneaud wrote:

> heh, I haven't realized that your probing event was
> PERF_COUNT_SW_CPU_CLOCK, which could never be busy
> and found following bug ;-)
> 
> jirka
> 
> 
> ---
> We were using PERF_COUNT_SW_CPU_CLOCK as an probing event type.
> Using expected PERF_TYPE_SOFTWARE type instead.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: William Cohen <wcohen@redhat.com>
> Cc: Yann Droneaud <ydroneaud@opteya.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/cloexec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
> index dc360ebde745..0f7eb0a53d4b 100644
> --- a/tools/perf/util/cloexec.c
> +++ b/tools/perf/util/cloexec.c
> @@ -9,7 +9,7 @@ static int perf_flag_probe(void)
>  {
>  	/* use 'safest' configuration as used in perf_evsel__fallback() */
>  	struct perf_event_attr attr = {
> -		.type = PERF_COUNT_SW_CPU_CLOCK,
> +		.type = PERF_TYPE_SOFTWARE,
>  		.config = PERF_COUNT_SW_CPU_CLOCK,

erf ... I was even not able to copy paste correctly the configuration
used in perf_evsel__fallback(), my bad.

Thanks for the fix.

Regards.

-- 
Yann Droneaud
OPTEYA



