Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3DWTz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 15:55:59 -0400
Received: from mout.gmx.net ([212.227.17.21]:57855 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554Ab3DWTz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 15:55:57 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX18Nchsum4ANguytkz4eOQrihd6+yLayq4WXt4XutE
	ohkWSRm3tfhddM
From: Marc Dietrich <marvin24@gmx.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 14/21] staging: nvec: allow modular build
Date: Tue, 23 Apr 2013 21:55:48 +0200
Message-ID: <1373204.GiWOFfjzyB@ax5200p>
User-Agent: KMail/4.8.5 (Linux/3.5.0-21-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <201304232141.04123.arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de> <4082180.JXNz6TsAKc@ax5200p> <201304232141.04123.arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013 21:41:03 Arnd Bergmann wrote:
> On Tuesday 23 April 2013, Marc Dietrich wrote:
> > On Tuesday 23 April 2013 18:30:46 Arnd Bergmann wrote:
> > > The serio code can be a loadable module, which in turn means that nvec
> > > also has to be a module, so mark it as "tristate" in Kconfig.
> > 
> > oh, I didn't saw this randconfig error posting. NVEC isn't prepared for
> > modularized builds yet (it's on the TODO list though). So better say
> > SERIO=y here. Looking a bit closer, there is other stuff which can also
> > be a module (GPIOLIB, I2C, ...) so these also need a =y.
> 
> What is the problem with building it as a module? It looks all fine in that
> regard.

It builds, but I haven't tried out it yet. At least the mfd children need to 
unregister the event notifier I guess. Anyway, I have no time to test this 
now, so I prefer to force =y for the dependencies for now.

> I also did not see any problems with the other symbols, but that may be
> because they get turned on as built-in even in allmodconfig. Marking it
> as tristate certainly avoids the problem altogether.
> 
> > Should a post a patch?
> 
> If you have follow-on patches, they need to go on top now, since Greg
> already took this patch.

arrr, I wonder why Greg thought that a 4 minute review time is enough :-(
I'll try to post a patch tomorrow then.

Marc

