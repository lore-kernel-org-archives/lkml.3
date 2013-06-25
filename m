Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab3FYOqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:46:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab3FYOqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:46:06 -0400
Date: Tue, 25 Jun 2013 16:45:29 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 12/15] perf tools: allow non-matching sample types
Message-ID: <20130625144529.GL23329@krava.brq.redhat.com>
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
 <1372079772-20803-13-git-send-email-adrian.hunter@intel.com>
 <CABPqkBRoRgHUM5ahHmvYXJ1BkHncm9Z2GZkzuRFbsNfh4=HJ6g@mail.gmail.com>
 <51C98969.40401@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C98969.40401@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 03:13:29PM +0300, Adrian Hunter wrote:
> On 25/06/13 14:23, Stephane Eranian wrote:
> > On Mon, Jun 24, 2013 at 3:16 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> >> Sample types need not be identical to determine
> >> the sample id from the event.  Only the position
> >> of the sample id needs to be the same.
> >>
> >> Compatible sample types are ones in which the bits
> >> defined by PERF_COMPAT_MASK are the same.
> >> 'perf_evlist__config()' forces sample types to be
> >> compatible on that basis.
> >>

nice idea

> > This is indeed a major flaw of the current sampling buffer format.
> > I have a patch coming to address this from the kernel side.
> > 
> > I am trying to understand this patch and I am confused by the
> > description and especially the structure of COMPAT_MASK.
> > 
> > I agree that if the SAMPLE_ID position remains constant then
> > it can be extracted from the body of the sample uniformly.
> > The only way to guarantee a fixed position is by ensuring that
> > all the sample_types before SAMPLE_ID and either set or
> > unset. By before I don't mean in the enum order but in the
> > order in which the kernel lays them various sample_types
> > in the buffer. And that's determined by perf_output_sample().
> > So I don't understand why PERF_SAMPLE_CPU and
> > PERF_SAMPLE_STREAM_ID  are here.
> > 
> > Any explanation?

+1 for more comments in changelog and code ;-)

> 
> There are 2 sample formats: one for sample events and one for other events
> (the id sample).  In perf tools refer __perf_evsel__parse_sample() vs
> perf_evsel__parse_id_sample().

For non sample events the ID info is stored backwards via:
__perf_event__output_id_sample kernel func.

Why do you use PERF_SAMPLE_STREAM_ID in this case instead
of the PERF_SAMPLE_ID as for sample events.. ? apart from
one more condition in __perf_evsel__calc_is_pos function.

AFAICS PERF_SAMPLE_STREAM_ID holds same id value as PERF_SAMPLE_ID,
but I guess it has some other meaning.. if not for now, maybe meant
something else for the future ;-) not sure

jirka
