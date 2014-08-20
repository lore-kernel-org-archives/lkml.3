Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaHTU0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:26:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59961 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaHTU0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:26:11 -0400
Date: Wed, 20 Aug 2014 22:26:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Valdis.Kletnieks@vt.edu
Cc: Nick Krause <xerofoiffy@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "open list:SPI SUBSYSTEM" <linux-spi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] spi: Remove unused definitions
Message-ID: <20140820202235.GA28350@xo-6d-61-c0.localdomain>
References: <1407347597-2168-1-git-send-email-xerofoiffy@gmail.com>
 <17153.1407349640@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17153.1407349640@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-08-06 14:27:20, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 06 Aug 2014 13:53:17 -0400, Nick Krause said:
> > Remove unused definition which cause the following warnings
> > 
> > drivers/spi/spi-omap-100k.c:73:0: warning: "WRITE" redefined [enabled by default]
> > include/linux/fs.h:193:0: note: this is the location of the previous definition
> > drivers/spi/spi-omap-100k.c:74:0: warning: "READ" redefined [enabled by default]
> > include/linux/fs.h:192:0: note: this is the location of the previous definition
> 
> > -#define WRITE 0
> > -#define READ  1
> 
> NAK.  Full stop.  These are potentially used in an inner macro someplace, and by
> removing these, the conflicting values from fs.h will be used instead.
> 
> #define READ                    0
> #define WRITE                   RW_MASK
> 
> So if there *is* a use in an inner macro, you just screwed the pooch
> and introduced a bug in this "clean up" - somebody will be expecting to see
> a 0 for a READ, and will receive a 1 instead.  This can't end well.

Actually.. having macros called READ and WRITE in fs.h is already something I'd say
can't end well. Can we rename those?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
