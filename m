Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbaIEPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:16:56 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:54980 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbaIEPQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:16:54 -0400
Subject: Re: [PATCH v2] perf tools: Fix build-id matching on vmlinux
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, stable@vger.kernel.org
In-Reply-To: <20140905141123.GE30520@kernel.org>
References: <1409893157-469-1-git-send-email-namhyung@kernel.org>
	 <540964C0.1050702@intel.com>  <20140905141123.GE30520@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Sep 2014 00:16:40 +0900
Message-ID: <1409930200.1662.16.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian and Arnaldo,

2014-09-05 (금), 11:11 -0300, Arnaldo Carvalho de Melo:
> Em Fri, Sep 05, 2014 at 10:22:40AM +0300, Adrian Hunter escreveu:
> > On 09/05/2014 07:59 AM, Namhyung Kim wrote:
> > > +++ b/tools/perf/util/machine.c
> > > @@ -1060,10 +1060,14 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
> > >  				strlen(kmmap_prefix));
> > >  		/*
> > >  		 * Should be there already, from the build-id table in
> > > -		 * the header.
> > > +		 * the header (but maybe with a different name: "vmlinux").
> > >  		 */
> > > -		struct dso *kernel = __dsos__findnew(&machine->kernel_dsos,
> > > -						     kmmap_prefix);
> > > +		struct dso *kernel = dsos__find(&machine->kernel_dsos,
> > > +						"vmlinux", true);
>  
> > Isn't "vmlinux" just the basename of the original file name, so if it had a
> > different name this wouldn't work e.g. if the filename had been
> > /boot/vmlinuz-3.11.0-26-generic then you would need
> > "vmlinuz-3.11.0-26-generic" for this to work?
> 
> Yeah, looking for well known pathnames to then check if the build-id
> matches the one we're looking for, be it because we obtained it from
> /sys/kernel/notes (for the running kernel), or from the perf.data file
> build-id table is ok, as we don't know where it is.
> 
> Plain sticking "vmlinux" there is not.

I don't get it.  AFAIK when perf record runs, it uses [kernel.kallsyms]
name for kernel map.  But it can be changed only if it found a "vmlinux"
file in the vmlinux_path[].  So short name will always be "vmlinux" -
okay, it might be vmlinux-$(uname -r) too; I can add it.

As you know, the vmlinux file is a ELF image that created during kernel
build process so I guess its name is fixed.  It's different from the
vmlinu"z" which resides in /boot directory.

Am I missing something?

Thanks,
Namhyung


