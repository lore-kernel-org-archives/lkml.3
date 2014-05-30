Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbaE3TwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 15:52:12 -0400
Received: from mailrelay.anl.gov ([130.202.101.22]:57168 "EHLO
	mailrelay.anl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbaE3TwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 15:52:10 -0400
X-IronPort-AV: E=Sophos;i="4.98,943,1392184800"; 
   d="scan'208";a="45589633"
Date: Fri, 30 May 2014 14:52:08 -0500
From: Kamil Iskra <iskra@mcs.anl.gov>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: <tony.luck@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@suse.de>, <gong.chen@linux.jf.intel.com>
Subject: Re: [PATCH] mm/memory-failure.c: support dedicated thread to handle
 SIGBUS(BUS_MCEERR_AO) thread
Message-ID: <20140530195208.GB4067@mcs.anl.gov>
References: <20140523033438.GC16945@gchen.bj.intel.com>
 <CA+8MBb+Una+Z5Q-Pn0OoMYaaSx9sPJ3fdriMRMgN=CE1Jdp7Cg@mail.gmail.com>
 <20140527161613.GC4108@mcs.anl.gov>
 <5384d07e.4504e00a.2680.ffff8c31SMTPIN_ADDED_BROKEN@mx.google.com>
 <CA+8MBbKuBo4c2v-Y0TOk-LUJuyJsGG=twqQyAPG5WOa8Aj4GyA@mail.gmail.com>
 <53852abb.867ce00a.3cef.3c7eSMTPIN_ADDED_BROKEN@mx.google.com>
 <FDBACF11-D9F6-4DE5-A0D4-800903A243B7@gmail.com>
 <53862f6c.91148c0a.5fb0.2d0cSMTPIN_ADDED_BROKEN@mx.google.com>
 <CA+8MBbKdKy+sbov-f+1xNnj=syEM5FWR1BV85AgRJ9S+qPbWEg@mail.gmail.com>
 <1401327939-cvm7qh0m@n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1401327939-cvm7qh0m@n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 21:45:41 -0400, Naoya Horiguchi wrote:

> >  The user could also mark more than
> > one thread in this way - in which case the kernel will pick
> > the first one it sees (is that oldest, or newest?) that is marked.
> > Not sure if this would ever be useful unless you want to pass
> > responsibility around in an application that is dynamically
> > creating and removing threads.
> 
> I'm not sure which is better to send signal to first-found marked thread
> or to all marked threads. If we have a good reason to do the latter,
> I'm ok about it. Any idea?

Well, it would be more flexible if the signal were sent to all marked
threads, but I don't know if that constitutes a good enough reason to add
the extra complexity involved.  Sometimes better is the enemy of good, and
in this case the patch you proposed should be good enough for any practical
case I can think of.

Naoya, Tony, thank you for taking the leadership on this issue and seeing
it through, and for the courtesy of keeping me in the loop!

Kamil

-- 
Kamil Iskra, PhD
Argonne National Laboratory, Mathematics and Computer Science Division
9700 South Cass Avenue, Building 240, Argonne, IL 60439, USA
phone: +1-630-252-7197  fax: +1-630-252-5986
