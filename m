Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbaCRSjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:39:06 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:37267 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673AbaCRSjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:39:03 -0400
Date: Tue, 18 Mar 2014 21:35:10 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] zram: include linux/err.h
Message-ID: <20140318183510.GA430@swordfish>
References: <201403151040.09139.arnd@arndb.de>
 <20140315141839.GA361@swordfish>
 <201403152126.02967.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201403152126.02967.arnd@arndb.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd,

On (03/15/14 21:26), Arnd Bergmann wrote:
> On Saturday 15 March 2014, Sergey Senozhatsky wrote:
> > On (03/15/14 10:40), Arnd Bergmann wrote:
> > > The zram driver uses the ERR_PTR macro defined in <linux/err.h>
> > > and relies on this header to be included implicitly through
> > > other headers, which is not (always) the case on the ARM architecture.
> > > 
> > 
> > returned from zcomp ERR_PTR is checked and used in zram_drv.c, should
> > in this case there also be inclusion of err.h in zram_drv.h? if so, it
> > probably makes sense to move inclusion of err.h to zcomp.h, which is
> > included both in zcomp.c and zram_drv.c
> > 
> 
> The normal convention is to only include headers from other headers if
> that is required by the contents of the header itself.
> 
> Following the common conventions, it's better to include linux/err.h
> in both zram_drv.c and zcomp.c, but not in zram_drv.h.

thanks.

may I ask you to resend the patch with linux/err.h included
in both zram_drv.c and zcomp.c?

	-ss

> I didn't do that in my patch, because I only got a build error in
> one of the two files.
> 
> 	Arnd
> 
