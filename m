Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaG1BcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 21:32:11 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:37369 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaG1BcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 21:32:09 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 28/52] perf script: Allow callchains if any event samples them
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
	<1406035081-14301-29-git-send-email-adrian.hunter@intel.com>
	<20140725132705.GJ7831@kernel.org>
Date: Mon, 28 Jul 2014 10:32:02 +0900
In-Reply-To: <20140725132705.GJ7831@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Fri, 25 Jul 2014 10:27:05 -0300")
Message-ID: <87bnsai7zh.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

On Fri, 25 Jul 2014 10:27:05 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jul 22, 2014 at 04:17:37PM +0300, Adrian Hunter escreveu:
>> perf script was not displaying callchains if any selected
>> event did not have PERF_SAMPLE_CALLCHAIN.  Change this to
>> disable callchains only if all selected events do not have
>> PERF_SAMPLE_CALLCHAIN.
>
> I wonder if some other tool gets this wrong as well, report maybe?
>
> Perhaps we need to have this check in some perf_evlist method?
>
> Wonder how report/top, i.e. the hists browser will react with some
> events having callchains while some don't, specially with this new
> children stuff, Namhyung, can you please check that?

The children/cumulate stuff is enabled if a combined sample type
contains PERF_SAMPLE_CALLCHAIN and works only a sample actually contains
callchain.

So I guess if some have it and some don't, events don't have callchain
just prints real entries/samples with same children overhead value.

Thanks,
Namhyung
