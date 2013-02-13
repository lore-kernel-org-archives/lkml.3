Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970Ab3BMTeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:34:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42546 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439Ab3BMTeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:34:17 -0500
Date: Wed, 13 Feb 2013 14:34:11 -0500
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
Message-ID: <20130213193411.GA15928@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20130212193901.GA18906@redhat.com>
 <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
 <20130213004059.GA14451@redhat.com>
 <alpine.LNX.2.00.1302121652240.1077@eggly.anvils>
 <20130213041629.GA28622@redhat.com>
 <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 09:37:27PM -0800, Hugh Dickins wrote:

 > I think for the moment I'm going to hope that under the surface our
 > problems are related, and when your bisection points a finger, look
 > around to see if it suggests anything for my case.  Lazy, but...

I have the worst luck with bisects.  Halfway through I started seeing
a *different* suspend failure, which led me down the wrong path
ultimately leading to 59a93c27c which was a red herring even though
it even talks about suspend (I had my hopes high when testing that one).

Started over, and ended up in a merge commit containing just a single
patch to slab (210ed9defff). Reverting that on top of 3.7-rc8 doesn't
fix the problem.  Backing up one level of bisect, the other alternative
path was 5b3900cd40, which also didn't help when reverting.

My test was a loop of 100 suspend/resume cycles before calling something
'good'. The 'bad' cases all failed within 10 cycles (usually 2-3).

	Dave

