Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab3C0OsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:48:17 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:43780 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3C0OsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:48:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130327143437.GE1092@krava.brq.redhat.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
	<1359040242-8269-12-git-send-email-eranian@google.com>
	<20130327141425.GC1092@krava.brq.redhat.com>
	<1364394014.5053.76.camel@laptop>
	<20130327143437.GE1092@krava.brq.redhat.com>
Date: Wed, 27 Mar 2013 15:48:15 +0100
Message-ID: <CABPqkBSSBdzGJtJ6HLFCM_Hhnwv1ASZ=JCX+zpWcM5X3KwZk6w@mail.gmail.com>
Subject: Re: [PATCH v7 11/18] perf tools: add mem access sampling core support
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 3:34 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Mar 27, 2013 at 03:20:14PM +0100, Peter Zijlstra wrote:
> > On Wed, 2013-03-27 at 15:14 +0100, Jiri Olsa wrote:
> > > we have correct cpumode for sample->ip, but I think it's the
> > > PEBS->dla (sample->addr) where we need to guess.. right?
> >
> > kernel mode very much fakes the cpumode/segment stuff for PEBS. PEBS
> > assumes you're running in a linear/flat mode.
> >
>
> say we hit the sample when kernel accesses the user data, we will endup
> with IP in kernel space and DATA ptr in user space.. in theory ;-)
>
Yes, this is possible. So I think we could probably leaverage ip__resolve_ams()
and pass the extra parameter for MAP_VARIABLE vs. MAP_FUNCTION.


>
> and that would need the cpumode guessing for DATA ptr, because
> cpumode value is deduced from cs register
>
> jirka
