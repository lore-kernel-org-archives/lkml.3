Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935056Ab3DOTtv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 15:49:51 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34183 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933716Ab3DOTtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 15:49:49 -0400
Date: Mon, 15 Apr 2013 12:49:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Dolkow, Snild" <Snild.Dolkow@sonymobile.com>
Cc: =?iso-8859-1?B?IkFuZGVy9iwgT3NrYXIi?= <Oskar.Andero@sonymobile.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>
Subject: Re: [PATCH] lowmemorykiller: prevent multiple instances of low
 memory killer
Message-ID: <20130415194947.GA26557@kroah.com>
References: <1366031009-21958-1-git-send-email-oskar.andero@sonymobile.com>
 <20130415131815.GG6638@mwanda>
 <D949F1A1ED65354FA281790D817657A4A4BF33CC83@seldmbx01.corpusers.net>
 <20130415141358.GO6692@mwanda>
 <20130415150356.GA22161@caracas.corpusers.net>
 <D949F1A1ED65354FA281790D817657A4A4BF33CC84@seldmbx01.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D949F1A1ED65354FA281790D817657A4A4BF33CC84@seldmbx01.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 08:28:07PM +0200, Dolkow, Snild wrote:
> >> > >From the comments in shrinker.h:
> >> > "It should return the number of objects which remain in the cache.
> >> > If it returns -1, it means it cannot do any scanning at this time
> >> > (eg. there is a risk of deadlock). The callback must not return -1
> >> > if nr_to_scan is zero."
> >>
> >
> >IMO one should use the errno.h values - e.g. EBUSY might be a good value
> >in this case. Does anyone know why the shrinker wants -1? Is there a
> >reason?
> 
> The positive numbers are used to return information on the remaining
> cache size (again, see the comment I pasted above). We could use
> -EBUSY, but we'd have to change vmscan.c, which checks specifically
> for -1. I can't see a technical reason why -EBUSY couldn't have been
> chosen instead, but there's also no real reason to change it now.

If it's not the correct thing to do, sure we can change it, just send a
patch.  It makes way more sense than some random -1 return value to me.

Care to send a series of patches fixing this up properly?

thanks,

greg k-h
