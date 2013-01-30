Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3A3LJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 06:09:15 -0500
Received: from bar.sig21.net ([80.81.252.164]:53328 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449Ab3A3LJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 06:09:10 -0500
X-Greylist: delayed 2603 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2013 06:09:10 EST
Date: Wed, 30 Jan 2013 11:23:53 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kyungsik Lee <kyungsik.lee@lge.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>, hyojun.im@lge.com,
        chan.jeong@lge.com, gunho.lee@lge.com, minchan.kim@lge.com,
        namhyung.kim@lge.com, raphael.andy.lee@gmail.com,
        CE Linux Developers List <celinux-dev@lists.celinuxforum.org>,
        "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Subject: Re: [RFC PATCH 0/4] Add support for LZ4-compressed kernels
Message-ID: <20130130102353.GA8925@sig21.net>
References: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com>
 <20130128142510.68092e10.akpm@linux-foundation.org>
 <alpine.LFD.2.02.1301282320430.6300@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1301282320430.6300@xanadu.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 11:29:14PM -0500, Nicolas Pitre wrote:
> On Mon, 28 Jan 2013, Andrew Morton wrote:
> 
> > On Sat, 26 Jan 2013 14:50:43 +0900
> > Kyungsik Lee <kyungsik.lee@lge.com> wrote:
> > 
> > > This patchset is for supporting LZ4 compressed kernel and initial ramdisk on
> > > the x86 and ARM architectures.
> > > 
> > > According to http://code.google.com/p/lz4/, LZ4 is a very fast lossless
> > > compression algorithm and also features an extremely fast decoder.
> > > 
> > > Kernel Decompression APIs are based on implementation by Yann Collet
> > > (http://code.google.com/p/lz4/source/checkout).
> > > De/compression Tools are also provided from the site above.
> > > 
> > > The initial test result on ARM(v7) based board shows that the size of kernel
> > > with LZ4 compressed is 8% bigger than LZO compressed  but the decompressing
> > > speed is faster(especially under the enabled unaligned memory access).
> > > 
> > > Test: 3.4 based kernel built with many modules
> > > Uncompressed kernel size: 13MB
> > > lzo: 6.3MB, 301ms
> > > lz4: 6.8MB, 251ms(167ms, with enabled unaligned memory access)
> > 
> > What's this "with enabled unaligned memory access" thing?  You mean "if
> > the arch supports CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS"?  If so,
> > that's only x86, which isn't really in the target market for this
> > patch, yes?
> 
> I'm guessing this is referring to commit 5010192d5a.
> 
> > It's a lot of code for a 50ms boot-time improvement.  Does anyone have
> > any opinions on whether or not the benefits are worth the cost?
> 
> Well, we used to have only one compressed format.  Now we have nearly 
> half a dozen, with the same worthiness issue between themselves.  
> Either we keep it very simple, or we make it very flexible.  The former 
> would argue in favor of removing some of the existing formats, the later 
> would let this new format in.

This reminded me to check the status of the lzo update and it
seems it got lost?
http://lkml.org/lkml/2012/10/3/144

(Cc: added, I hope Markus still cares and someone could
eventually take his patch once he resends it.)

Johannes
