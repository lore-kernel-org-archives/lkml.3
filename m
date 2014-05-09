Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbaEIRF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 13:05:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:7241 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757128AbaEIRF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 13:05:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1019,1389772800"; 
   d="scan'208";a="430048917"
Date: Fri, 9 May 2014 20:03:35 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Damien Lespiau <damien.lespiau@intel.com>
Cc: =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] [3.14.0-rc4] regression: drm FIFO underruns
Message-ID: <20140509170335.GZ18465@intel.com>
References: <CADDKRnCwxmJ8RonvZaizTT9R1jPU++tPPSQAH5OKD5=h9bQhMA@mail.gmail.com>
 <CAKMK7uG20sF403PJcmWTD=kPF9seV4sXZpp9_hEq3LvV3kK5Hg@mail.gmail.com>
 <CADDKRnB1DCzgjX-q-cgFFW48uT5r5MUcuc5D6chekEET5dFxxA@mail.gmail.com>
 <20140509161438.GH31479@strange.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140509161438.GH31479@strange.amr.corp.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 05:14:38PM +0100, Damien Lespiau wrote:
> On Fri, May 09, 2014 at 06:11:37PM +0200, Jörg Otte wrote:
> > > Jörg, can you please boot with drm.debug=0xe, reproduce the issue and
> > > then attach the complete dmesg? Please make sure that the dmesg
> > > contains the boot-up stuff too.
> > >
> > > Thanks, Daniel
> > Here it is. I should mention it only happens at boot-up.
> 
> [    0.374095] [drm] Wrong MCH_SSKPD value: 0x20100406
> [    0.374096] [drm] This can cause pipe underruns and display issues.
> [    0.374097] [drm] Please upgrade your BIOS to fix this.

That can be a factor, but I think we may have some more general issue
in the modeset sequence which causes these to get reported. I'm getting
some on my machine as well where SSKPD looks more sane. Maybe we turn on
the error reporting too early or something.

But I'm not going to spend time worrying about these before my previous
watermark stuff gets merged. Also the underrun reporting code itself
would need some kind of rewrite to be really useful.

If the display doesn't blank out during use everything is more or less
fine and you can ignore these errors. It's quite likely that the
errors were always present and you didn't know it. We just made them
more prominent recently.

-- 
Ville Syrjälä
Intel OTC
