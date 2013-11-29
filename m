Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3K2Kyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:54:43 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:51765 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab3K2Kyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:54:41 -0500
MIME-Version: 1.0
In-Reply-To: <20131129103707.GB1231@krava.brq.redhat.com>
References: <1385638408-23519-1-git-send-email-jolsa@redhat.com>
 <1385638408-23519-21-git-send-email-jolsa@redhat.com> <87eh5zpv5l.fsf@sejong.aot.lge.com>
 <20131129103707.GB1231@krava.brq.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 29 Nov 2013 10:54:21 +0000
X-Google-Sender-Auth: xynUY_vlOvmQvYuvm1XWbNISRBo
Message-ID: <CAM9d7cj2T-AP45ZSy+Q+_cGzHcm+sr7wpPD4Nu-Ud316hpFHDQ@mail.gmail.com>
Subject: Re: [PATCHv3 20/29] tools lib traceevent: Remove malloc_or_die from plugin_function.c
To: Jiri Olsa <jolsa@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Removing malloc_or_die calls from plugin_function.c,
> replacing them and factoring the code with standard
> realloc and error path.

[SNIP]
>
>         if (cpu > cpus) {
> -               if (fstack)
> -                       fstack = realloc(fstack, sizeof(*fstack) * (cpu + 1));
> -               else
> -                       fstack = malloc_or_die(sizeof(*fstack) * (cpu + 1));
> +               fstack = realloc(fstack, sizeof(*fstack) * (cpu + 1));

This code also has same problem..

Thanks,
Namhyung


> +               if (!fstack) {
> +                       warning("could not allocate plugin memory\n");
> +                       return 0;
> +               }
>
>                 /* Account for holes in the cpu count */
>                 for (i = cpus + 1; i <= cpu; i++)
> --
> 1.8.3.1
>
