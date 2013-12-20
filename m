Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab3LTBgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 20:36:37 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61011 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab3LTBgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 20:36:36 -0500
X-AuditID: 9c930197-b7cefae000007949-2f-52b39f2244a9
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/6] perf report: Use pr_*() functions if possible
References: <1387436411-20160-1-git-send-email-namhyung@kernel.org>
	<1387436411-20160-2-git-send-email-namhyung@kernel.org>
	<20131219133154.GB3568@krava.brq.redhat.com>
Date: Fri, 20 Dec 2013 10:36:34 +0900
In-Reply-To: <20131219133154.GB3568@krava.brq.redhat.com> (Jiri Olsa's message
	of "Thu, 19 Dec 2013 14:31:54 +0100")
Message-ID: <87eh58e21p.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Thu, 19 Dec 2013 14:31:54 +0100, Jiri Olsa wrote:
> On Thu, Dec 19, 2013 at 04:00:06PM +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> There're some places printing a message to stdout/err directly.  It
>> should be converted to use proper error printing functions instead.
>> 
>> If it's not possible, just do it when --stdio was enabled only.
>> 
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>
> Maybe it'd be worthwhile to factor perf_session__fprintf*
> functions so the info could end up in the log window.

I thought about it too.  And then considered something like below:

  FILE *sfp = open_memstream(&ptr, &size);
  perf_session__fprintf*(session, sfp, ...);
  fclose(sfp);

  perf_log_add(ptr);
  fprintf(orig_fp, "%s", ptr);

  free(ptr);


What do you think?

>
> Acked-by: Jiri Olsa <jolsa@redhat.com>

Thanks!
Namhyung
