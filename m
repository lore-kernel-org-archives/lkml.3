Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbbA2Iz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:55:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbbA2Iz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:55:56 -0500
Date: Thu, 29 Jan 2015 09:55:13 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: =?iso-8859-1?Q?J=E9r=E9mie?= Galarneau 
	<jeremie.galarneau@efficios.com>
Cc: Alexandre Montplaisir <alexmonthy@voxpopuli.im>,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Dominique Toupin <dominique.toupin@ericsson.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremie Galarneau <jgalar@efficios.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCHv3 0/8] perf tools: Add perf data CTF conversion
Message-ID: <20150129085513.GE7781@krava.brq.redhat.com>
References: <1421338556-20498-1-git-send-email-jolsa@kernel.org>
 <54B829D6.10003@voxpopuli.im>
 <54B92DAB.2020909@voxpopuli.im>
 <CA+jJMxu5sYbHA0wNpq0e1wnGOFR6C_0U4kc5UPqF==n89=NmEQ@mail.gmail.com>
 <20150125134316.GA31987@krava.brq.redhat.com>
 <CA+jJMxvskmK_8UhpZDZ5RvVW3znEOtqkkAp39D6cGKNEdoWHWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+jJMxvskmK_8UhpZDZ5RvVW3znEOtqkkAp39D6cGKNEdoWHWQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 05:37:56PM -0500, Jérémie Galarneau wrote:
> On Sun, Jan 25, 2015 at 8:43 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Fri, Jan 16, 2015 at 11:46:36AM -0500, Jérémie Galarneau wrote:
> >> On Fri, Jan 16, 2015 at 10:26 AM, Alexandre Montplaisir
> >> <alexmonthy@voxpopuli.im> wrote:
> >> > On 2015-01-15 03:57 PM, Alexandre Montplaisir wrote:
> >> >>
> >> >> Hi,
> >> >>
> >> >> I'm a developer for the Trace Compass tool (see links [3], [4] in Jiri's
> >> >> email). I can confirm that the generated CTF can be read correctly by our
> >> >> tool, which enables many views and analyses (Control Flow, CPU usage view,
> >> >> etc.) that were previously only available for LTTng traces.
> >> >>
> >> >> Some of our users also use perf extensively, and are looking forward to
> >> >> this feature! Is there any ETA as to when this will be merged upstream?
> >> >>
> >> >> Thanks,
> >> >> Alexandre
> >> >
> >> >
> >> > That was a bit too fast, it seems there are issues with very recent versions
> >> > of Babeltrace. You can follow the discussion at
> >> > http://lists.linuxfoundation.org/pipermail/diamon-discuss/2015-January/000007.html
> >> >
> >>
> >> It's a regression introduced by a commit that was pushed to master
> >> yesterday. I'm working on a fix.
> >> In the meantime, testing against Babeltrace master 3baf0856 should be alright.
> >
> > even on this HEAD I'm still getting the 3rd issue I described in earlier email:
> >
> >     ---
> >     the bt_ctf_trace_create_stream function tries to set ID on
> >     stream_class which gets frozen just few moments ago in
> >     bt_ctf_stream_create call..
> >
> >     this trigers failure and close up of stream fd which is not set yet:
> >
> >         if (close(stream->pos.fd)) {
> >                 perror("close");
> >         }
> >
> >     hence the 'close: Bad file descriptor' message
> >     so this one looks like a bug to me, but we might be misusing the API also..
> >     ---
> >
> > I need attached patch in perf code.. any idea?
> >
> 
> I have merged a patch addressing this problem. Thanks for reporting!

cool, seems to work perfectly.. thanks

I'll resend converter v4 shortly

jirka
