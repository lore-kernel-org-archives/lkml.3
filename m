Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab3AaLfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:35:06 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:43409 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3AaLfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:35:00 -0500
Date: Thu, 31 Jan 2013 12:34:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC/PATCH] perf x86: Add off-core event constraints for
 Sandy/IvyBridge micro architecture
Message-ID: <20130131113456.GE4587@gmail.com>
References: <1359307995-30640-1-git-send-email-jolsa@redhat.com>
 <CABPqkBSKGMUAdbqRGUWoaMH1McLDGgZUfHw3P4BAAOLSDYjH8Q@mail.gmail.com>
 <20130129154918.GH8339@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129154918.GH8339@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> On Mon, Jan 28, 2013 at 06:49:55PM +0100, Stephane Eranian wrote:
> > On Sun, Jan 27, 2013 at 6:33 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > > hi,
> > > I was looking at the offcore stuff and it looks like we might
> > > be missing some constraints for offcore response events on
> > > Sandy/IvyBridge.
> > >
> > > The table 18.8.5 (Off-core Response Performance Monitoring)
> > > in Intel SDM states PMC0 for 0xb7 and PMC3 for 0xbb, but
> > > there's no other explanation or related description.
> > >
> > > I can't say/ack if the counters looks bad or right with or
> > > without the patch so far.. so just curious ;-)
> > >
> > Those are artificial constraints which should not be there.
> > Remember that offcore_rsp uses an extra MSR which has
> > to be shared by all the counters on the PMU. So a way to
> > handle the sharing of that extra MSR is to impose an
> > artificial constraint on the event itself. If it can only run
> > on one counter, then you get the management of the
> > extra MSR for free, i.e., only one event gets it.
> > 
> > In perf_events, we use a more sophisticated dynamic scheme
> > which does not use this artificial constraint. We can measure
> > the event multiple times and share the extra MSR if possible
> > (same value). Why multiple times you might ask? For instance,
> > with different priv levels.
> > 
> > 
> > Hope this helps.
> 
> nice, thanks a lot for explanation

Would be nice to stick this into the code somewhere appropriate, 
AFAICS this information only lives in older commit logs atm.

Thanks,

	Ingo
