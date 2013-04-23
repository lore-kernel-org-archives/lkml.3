Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3DWUF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:05:59 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55924 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913Ab3DWUF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:05:57 -0400
Date: Tue, 23 Apr 2013 13:05:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marc Dietrich <marvin24@gmx.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/21] staging: nvec: allow modular build
Message-ID: <20130423200555.GA31383@kroah.com>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
 <4082180.JXNz6TsAKc@ax5200p>
 <201304232141.04123.arnd@arndb.de>
 <1373204.GiWOFfjzyB@ax5200p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373204.GiWOFfjzyB@ax5200p>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 09:55:48PM +0200, Marc Dietrich wrote:
> On Tuesday 23 April 2013 21:41:03 Arnd Bergmann wrote:
> > On Tuesday 23 April 2013, Marc Dietrich wrote:
> > > On Tuesday 23 April 2013 18:30:46 Arnd Bergmann wrote:
> > > > The serio code can be a loadable module, which in turn means that nvec
> > > > also has to be a module, so mark it as "tristate" in Kconfig.
> > > 
> > > oh, I didn't saw this randconfig error posting. NVEC isn't prepared for
> > > modularized builds yet (it's on the TODO list though). So better say
> > > SERIO=y here. Looking a bit closer, there is other stuff which can also
> > > be a module (GPIOLIB, I2C, ...) so these also need a =y.
> > 
> > What is the problem with building it as a module? It looks all fine in that
> > regard.
> 
> It builds, but I haven't tried out it yet. At least the mfd children need to 
> unregister the event notifier I guess. Anyway, I have no time to test this 
> now, so I prefer to force =y for the dependencies for now.
> 
> > I also did not see any problems with the other symbols, but that may be
> > because they get turned on as built-in even in allmodconfig. Marking it
> > as tristate certainly avoids the problem altogether.
> > 
> > > Should a post a patch?
> > 
> > If you have follow-on patches, they need to go on top now, since Greg
> > already took this patch.
> 
> arrr, I wonder why Greg thought that a 4 minute review time is enough :-(

It was longer than 4 minutes...

I trust Arnd, and it's only a staging driver, what's the worse thing
that could happen to it?  :)

> I'll try to post a patch tomorrow then.

That would be great.

thanks,

greg k-h
