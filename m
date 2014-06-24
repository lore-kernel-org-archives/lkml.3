Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaFXPG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:06:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360AbaFXPGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:06:25 -0400
Date: Tue, 24 Jun 2014 11:06:15 -0400
From: Dave Jones <davej@redhat.com>
To: Josh Hunt <johunt@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Baron, Jason" <jbaron@akamai.com>
Subject: Re: [PATCH] panic: add TAINT_SOFTLOCKUP
Message-ID: <20140624150615.GA18176@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Josh Hunt <johunt@akamai.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Baron, Jason" <jbaron@akamai.com>
References: <1401847955-3345-1-git-send-email-johunt@akamai.com>
 <20140623151121.44f17779004e94ab620b837c@linux-foundation.org>
 <53A8ADEC.6070406@akamai.com>
 <20140623155118.e2446a6110a9889454db2386@linux-foundation.org>
 <53A9899C.9040005@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A9899C.9040005@akamai.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 09:22:20AM -0500, Josh Hunt wrote:
 
 > >> In addition to adding the softlockup taint flag, do you think it'd be
 > >> reasonable to add another flag for page allocation failures? I think
 > >> it'd be nice to be able to account for these conditions somehow without
 > >> having to parse dmesg, etc. As with the softlockup flag, it's helpful to
 > >> know if your system had encountered a page allocation failure at some
 > >> point before the crash or whatever you're debugging.
 > >
 > > I don't know, really.  Allocation failures are often an expected thing
 > > as drivers try to work out how much memory they can allocate.  Those
 > > things can be screened out by testing __GFP_NOWARN.  GFP_ATOMIC
 > > failures should probably be ignored, except for when they shouldn't.
 > > But even then, allocation failures are somewhat common.  And recency is
 > > a concern: an allocation failure 10 minutes ago is unlikely to be
 > > relevant.
 > >
 > > But that's just me waving hands around.  I'd be interested to hear from
 > > people whose kernels crash more often than mine, and from those whose
 > > job is to support them (ie distro people?).
 > >
 > 
 > Anyone you'd suggest adding to this thread to get other feedback about 
 > tracking page allocation failures? I could also spin up a patch and cc them.

For things like the fuzz test runs I do, I'd have to patch this out.

Things like migrate_pages() with bad arguments will trigger a page
allocation failure rather easily. Likewise set_mempolicy(), and a
handful of other vm syscalls.

There's also the case of "too fragmented to satisfy contiguous multi-page
allocation" which I walk into from time to time (when the kernel manages
to survive a fuzz run long enough, which isn't that often).

	Dave

