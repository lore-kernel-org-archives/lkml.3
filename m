Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab3HENtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:49:11 -0400
Received: from bar.sig21.net ([80.81.252.164]:45834 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab3HENtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:49:09 -0400
X-Greylist: delayed 1506 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2013 09:49:09 EDT
Date: Mon, 5 Aug 2013 15:48:58 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: i915 INFO: trying to register non-static key.
Message-ID: <20130805134858.GA6705@sig21.net>
References: <20130731162252.GC4724@pd.tnic>
 <CAKMK7uFNpvSHxMXu6uzHbTwv4W=k_QZ2-g9X4hAK6wwniisrvQ@mail.gmail.com>
 <20130805092612.GA23560@pd.tnic>
 <20130805132353.GA4678@sig21.net>
 <20130805132728.GC31845@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805132728.GC31845@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 03:27:29PM +0200, Borislav Petkov wrote:
> On Mon, Aug 05, 2013 at 03:23:53PM +0200, Johannes Stezenbach wrote:
> > wrt to $Subject, I get this with 3.10.5:
> > 
> > [    4.342638] i915 0000:00:02.0: setting latency timer to 64
> > [    4.409045] INFO: trying to register non-static key.
> > [    4.409164] the code is fine but needs lockdep annotation.
> > [    4.409278] turning off the locking correctness validator.
> > [    4.409396] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.10.5 #1
> > [    4.409514] Hardware name: LENOVO 2320CTO/2320CTO, BIOS G2ET82WW (2.02 ) 09/11/2012
> > [    4.409690]  0000000000000001 ffff8802121559e0 ffffffff816b265c ffff880212155a50
> > [    4.410050]  ffffffff8109ba03 ffffffff822cd1c0 0000000000000000 0000000100000006
> > [    4.410408]  0000000000000000 0000000000000000 0000000000000000 ffff8802121587a8
> 
> Looks similar to what I'm seeing. Can you cherry-pick
> 
> commit e1b4d3036c07ff137955fb1c0197ab62534f46ec
> Author: Ben Widawsky <ben@bwidawsk.net>
> Date:   Tue Jul 30 16:27:57 2013 -0700
> 
>     drm/i915: fix missed hunk after GT access breakage
> 
> ontop of 3.10-stable?

This is already in 3.10.5 as commit c9af307d38974264922d35c77bb71087d171f8f8.

Thanks,
Johannes
