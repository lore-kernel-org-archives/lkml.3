Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaBZPn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:43:59 -0500
Received: from blackhole.sdinet.de ([176.9.52.58]:56548 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbaBZPn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:43:56 -0500
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Feb 2014 10:43:56 EST
Date: Wed, 26 Feb 2014 16:36:33 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Dave Hansen <dave.hansen@intel.com>
cc: Alexander Graf <agraf@suse.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] ksm: Expose configuration via sysctl
In-Reply-To: <530D3102.60504@intel.com>
Message-ID: <alpine.DEB.2.10.1402261634010.31425@aurora64.sdinet.de>
References: <1393284484-27637-1-git-send-email-agraf@suse.de> <530CD443.7010400@intel.com> <4B3C0B08-45E1-48EF-8030-A3365F0E7CF6@suse.de> <530D3102.60504@intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Feb 2014, Dave Hansen wrote:

> On 02/25/2014 03:09 PM, Alexander Graf wrote:
> >> Couldn't we also (maybe in parallel) just teach the sysctl userspace
> >> about sysfs?  This way we don't have to do parallel sysctls and sysfs
> >> for *EVERYTHING* in the kernel:
> >>
> >>    sysfs.kernel.mm.transparent_hugepage.enabled=enabled
> > 
> > It's pretty hard to filter this. We definitely do not want to expose all of sysfs through /proc/sys. But how do we know which files are actual configuration and which ones are dynamic system introspection data?
> > 
> > We could add a filter, but then we can just as well stick with the manual approach I followed here :).
> 
> Maybe not stick it under /proc/sys, but teach sysctl(8) about them.  I
> guess at the moment, sysctl says that it's tied to /proc/sys:
> 
> > DESCRIPTION
> >        sysctl  is  used to modify kernel parameters at runtime.  The parameters available are those listed under /proc/sys/.  Procfs is required
> >        for sysctl support in Linux.  You can use sysctl to both read and write sysctl data.
> 
> But surely that's not set in stone just because the manpage says so. :)

What I still don't get is why you need this?

My distribution (Debian) has a sysfsutils package which provides a 
/etc/sysfs.conf / /etc/sysfs.d/foo exactly like /etc/sysctl.conf.

Don't other distributions have something like this?

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
