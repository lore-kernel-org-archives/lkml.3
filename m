Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab3J2U6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:58:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab3J2U57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:57:59 -0400
Date: Tue, 29 Oct 2013 21:57:56 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mgorman@suse.de
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131029205756.GH9568@quack.suse.cz>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <20131025091842.GA28681@thunk.org>
 <20131025022937.12623dcd.akpm@linux-foundation.org>
 <CA+55aFzq4-wsErRO56gW6gj3Q91QtvvaGQPdUV2JkSs-B1PCAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzq4-wsErRO56gW6gj3Q91QtvvaGQPdUV2JkSs-B1PCAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 25-10-13 10:32:16, Linus Torvalds wrote:
> On Fri, Oct 25, 2013 at 10:29 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > Apparently all this stuff isn't working as desired (and perhaps as designed)
> > in this case.  Will take a look after a return to normalcy ;)
> 
> It definitely doesn't work. I can trivially reproduce problems by just
> having a cheap (==slow) USB key with an ext3 filesystem, and going a
> git clone to it. The end result is not pretty, and that's actually not
> even a huge amount of data.
  I'll try to reproduce this tomorrow so that I can have a look where
exactly are we stuck. But in last few releases problems like this were
caused by problems in reclaim which got fed up by seeing lots of dirty
/ under writeback pages and ended up stuck waiting for IO to finish. Mel
has been tweaking the logic here and there but maybe it haven't got fixed
completely. Mel, do you know about any outstanding issues?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
