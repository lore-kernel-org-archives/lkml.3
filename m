Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab3CYMPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 08:15:10 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:52259 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab3CYMPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 08:15:08 -0400
MIME-Version: 1.0
In-Reply-To: <1364211788.5053.3.camel@laptop>
References: <1363949499-3728-1-git-send-email-eranian@google.com>
	<1363949499-3728-3-git-send-email-eranian@google.com>
	<1364211788.5053.3.camel@laptop>
Date: Mon, 25 Mar 2013 13:15:07 +0100
Message-ID: <CABPqkBSAqd25rGLiK6AOwu8QRrA3jKV=A0zDKpWaFikYd3dKSg@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] perf: add sysfs entry to adjust multiplexing
 interval per PMU
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 12:43 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, 2013-03-22 at 11:51 +0100, Stephane Eranian wrote:
> > In the 4th version, we renamed the sysfs file to be more
> > consistent with the other /proc/sys/kernel entries for
> > perf_events.
>
> >  static struct device_attribute pmu_dev_attrs[] = {
> > -       __ATTR_RO(type),
> > -       __ATTR_NULL,
> > +       __ATTR_RO(type),
> > +       __ATTR_RW(perf_event_mux_interval_ms),
> > +       __ATTR_NULL,
> >  };
>
> but but but, the file doesn't live in /proc/sys/kernel/, its in
> /sys/bus/event_source/devices/*/$foo and none of the files there are
> perf_event_* prefixed.
>
True. Some leftover from the earlier patch. The sysfs entry is now
per pmu instance. So yes, it is in /sys/devices/*/

>
> Other than that, the patches look fine.
>
Thanks.
