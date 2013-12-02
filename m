Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab3LBO55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:57:57 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:61546 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab3LBO5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:57:52 -0500
Subject: Re: [PATCH 2/3] perf tools: Record sampling time for each entry
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20131202123918.GE2371@ghostprotocols.net>
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
	 <1385967199-3759-3-git-send-email-namhyung@kernel.org>
	 <20131202123918.GE2371@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Dec 2013 23:57:44 +0900
Message-ID: <1385996264.1710.26.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-12-02 (월), 09:39 -0300, Arnaldo Carvalho de Melo:
> Em Mon, Dec 02, 2013 at 03:53:18PM +0900, Namhyung Kim escreveu:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> > 
> > Calculate elapsed time for each sample and record it.  The elapsed
> > time is a diff between current sample->time and previous sample->time
> > which was saved for each evsel and cpu.
> 
> Can you elaborate on why this is interesting to have? What meaning can
> one get from the sample->time - prev_sample->time?
> 
> We need clearer changelogs...

Sorry about that.. how about this?

Sometimes users might want see a relation between value and time of a
sample.  And the time itself is a very important information to have.
As the sample->period value is a diff of counter values between samples
it might make sense to add time-diff between samples into a hist entry.

To do that, calculate elapsed time for each sample and record it.  The
elapsed time is the diff between current sample->time and previous
sample->time which was saved for each evsel.

Thanks,
Namhyung


