Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762800Ab3ECJDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:03:05 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:43341 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab3ECJDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:03:03 -0400
X-AuditID: 9c930179-b7bb6ae000001131-2e-51837d3f6121
Date: Fri, 3 May 2013 18:02:52 +0900
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org,
        celinux-dev@lists.celinuxforum.org, Nicolas Pitre <nico@fluxnic.net>,
        David Sterba <dsterba@suse.cz>, Nitin Gupta <nitingupta910@gmail.com>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
Subject: Re: [PATCH v3 -next 3/5] arm: Add support for LZ4-compressed kernel
Message-ID: <20130503090252.GB3170@Corona>
References: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
 <1362484056-9778-4-git-send-email-kyungsik.lee@lge.com>
 <20130430135602.2aa0d3b4ec392bf83a9b64d0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430135602.2aa0d3b4ec392bf83a9b64d0@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 01:56:02PM -0700, Andrew Morton wrote:
> On Tue,  5 Mar 2013 20:47:34 +0900 Kyungsik Lee <kyungsik.lee@lge.com> wrote:
> 
> > This patch integrates the LZ4 decompression code to the arm pre-boot code.
> > And it depends on two patchs below
> > 
> > lib: Add support for LZ4-compressed kernel
> > decompressor: Add LZ4 decompressor module
> > 
> > ...
> >
> > - Apply CFLAGS, -Os to decompress.o to improve decompress
> >   performance during boot-up process
> >
> > ...
> >
> > --- a/arch/arm/boot/compressed/Makefile
> > +++ b/arch/arm/boot/compressed/Makefile
> > @@ -24,6 +24,9 @@ endif
> >  AFLAGS_head.o += -DTEXT_OFFSET=$(TEXT_OFFSET)
> >  HEAD	= head.o
> >  OBJS	+= misc.o decompress.o
> > +ifeq ($(CONFIG_KERNEL_LZ4),y)
> > +CFLAGS_decompress.o := -Os
> > +endif
> 
> Surprised.  You found that -Os produces faster code than -O2?  Details,
> please?
-Os is enforced here, based on the test result of decompression time
below, slightly faster than -O2.
But further tests with UA show that using -O2 will be the right choice
especially in the case of the unaligned access enabled.

Decompression Time(counts)
             UA
-Os  6717    3447
-O2  6720    2728

Note: ARM v7, Kernel 3.4
      counter freq. = 32768 HZ
      UA(Unaligned Access)
      gcc version 4.6.2 (Ubuntu/Linaro 4.6.2-14ubuntu2~ppa1)

Thanks,
Kyungsik
