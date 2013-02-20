Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3BTVyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 16:54:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab3BTVyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 16:54:05 -0500
Date: Wed, 20 Feb 2013 22:18:19 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf x86: Change SandyBridge and IvyBrige instructions
 event to be precise
Message-ID: <20130220211819.GA14253@krava.redhat.com>
References: <1361392794-16552-1-git-send-email-jolsa@redhat.com>
 <m2ppzuyaao.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2ppzuyaao.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 12:55:59PM -0800, Andi Kleen wrote:
> Jiri Olsa <jolsa@redhat.com> writes:
> 
> > Changing the default 'instructions' HW event for SandyBridge and
> > IvyBrige to use the available precise 'instructions' event.
> >
> > The precise event is defined in Intel SDM as:
> >
> > INST_RETIRED.ALL - Precise instruction retired event with HW to
> > reduce effect of PEBS shadow in IP distribution
> >
> > for both SandyBridge and IvyBrige micro-archs. It allows to use
> > precise modifier on 'instructions' event on SandyBridge and
> > IvyBrige micro-archs which is not possible now.
> 
> Actually it's possible, you just have to use it explicitely.
> 
> This will break a lot of profiling setups that assume instructions
> count on the fixed counter and use the 4/8 other counters. 
> Also it will give very bad results with perf stat, which
> you don't want to run with pebs.

right, I haven't realized that..

> 
> Even worse with your change the fixed instruction counter is not
> accessible anymore. So pretty much all the standard setups

still could be used explicitly via cpu/event=0xc0/

> that collect it in addition to other events and fill all 
> the counters would break.
> 
> I don't think it should be done by default, but yes explicitely
> it's quite useful.
> 
> My Haswell patchkit (in the "extended version") exposes
> the precise event as "instructions-p" through sysfs.

will check

thanks,
jirka
