Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab3BMAlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:41:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab3BMAlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:41:06 -0500
Date: Tue, 12 Feb 2013 19:40:59 -0500
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
Message-ID: <20130213004059.GA14451@redhat.com>
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
 > On Tue, 12 Feb 2013, Dave Jones wrote:
 > 
 > > My Thinkpad T430s suspend/resumes fine most of the time. But every so often
 > > (like one in ten times or so), as soon as I suspend, I get a black screen,
 > > and a blinking power button.
 > > 
 > > (Note: Not the capslock lights like when we panic, this laptop 'conveniently
 > >  doesn't have those. This is the light surrounding the power button, which afaik
 > >  isn't even OS controlled, so maybe we're dying somewhere in SMI/BIOS land?)
 > 
 > Me too on T420s, except that is blessed with a blinking CapsLk.
 > 
 > It's so erratic (though I think I see more failures than you do: I'd say
 > a quick resume never fails, but an overnight resume fails half the time):
 > I'm afraid I didn't have the patience to embark on pm_trace at all.

Sounds like yours successfully suspends all the time though ?
For me, as soon as I shut the lid, the moon light starts flashing indicating failure.

That said, we saw that I was failing on the resume path after a failed suspend,
so it could still be the same problem.

 > I did try to bisect it during the -rc5 week.  I'm not sure, but I have
 > no record of seeing it on -rc1 or -rc2, but definitely saw it on -rc3.
 > So I tried bisecting between -rc2 and -rc3, persisting for a day if it
 > looked good; but the bisection didn't seem to be converging anywhere
 > likely when -rc6 came out, and I switched to see if -rc6 solved it.
 > 
 > I had no problem with -rc6; but with -rc7 it happens more than ever.
 > Though still not on "quick" resumes, the kind you want to do when
 > bisecting.

so I can hit this pretty quickly with this..

while [ 1 ];
do
 rtcwake -s 5 -m no ; pm-suspend
done

Which should make it bisectable at least..

 > Sharing these anecdotes in case they match or diverge from your
 > experience and others, and might help towards finding the cause.
 > Not-to-be-trusted bisection log appended: of course the bads are
 > reliable, but perhaps none of the goods.

I didn't have this laptop pre 3.8rc, so I've not had a 'good' reference,
pretty sure I saw it during rc1 though, so I might have to go back further
a version or two.

	Dave

