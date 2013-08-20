Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab3HTTZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:25:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab3HTTZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:25:13 -0400
Date: Tue, 20 Aug 2013 15:25:08 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH 1/2] Revert "Revert "math64: New div64_u64_rem helper""
Message-ID: <20130820192508.GA4799@redhat.com>
References: <1376078164-23147-1-git-send-email-snitzer@redhat.com>
 <20130820070045.GA1665@redhat.com>
 <20130820080910.GA11072@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820080910.GA11072@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20 2013 at  4:09am -0400,
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 
> > On Fri, Aug 09, 2013 at 03:56:03PM -0400, Mike Snitzer wrote:
> > > This reverts commit f3002134158092178be81339ec5a22ff80e6c308.
> > > 
> > > div64_u64_rem was removed because there were no other users.
> > > 
> > > But Device Mapper's I/O statistics support has a need for
> > > div64_u64_rem; reintroduce this helper.
> > 
> > This slows down div64_u64 operation, especially on 32-bit 
> > systems.
> > 
> > Since dm statistic code is possibly not performance 
> > critical perhaps you could use something like below 
> > instead to calculate remainder:
> > 
> > res = div64_u64(a, b);
> > rem = a - b*res;
> 
> Or introduce a separately named helper without touching the 
> existing methods.

Thanks for the feedback.

I've pushed "math64: New separate div64_u64_rem helper" to the DM tree's
'for-next' branch:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=20e8125736d0e96b64c9b6127241d2a13529180a

Are you OK with me carrying this patch in the DM tree for 3.12
inclusion?

Mike
