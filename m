Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab3EUJMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:12:45 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:64546 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3EUJMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:12:43 -0400
Date: Tue, 21 May 2013 11:12:30 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, arnd@arndb.de,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [GIT PULL v2] MFD: Fixes due for the v3.10 -rc:s
Message-ID: <20130521091230.GA28756@balto.lan>
References: <20130514091956.GG3297@gmail.com>
 <20130515090449.GA3494@gmail.com>
 <20130516224337.GZ22822@zurbaran>
 <20130517075140.GA25077@balto.lan>
 <20130521085650.GB4589@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521085650.GB4589@zurbaran>
X-Operating-System: Linux balto 3.9.0-10518-gd7ab730 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Tue, May 21, 2013 at 10:56:50AM +0200, Samuel Ortiz wrote:
> Hi Fabio,
> 
> On Fri, May 17, 2013 at 09:51:40AM +0200, Fabio Baltieri wrote:
> > Hello Samuel,
> > 
> > On Fri, May 17, 2013 at 12:43:37AM +0200, Samuel Ortiz wrote:
> > > > Fabio Baltieri (5):
> > > >       mfd: abx500-core: Fix sparse warning
> > > >       mfd: ab8500-sysctrl: Fix sparse warning
> > > >       mfd: ab8500-sysctrl: Set sysctrl_dev during probe
> > > >       mfd: ab8500-sysctrl: Let sysctrl driver work without pdata
> > > Unless I'm missing something here, this one is not really rcN material, so
> > > I'd appreciate if you could queue it to your for-mfd branch instead.
> > 
> > The last two:
> > 
> >   mfd: ab8500-sysctrl: Set sysctrl_dev during probe
> This one is already in mfd-fixes, the commit log was clear enough.

Great!

> >   mfd: ab8500-sysctrl: Let sysctrl driver work without pdata
> This one is not, as the commit log is not showing it actually fixes something
> but only makes the code cleaner. If it really fixes something, could you
> please provide me with a commit log that describes what exactly it fixes ?

Ok, the fix here is that right now that driver is initialized without a
specific pdata (that is plat->sysctrl), so enforcing it breaks existing
platforms for no reason.  To make the commit more clear I would just
point that out as in (just last two sentences):

--- >8 ---
mfd: ab8500-sysctrl: Let sysctrl driver work without pdata

A check for a valid plat->sysctrl was introduced in:

2377e52 mfd: ab8500-sysctrl: Error check clean up

but the driver works just fine even without that initialization data,
and enforcing it breaks existing platforms for no reason.

This patch removes the check and let the driver go ahead with probe.
--- >8 ---

Is it better?

Thanks,
Fabio

-- 
Fabio Baltieri
