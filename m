Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3JHMs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:48:28 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:37752 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab3JHMs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:48:27 -0400
Date: Tue, 8 Oct 2013 14:48:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH 00/50] tools/perf: Speed up the build system
Message-ID: <20131008124822.GA3438@gmail.com>
References: <1381147003-2574-1-git-send-email-mingo@kernel.org>
 <5252BCB4.5030802@gmail.com>
 <20131007141100.GA21873@gmail.com>
 <5252D4DB.30302@gmail.com>
 <20131007164156.GA12790@gmail.com>
 <525362C1.4010402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525362C1.4010402@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> > This is just the print-out though - the actual feature logic should 
> > still follow the NO_DWARF=1 setting (modulo bugs).
> >
> > So I'm wondering, should we solve this by adding extra logic linking 
> > the feature flags with their legacy names. It would get unwieldy 
> > rather quickly I think.
> 
> yes.
> 
> > Another solution would be to introduce a new method to disable 
> > features, via something like:
> >
> >	make FEATURE_dwarf=0
> >
> > Where the pattern would follow the auto-detected naming. This would 
> > simplify the printout logic and would simplify the feature support / 
> > flags decision tree as well.
> >
> > Furthermore, it would unify the various flags we have today, which is 
> > rather mixed: for example there's NO_DWARF which is a name that shows 
> > negated logic, but there's also HAVE_CPLUS_DEMANGLE_SUPPORT is is a 
> > name with positive logic. We'd have one uniform naming scheme 
> > permeating the whole build system.
> 
> The Kconfig series converts all of the NO_XXXXX to CONFIG_XXXXX. I'd 
> like to see that because it mirrors kernel configs and is a stepping 
> stone to kconf integration.

Yeah.

It also negates NO_XXXXX use back to straight logic, right?

I.e. CONFIG_LIBSLANG=y should mean that libslang is enabled, 
CONFIG_LIBSLANG undefined means that it's disabled.

These could then also be passed straight to the build system:

  make CONFIG_LIBSLANG=0

should have the same effect as NO_LIBSLANG. The old NO_XXXXX flags would 
go away.

Maybe we could also force features on via:

  make CONFIG_LIBSLANG=1

this could be used to work around auto-detection failures, and could be 
used to check whether a feature check is precise.

This:

  make CONFIG_ALL=1

could perhaps be a handy shortcut to force-enable all features [that make 
sense on an architecture] - for package builds.

> If the NO_XXXX takes precedence over the autoprobe detection then the 
> user gets what is asked, so I guess we can leave it as is for now.

Okay. I'll try to leave it alone as much as possible, to not upset your 
kconfig series even more ...

Thanks,

	Ingo
