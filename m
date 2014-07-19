Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744AbaGSK01 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 06:26:27 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36902 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166AbaGSK0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 06:26:25 -0400
Date: Sat, 19 Jul 2014 12:26:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140719102623.GA837@amd.pavel.ucw.cz>
References: <1405684643-30234-1-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405684643-30234-1-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> here is a patch set to improve the scalability of the memory
> bitmap implementation used for hibernation. The current
> implementation does not scale well to machines with several
> TB of memory. A resume on those machines may cause soft
> lockups to be reported.
> 
> These patches improve the data structure by adding a radix
> tree to the linked list structure to improve random access
> performance from O(n) to O(log_b(n)), where b depends on the
> architecture (b=512 on amd64, 1024 in i386).
> 
> A test on a 12TB machine showed an improvement in resume
> time from 76s with the old implementation to 2.4s with the
> radix tree and the improved swsusp_free function. See below
> for details of this test.

Ok, nice.

How did space requirements change?

In particular, do we need to reserve a bit more pages for hibernation
now?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
