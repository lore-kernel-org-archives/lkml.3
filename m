Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab3EVWJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:09:36 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:44317 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757306Ab3EVWJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:09:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkIOAPxAnVF5LBBG/2dsb2JhbABagwgwglK5fYUkBAGBBhd0giMBAQU6HDMIAxgJJQ8FJQMhARIah3INuxsWjWqBJINUA5c3kUGDISo
Date: Thu, 23 May 2013 08:09:33 +1000
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130522220933.GV24543@dastard>
References: <20130522000803.GA19891@redhat.com>
 <20130522001603.GZ29466@dastard>
 <20130522025605.GA29767@redhat.com>
 <20130522040318.GG29466@dastard>
 <20130522041521.GA1837@redhat.com>
 <20130522051243.GH29466@dastard>
 <20130522052938.GA2573@redhat.com>
 <20130522055147.GI29466@dastard>
 <20130522142252.GB1407@redhat.com>
 <20130522161946.GA25906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130522161946.GA25906@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 12:19:46PM -0400, Dave Jones wrote:
> On Wed, May 22, 2013 at 10:22:52AM -0400, Dave Jones wrote:
>  > On Wed, May 22, 2013 at 03:51:47PM +1000, Dave Chinner wrote:
>  > 
>  >  > > Tomorrow I'll also try running some older kernels with the same
>  >  > > options to see if it's something new, or an older bug. This is a
>  >  > > new machine, so it may be something that's been around for a
>  >  > > while, and for whatever reason, my other machines don't hit
>  >  > > this.
>  >  > 
>  >  > Another thing that just occurred to me - what compiler are you
>  >  > using?  We had a report last week on #xfs that xfsdump was failing
>  >  > with bad checksums because of link time optimisation (LTO) in
>  >  > gcc-4.8.0. When they turned that off, everything worked fine. So if
>  >  > you are using 4.8.0, perhaps trying a different compiler might be a
>  >  > good idea, too.
>  > 
>  > Yeah, this is 4.8.0. This box is running F19-beta. 
>  > I managed to shoehorn the gcc-4.7 from f18 on there though.
>  > Bug reproduced instantly, so I think we can rule out compiler.
>  > 
>  > I ran 3.9 with the same debug options. Seems stable.
>  > I'll do a bisect.
> 
> good news.  It wasn't until I started bisecting I realised I was still
> carrying this patch from you to fix slab corruption I was seeing.
> 
> It seems to be the culprit (or is masking another problem -- I had to apply
> it at each step of the bisect to get past the slab corruption bug).

That doesn't make a whole lot of sense to me. The fix in the xfsdev
tree is a little different:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs.git;a=commitdiff;h=52c24ad39ff02d7bd73c92eb0c926fb44984a41d

but I can't set how this makes any difference to the problem at all.
See my previous post about the fact that 0xa068 is actually a valid
mask and should not be tripping the assert....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
