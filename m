Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbaD3NgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:36:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbaD3NgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:36:22 -0400
Date: Wed, 30 Apr 2014 09:35:55 -0400
From: Don Zickus <dzickus@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 00/17] perf report: Add -F option for specifying
 output fields (v4)
Message-ID: <20140430133554.GB61249@redhat.com>
References: <1397617554-26319-1-git-send-email-namhyung@kernel.org>
 <20140422211647.GO8488@redhat.com>
 <87lhuwr2pk.fsf@sejong.aot.lge.com>
 <20140423125828.GL5328@redhat.com>
 <1398346899.1681.18.camel@leonhard>
 <20140424210015.GJ8488@redhat.com>
 <20140428194642.GQ5328@redhat.com>
 <878uqpos3k.fsf@sejong.aot.lge.com>
 <20140429172735.GD32375@redhat.com>
 <874n1bpuzh.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874n1bpuzh.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 08:38:10AM +0900, Namhyung Kim wrote:
> Hi Don,
> 
> On Tue, 29 Apr 2014 13:27:35 -0400, Don Zickus wrote:
> > On Tue, Apr 29, 2014 at 10:13:35AM +0900, Namhyung Kim wrote:
> >> >        /*
> >> >         * Addresses with no major/minor numbers are assumed to be
> >> >         * anonymous in userspace.  Sort those on pid then address.
> >> >         *
> >> >         * The kernel and non-zero major/minor mapped areas are
> >> >         * assumed to be unity mapped.  Sort those on address.
> >> >         */
> >> >
> >> >        if ((left->cpumode != PERF_RECORD_MISC_KERNEL) &&
> >> >            !l_map->maj && !l_map->min && !l_map->ino &&
> >> >            !l_map->ino_generation) {
> >> >                /* userspace anonymous */
> >> >
> >> >                if (left->thread->pid_ > right->thread->pid_) return -1;
> >> >                if (left->thread->pid_ < right->thread->pid_) return 1;
> >> 
> >> Isn't it necessary to check whether the address is in a same map in case
> >> of anon pages?  I mean the daddr.al_addr is a map-relative offset so it
> >> might have same value for different maps.
> >
> > That's why I sort on pids here.  Because the anon address might have the
> > same value for different maps.  The thought was to group all the pid
> > addresses together to keep things seperated.
> >
> > Do you see a different way to solve the problem?  I am not sure al_addr
> > vs. addr will make much difference here.
> 
> I'm not saying to get rid of the pid check, I'm saying that it might
> need to add another check for maps (i.e. start address) as there might
> be many maps in a single address space.

Hmm, I guess I would need to see an example.  While I agree there might be
many maps in a single address space (/proc/<pid>/maps demonstrates that),
I understood them to map to a unique location (ie no overlap) unless they
are shared.

I am willing to believe I missed scenario when sorting, I just can't think
of it (so I wouldn't know how to fix it).  That's why I was looking for an
example to make it more obvious to me.  Sorry for being slow..

Cheers,
Don
