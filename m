Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab3HTIJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 04:09:44 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:35727 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab3HTIJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 04:09:15 -0400
Date: Tue, 20 Aug 2013 10:09:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] Revert "Revert "math64: New div64_u64_rem helper""
Message-ID: <20130820080910.GA11072@gmail.com>
References: <1376078164-23147-1-git-send-email-snitzer@redhat.com>
 <20130820070045.GA1665@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820070045.GA1665@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> On Fri, Aug 09, 2013 at 03:56:03PM -0400, Mike Snitzer wrote:
> > This reverts commit f3002134158092178be81339ec5a22ff80e6c308.
> > 
> > div64_u64_rem was removed because there were no other users.
> > 
> > But Device Mapper's I/O statistics support has a need for
> > div64_u64_rem; reintroduce this helper.
> 
> This slows down div64_u64 operation, especially on 32-bit 
> systems.
> 
> Since dm statistic code is possibly not performance 
> critical perhaps you could use something like below 
> instead to calculate remainder:
> 
> res = div64_u64(a, b);
> rem = a - b*res;

Or introduce a separately named helper without touching the 
existing methods.

Thanks,

	Ingo
