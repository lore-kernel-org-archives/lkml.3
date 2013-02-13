Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab3BMCRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 21:17:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195Ab3BMCRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 21:17:36 -0500
Date: Tue, 12 Feb 2013 21:17:29 -0500
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
Message-ID: <20130213021729.GA22860@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20130212193901.GA18906@redhat.com>
 <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 04:26:22PM -0800, Hugh Dickins wrote:
 
 > Me too on T420s, except that is blessed with a blinking CapsLk.
 > 
 > It's so erratic (though I think I see more failures than you do: I'd say
 > a quick resume never fails, but an overnight resume fails half the time):
 > I'm afraid I didn't have the patience to embark on pm_trace at all.
 > 
 > I did try to bisect it during the -rc5 week.  I'm not sure, but I have
 > no record of seeing it on -rc1 or -rc2, but definitely saw it on -rc3.
 > So I tried bisecting between -rc2 and -rc3, persisting for a day if it
 > looked good; but the bisection didn't seem to be converging anywhere
 > likely when -rc6 came out, and I switched to see if -rc6 solved it.
 > 
 > I had no problem with -rc6; but with -rc7 it happens more than ever.
 > Though still not on "quick" resumes, the kind you want to do when
 > bisecting.
 > 
 > Sharing these anecdotes in case they match or diverge from your
 > experience and others, and might help towards finding the cause.
 > Not-to-be-trusted bisection log appended: of course the bads are
 > reliable, but perhaps none of the goods.

Yeah, my first bisection results look totally different.
I can do 100 suspend/resumes fine on 3.6.0, but it fails after just 2-3
on 3.7.0, so it looks like the bug I'm chasing happened before whatever
is affecting you.  (Or maybe you just didn't get 'lucky' when testing rc1,
and it wasn't good after all).

Now that I have what appears to be a 'good' candidate, hopefully
a bisection can quickly get to the bottom of this.

	Dave

