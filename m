Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaKFMjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:39:12 -0500
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:41035 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaKFMjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:39:08 -0500
Date: Thu, 6 Nov 2014 21:39:04 +0900
From: Norbert Preining <preining@logic.at>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: khugepaged / firefox going wild in 3.18-rc
Message-ID: <20141106123904.GU11838@auth.logic.tuwien.ac.at>
References: <20141104232027.GO13232@auth.logic.tuwien.ac.at>
 <alpine.DEB.2.10.1411041559170.2720@chino.kir.corp.google.com>
 <20141105001026.GQ13232@auth.logic.tuwien.ac.at>
 <20141105001243.GR13232@auth.logic.tuwien.ac.at>
 <alpine.DEB.2.10.1411041615270.5391@chino.kir.corp.google.com>
 <545B68C9.2060107@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545B68C9.2060107@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vlastimil

thanks for your answer.

In the meantime I have tried rc3, too, with the same effects.

Interestingly, once it goes into a bad state, every future approach
does the same. I started shotwell (photo organizer) and it went into the
same state (khugepaged / shotwell each using about 100% of CPu time).

On Thu, 06 Nov 2014, Vlastimil Babka wrote:
> Could be that another task holds the mmap_sem during THP allocation attempt on
> its own page fault, and compaction goes in some kind of infinite loop. There are

My feeling somehow is about the plugin-container in firefox ...
(flashplayer or something similar, but I might be wrong!). With shotwell,
I have no idea why.

> I suggested testing a commit revert in one thread, and a possible fix in the
> other. If you can reproduce this well, that would be very useful.

Which commit are you talking about? I can easily revert some/all of what you
want and do test runs.

> khugepaged using CPU also points to either the address space scanning, or
> compaction going wrong. Since 8b1645685ac it shouldn't hold mmap_sem during
> compaction, but that still leaves page faulters to possibly hold it.

So, do you mean I should try reverting 8b1645685ac?

> So yeah we would need the stacks of processes that do hog the CPU's, not those
> that sleep. As David suggested, a /proc/pid/stack could work. Also can you
> please provide /proc/zoneinfo ?

Again, as I mentioned, I don't have /proc/pid/stack for any "pid", is
this depending on some specific kerenl option?

/proc/zoneinfo I have and can send you the next time.

Thanks a lot and all the best

Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
------------------------------------------------------------------------
