Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967251Ab3E2Xsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 19:48:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60510 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967182Ab3E2Xs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 19:48:27 -0400
Message-ID: <1369871306.22004.126.camel@joe-AO722>
Subject: Re: [PATCH] timer: Fix jiffies wrap behavior of round_jiffies*()
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 29 May 2013 16:48:26 -0700
In-Reply-To: <20130529163813.5f637f04.akpm@linux-foundation.org>
References: <519BC066.5080600@acm.org>
	 <20130529160150.f0a498d188dc790d018200e9@linux-foundation.org>
	 <1369869467.22004.122.camel@joe-AO722>
	 <20130529163813.5f637f04.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 16:38 -0700, Andrew Morton wrote:
> On Wed, 29 May 2013 16:17:47 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > >   We could perhaps have a checkpatch rule
> > > which looks for comparisons against jiffes (and any other
> > > time-measuring variables we can detect)
> > 
> > other variables like?
> 
> Grepping for time_after finds a bunch.  There's no real pattern to it though.

Yup, that's the problem.
Thought I'd ask what I was missing though.

No variable really stands out as testable other
than jiffies.

I added this to my local queue and I'll send it later.

# check for comparisons of jiffies
		if ($line =~ /\bif\s*\((\s*jiffies\s*[\<\>]|.*[\<\>]=?\s*jiffies\b)/) {
			WARN("JIFFIES_COMPARISON",
			     "Comparing jiffies is almost always wrong; prefer time_after, time_before and friends\n" . $herecurr);
		}


