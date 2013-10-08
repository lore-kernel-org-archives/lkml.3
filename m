Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab3JHKu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:50:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61428 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392Ab3JHKuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:50:24 -0400
Message-ID: <1381229421.15686.17.camel@marge.simpson.net>
Subject: Re: perf: perf sched lat segfault - bisected
From: Mike Galbraith <bitbucket@online.de>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 08 Oct 2013 12:50:21 +0200
In-Reply-To: <CABPqkBSpTPttig8uKdR2KJba8rwOe3P1sKPjkVizVGH=H+w-9Q@mail.gmail.com>
References: <1381221715.15686.3.camel@marge.simpson.net>
	 <CABPqkBRMa7rawfvQ2Sunc2tr87s_WqT_7GYac6+x=SNZoJSueg@mail.gmail.com>
	 <1381227252.15686.9.camel@marge.simpson.net>
	 <1381227659.15686.11.camel@marge.simpson.net>
	 <CABPqkBQD9TE7RbP-auXO060aU1QNU=RUw2QZvoF39CCqpzdC4w@mail.gmail.com>
	 <CABPqkBSpTPttig8uKdR2KJba8rwOe3P1sKPjkVizVGH=H+w-9Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:kgRJ3N1jK4eqwJVrHkK6iVFCZhb3PNlfXphM0BD6SfI
 1PKvnUpvgdTrqzWhbXcfgWLJolgAPgAkRovrAgSFQLklx8U5BV
 U7gHARi5aNh/bfzkjFPqVZQVCQN3dLNtaeKDNSKQrdYbexe4Kh
 d7aMPaHkApUySJu+CHpQk11FSFDNSdxvbiaOyn3XUecLtTI3rt
 wPxaTZooX93vCLBgDnfTnYzxRfGx71bc51ymJealie30rSFwDA
 TwMOWhG//0eedfY63ydV5t8sjO5d/JeUEWUjylIFh49q9m0wLz
 Owm/XpDo4sqDkqg3R9+FTukg/JvgdMqDMAT5kWpYkOziVf4LmP
 6kDI0DnmBL2Z7kVKKP9owB4vZ2j+fNFy1ELu6KrrboVZPErBmu
 YBKA6wQoby9wQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 12:36 +0200, Stephane Eranian wrote: 
> Mike,
> 
> I found the problem in perf. The tool->mmap2 pointer is NULL for sched tool.
> Let me send you a patch to fix this.

Ah, no need.  It's probably something like so, which fixed it.

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c 
index d8c51b2f263f..a60d14dd18e7 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1658,6 +1658,7 @@ static struct perf_sched sched = {
                .comm            = perf_event__process_comm,
                .lost            = perf_event__process_lost,
                .fork            = perf_sched__process_fork_event,
+               .mmap2           = perf_event__process_mmap2,
                .ordered_samples = true,
        },
        .cmp_pid              = LIST_HEAD_INIT(sched.cmp_pid),


