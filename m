Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3FRMxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:53:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41265 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab3FRMxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:53:09 -0400
Date: Tue, 18 Jun 2013 14:53:04 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: dzu@denx.de, hjk@hansjkoch.de, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] fix UIO with device tree but no assigned interrupt
Message-ID: <20130618125304.GA15179@amd.pavel.ucw.cz>
References: <20130617134957.GA15602@amd.pavel.ucw.cz>
 <20130617234635.GA4521@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130617234635.GA4521@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-06-17 16:46:36, Greg KH wrote:
> On Mon, Jun 17, 2013 at 03:49:57PM +0200, Pavel Machek wrote:
> > If device is initialized from device tree, but has no interrupt assigned,
> > uio will still try to request and interrupt old way, fails, and fails registration.
> >    
> > This is wrong; don't try initializing irq using platform data if device tree is
> > available.
> 
> Doesn't apply cleanly to my tree, can you redo it against the
> char-misc-next branch of my git tree?

Done. I also notice problems with leaking memory, fixed those, too.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
