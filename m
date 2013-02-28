Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab3B1IoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:44:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab3B1IoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:44:13 -0500
Message-ID: <512F18D6.4080104@suse.cz>
Date: Thu, 28 Feb 2013 09:44:06 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Dave Jones <davej@redhat.com>,
        David Howells <dhowell@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>, x86@kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
Subject: Re: [PATCH 0/3] build linux-next without perl
References: <1361944667.957820@landley.net> <20130227135155.c04453db.akpm@linux-foundation.org>
In-Reply-To: <20130227135155.c04453db.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.2.2013 22:51, Andrew Morton wrote:
> It'll need to be reasonably good motivation, too.  Because not only do
> we need to patch the kernel, we also need to *maintain* its
> perl-freeness and fix up perlisms as they later get added by others.
> 
> (Perhaps one way of doing this would be to disable perl in regular
> builds, so even if a developer has perl installed on his machine, his
> build will still fail when he invokes it.  Add "PERL=/dev/null" to some
> build targets in some manner.)

I don't think we need to go this far. Apparently, there are people who
want to be able to build the kernel without perl, so let's rely on them
to report if perl appears again as a hard build dependency. If these
people lose interest, then after some time we might end up with perl
being required again, but then this by definition won't be a problem for
anyone who cares.

It is like bashisms in shell scripts and Makefile commands. They should
be avoided, but it wasn't until Debian and Ubuntu switched to /bin/sh ->
dash when we started to fix them. Nowadays, the kernel should build file
with a minimal POSIX shell, but we did not need any
SHELL=$(objtree)/scripts/dash to achieve this.

Michal
