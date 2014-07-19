Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbaGSHzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 03:55:45 -0400
Received: from 8bytes.org ([81.169.241.247]:49134 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbaGSHzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 03:55:44 -0400
Date: Sat, 19 Jul 2014 09:55:40 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140719075540.GH30979@8bytes.org>
References: <1405684643-30234-1-git-send-email-joro@8bytes.org>
 <2105930.LcBFYOUaLE@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2105930.LcBFYOUaLE@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Sat, Jul 19, 2014 at 12:05:02AM +0200, Rafael J. Wysocki wrote:
> On Friday, July 18, 2014 01:57:17 PM Joerg Roedel wrote:
> > here is a patch set to improve the scalability of the memory
> > bitmap implementation used for hibernation. The current
> > implementation does not scale well to machines with several
> > TB of memory. A resume on those machines may cause soft
> > lockups to be reported.
> 
> Looks good.
> 
> How much testing did that receive?

Well, I did function testing of the radix tree and the old memory bitmap
in parallel (patches 1-4) and looked for the warnings to trigger in case
the bitmaps return different results. With these patches the radix tree
produced always the same results as the old implementation (none of the
warnings did trigger).

I first tested with KVM (64 bit and 32 bit x86 guest) and later on real
amd64 machines. One of our partners tested the patches on a 1TB, a 4TB
and a 12TB memory machine, always with positive result.

Thanks,

	Joerg

