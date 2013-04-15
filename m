Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3DOPEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:04:01 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:10650 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839Ab3DOPEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:04:00 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
Date: Mon, 15 Apr 2013 17:03:56 +0200
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "Dolkow, Snild" <Snild.Dolkow@sonymobile.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>
Subject: Re: [PATCH] lowmemorykiller: prevent multiple instances of low
 memory killer
Message-ID: <20130415150356.GA22161@caracas.corpusers.net>
References: <1366031009-21958-1-git-send-email-oskar.andero@sonymobile.com>
 <20130415131815.GG6638@mwanda>
 <D949F1A1ED65354FA281790D817657A4A4BF33CC83@seldmbx01.corpusers.net>
 <20130415141358.GO6692@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130415141358.GO6692@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:13 Mon 15 Apr     , Dan Carpenter wrote:
> On Mon, Apr 15, 2013 at 03:38:08PM +0200, Dolkow, Snild wrote:
> > >Where is lowmem_shrink called from?  I only see shrink called from the
> > >bcache sysfs handler __bch_cache_set().  The return value isn't checked
> > >there.
> > >
> > >Up to now this function has only returns positive numbers.
> > >
> > >There isn't a place which check LMK_BUSY so maybe it's best to just
> > >return zero?
> > 
> > Hey Dan,
> > 
> > lowmem_shrink is assigned to a shrinker struct
> > (include/linux/shrinker.h) and called in do_shrinker_shrink() in
> > mm/vmscan.c. That, in turn, is called and checked in a few places
> > in vmscan.c.
> >
> > >From the comments in shrinker.h: 
> > "It should return the number of objects which remain in the
> > cache. If it returns -1, it means it cannot do any scanning at
> > this time (eg. there is a risk of deadlock). The callback must not
> > return -1 if nr_to_scan is zero."
> 
> Ah.  Good.  -1 is the right return.
> 
> But really should be a #define in shrinker.h instead of in
> drivers/staging/android/.

IMO one should use the errno.h values - e.g. EBUSY might be a good
value in this case. Does anyone know why the shrinker wants -1? Is there
a reason?

-Oskar
