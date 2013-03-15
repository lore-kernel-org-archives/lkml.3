Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab3COUtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:49:03 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:45918 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386Ab3COUtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:49:01 -0400
MIME-Version: 1.0
In-Reply-To: <20130315203123.GA28128@kroah.com>
References: <20130315132607.GA4565@quad>
	<20130315203123.GA28128@kroah.com>
Date: Fri, 15 Mar 2013 21:49:00 +0100
Message-ID: <CABPqkBSp8jMUzsq3yg8uWkxyf7_HGjyJuuXt-VHhnjh0as-57w@mail.gmail.com>
Subject: Re: [PATCH] perf,x86: fix kernel crash with PEBS/BTS after suspend/resume
From: Stephane Eranian <eranian@google.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 15, 2013 at 9:31 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Mar 15, 2013 at 02:26:07PM +0100, Stephane Eranian wrote:
> >
> > This patch fixes a kernel crash when using precise sampling (PEBS)
> > after a suspend/resume. Turns out the CPU notifier code is not invoked
> > on CPU0 (BP). Therefore, the DS_AREA (used by PEBS) is not restored properly
> > by the kernel and keeps it power-on/resume value of 0 causing any PEBS
> > measurement to crash when running on CPU0.
> >
> > The workaround is to add a hook in the actual resume code to restore
> > the DS Area MSR value. It is invoked for all CPUS. So for all but CPU0,
> > the DS_AREA will be restored twice but this is harmless.
> >
> > Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Stephane Eranian <eranian@google.com>
> > ---
>
> Is this needed for the 3.8 or older kernels as well?
>
I suspect so. If CPU0 is not covered by the cpu notifiers
then yes, the patch is needed.

>
> thanks,
>
> greg k-h
