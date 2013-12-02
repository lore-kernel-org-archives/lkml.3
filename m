Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3LBI35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:29:57 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:50347 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab3LBI3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:29:54 -0500
X-AuditID: 9c93017d-b7b24ae000002834-41-529c45004fce
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv3 20/29] tools lib traceevent: Remove malloc_or_die from plugin_function.c
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
	<1385638408-23519-21-git-send-email-jolsa@redhat.com>
	<87eh5zpv5l.fsf@sejong.aot.lge.com>
	<20131129103707.GB1231@krava.brq.redhat.com>
	<CAM9d7cj2T-AP45ZSy+Q+_cGzHcm+sr7wpPD4Nu-Ud316hpFHDQ@mail.gmail.com>
	<20131129124249.GF1231@krava.brq.redhat.com>
Date: Mon, 02 Dec 2013 17:29:52 +0900
In-Reply-To: <20131129124249.GF1231@krava.brq.redhat.com> (Jiri Olsa's message
	of "Fri, 29 Nov 2013 13:42:49 +0100")
Message-ID: <87siubodtr.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Nov 2013 13:42:49 +0100, Jiri Olsa wrote:
> On Fri, Nov 29, 2013 at 10:54:21AM +0000, Namhyung Kim wrote:
>> > Removing malloc_or_die calls from plugin_function.c,
>> > replacing them and factoring the code with standard
>> > realloc and error path.
>> 
>> [SNIP]
>> >
>> >         if (cpu > cpus) {
>> > -               if (fstack)
>> > -                       fstack = realloc(fstack, sizeof(*fstack) * (cpu + 1));
>> > -               else
>> > -                       fstack = malloc_or_die(sizeof(*fstack) * (cpu + 1));
>> > +               fstack = realloc(fstack, sizeof(*fstack) * (cpu + 1));
>> 
>> This code also has same problem..
>> 
>
> and v3.1 ;-) thanks

Thank you for your effort.

Now the whole series looks all good to me (with other changes fixed).

Thanks,
Namhyung
