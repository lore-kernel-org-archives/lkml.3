Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbaCRPP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:15:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:4274 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752454AbaCRPP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:15:26 -0400
Date: Tue, 18 Mar 2014 11:15:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ben Widawsky <ben@bwidawsk.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH 2/5] tools lib traceevent: handle the '->' operator
Message-ID: <20140318111523.750c34a0@gandalf.local.home>
In-Reply-To: <CAM9d7ciC4RF_12cVxnJ-yLcwkHQf-bT+h38-imCib1UgHxsa=g@mail.gmail.com>
References: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
	<1395095198-20034-3-git-send-email-artagnon@gmail.com>
	<87ha6wrl8h.fsf@sejong.aot.lge.com>
	<CALkWK0mODh_R9p10q2VPcJK4qnmNuJfQJm5wv2Rr=+cn+X-LDQ@mail.gmail.com>
	<CAM9d7ciC4RF_12cVxnJ-yLcwkHQf-bT+h38-imCib1UgHxsa=g@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 23:18:24 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Ramkumar,
> 
> On Tue, Mar 18, 2014 at 11:12 PM, Ramkumar Ramachandra
> <artagnon@gmail.com> wrote:
> > Hi Namhyung,
> >
> > On Tue, Mar 18, 2014 at 3:58 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> >> Hmm.. AFAIK we don't support the '->' operator so I think it's an error
> >> in the callsite.  Where do you see the message though?  I couldn't find
> >> it on my setup.
> >>
> >> I'd also like to add following patch to see the location of parse
> >> failure easily.
> >
> > I applied your patch and ran 'perf test'. I get:
> >
> >   Warning: [i915:i915_gem_evict_vm] unknown op '->'
> >
> > So, where should we dig to find this callsite?
> 
> /sys/kernel/debug/tracing/events/i915/i915_gen_evict_vm/format :)
> 

Actually, that's a bug in the kernel. You should *NEVER* redirect from
the ring buffer. There's no guarantee that the data still exists and
this can cause a kernel oops.

-- Steve
