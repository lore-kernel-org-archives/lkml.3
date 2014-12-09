Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaLIKTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:19:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992AbaLIKTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:19:08 -0500
Date: Tue, 9 Dec 2014 11:18:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 6/8] perf data: Switch to multiple cpu stream files
Message-ID: <20141209101828.GD2516@krava.brq.redhat.com>
References: <1417623842-14331-1-git-send-email-jolsa@kernel.org>
 <1417623842-14331-7-git-send-email-jolsa@kernel.org>
 <CAM9d7cg7EdhQ8f_yA_aHrOgbM9axW1sr+Jzw+Mfwr1kkwQZGpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9d7cg7EdhQ8f_yA_aHrOgbM9axW1sr+Jzw+Mfwr1kkwQZGpg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 05:17:44PM +0900, Namhyung Kim wrote:
> On Thu, Dec 4, 2014 at 1:24 AM, Jiri Olsa <jolsa@kernel.org> wrote:
> > +static int setup_streams(struct ctf_writer *cw, struct perf_session *session)
> > +{
> > +       struct ctf_stream **stream;
> > +       struct perf_header *ph = &session->header;
> > +       int ncpus;
> > +
> > +       /*
> > +        * Try to get the number of cpus used in the data file,
> > +        * if not present fallback to the MAX_CPUS.
> > +        */
> > +       if (!ph)
> 
> I think this check is meaningless since perf_header struct is embedded
> in perf_session so it shouldn't be NULL when refered from a session..

right, it's actually different in the git, I used:

        if (!ph || !ph->env.nr_cpus_avail)
                ncpus = MAX_CPUS;

I attached slightyl older version in email :-\

anyway, I'll send v2 shortly 

thanks,
jirka
