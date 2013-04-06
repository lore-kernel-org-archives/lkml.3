Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423217Ab3DFPsA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 11:48:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:39569 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423200Ab3DFPr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 11:47:59 -0400
Date: Sat, 6 Apr 2013 17:47:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Stefan Bader <stefan.bader@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Andy Whitcroft <apw@canonical.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: x86/mm/pageattr: Code without effect?
Message-ID: <20130406154751.GB3612@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Stefan Bader <stefan.bader@canonical.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>, Andy Whitcroft <apw@canonical.com>,
	Mel Gorman <mgorman@suse.de>
References: <515E92CE.2000509@canonical.com>
 <20130405142104.GB29290@pd.tnic>
 <20130406145804.GJ3423@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130406145804.GJ3423@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 06, 2013 at 04:58:04PM +0200, Andrea Arcangeli wrote:
> You're right, so this location clearly didn't trigger the problem so I
> didn't notice the noop here. I only exercised the fix in the other
> locations of the file that had the same problem.
> 
> It was a noop, so it really couldn't hurt but the below change should
> activate the fix there too. On the same lines, there was a superfluous
> initialization of new_prot too which I cleaned up.
> 
> ==
> From 75598be1156ced0c210271e8958a5c5714a2626a Mon Sep 17 00:00:00 2001
> From: Andrea Arcangeli <aarcange@redhat.com>
> Date: Fri, 5 Apr 2013 19:43:20 +0200
> Subject: [PATCH] mm: pageattr: convert noop to functional fix
> 
> commit a8aed3e0752b4beb2e37cbed6df69faae88268da introduced some valid
> fix but one location that didn't trigger the bug that lead to finding
> those (small) problems, wasn't updated using the right variable.
> 
> The wrong variable was also initialized for no good reason, that may
> have been the source of the confusion. Remove the noop initialization
> accordingly.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

Yeah, looks good to me. I've folded it into my pile of changes touching
this and there are no visible issues. I mean, if there were, we
should've noticed it exploding elsewhere by now. Also, you might want to
credit Stefan in the commit message for spotting this.

Acked-by: Borislav Petkov <bp@suse.de>

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
