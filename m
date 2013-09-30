Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab3I3RwH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:52:07 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:59066 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3I3RwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:52:05 -0400
Date: Mon, 30 Sep 2013 14:46:39 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] perf auto-dep: Speed up feature tests by building them
 in parallel
Message-ID: <20130930174639.GH10293@ghostprotocols.net>
References: <20130912200236.GC11400@ghostprotocols.net>
 <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
 <20130930171220.GC10293@ghostprotocols.net>
 <20130930172741.GD10293@ghostprotocols.net>
 <20130930173052.GE10293@ghostprotocols.net>
 <20130930173627.GF10293@ghostprotocols.net>
 <20130930173914.GG10293@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930173914.GG10293@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 30, 2013 at 02:39:14PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Sep 30, 2013 at 02:36:27PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Another suggestion: To provide a short sentence with each feature
> > stating what will be not present when something is "OFF", or even a
> > sentence stating what the feature is about, so the user get a better
> > picture of what is (not) being built into his tool.
> > 
> > Probably reusing strings we already have in the makefiles.
> 
> And also reusing existing strings to tell the user which devel packages
> should be installed to get that feature built/enabled.

config/Makefile:187: No libelf found, disables 'probe' tool, please install elfutils-libelf-devel/libelf-dev
config/Makefile:251: No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99
config/Makefile:279: slang not found, disables TUI support. Please install slang-devel or libslang-dev
config/Makefile:292: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
config/Makefile:346: The path '/usr/bin/python-config' is not executable.
config/Makefile:350: No python-config tool was found
config/Makefile:350: Python support will not be built
config/Makefile:444: No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev

My bad, its still there, sorry for the noise 8-)

I'm testing removing devel packages, one by one, removing gtk2-devel provides
the biggest reduction in build time, no surprises :)

- Arnaldo
