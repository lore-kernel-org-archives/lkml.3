Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759216Ab3KMMa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 07:30:29 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34668 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566Ab3KMMa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 07:30:26 -0500
Date: Wed, 13 Nov 2013 07:30:10 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Joe Perches <joe@perches.com>, netdev <netdev@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        sebastien.dugue@bull.net, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [Fwd: Re: [PATCH v2 2/2] x86: add prefetching to do_csum]
Message-ID: <20131113123010.GB2993@hmsreliant.think-freely.org>
References: <1384220542.4771.23.camel@joe-AO722>
 <20131112171239.GC19780@hmsreliant.think-freely.org>
 <1384277615.3665.10.camel@joe-AO722>
 <20131112195005.GD19780@hmsreliant.think-freely.org>
 <AE90C24D6B3A694183C094C60CF0A2F6026B740E@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B740E@saturn3.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 10:09:51AM -0000, David Laight wrote:
> > Sure, I modified the code so that we only prefetched 2 cache lines ahead, but
> > only if the overall length of the input buffer is more than 2 cache lines.
> > Below are the results (all counts are the average of 1000000 iterations of the
> > csum operation, as previous tests were, I just omitted that column).
> 
> Hmmm.... averaging over 100000 iterations means that all the code
> is in the i-cache and the branch predictor will be correctly primed.
> 
> For short checksum requests I'd guess that the relevant data
> has just been written and is already in the cpu cache (unless
> there has been a process and cpu switch).
> So prefetch is likely to be unnecessary.
> 
> If you assume that the checksum code isn't in the i-cache then
> small requests are likely to be dominated by the code size.
> 
I'm not sure, whats the typical capacity for the branch predictors ability to
remember code paths?  I ask because the most likely use of do_csum will be in
the receive path of the networking stack (specifically in the softirq handler).
So if we run do_csum once, we're likely to run it many more times, as we clean
out an adapters receive queue.

Neil

> 	David
> 
> 
> 
> 
