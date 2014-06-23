Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbaFWOnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:43:45 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:51808 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbaFWOnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:43:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, wim@iguana.be,
        dbaryshkov@gmail.com, dwmw2@infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 1/6] wdt: sunxi: Move restart code to the watchdog driver
Date: Mon, 23 Jun 2014 16:42:47 +0200
Message-ID: <19870078.UBj78UMBrO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53A83A20.6090800@roeck-us.net>
References: <1399430664-29091-1-git-send-email-maxime.ripard@free-electrons.com> <20140623103142.GB19730@lukather> <53A83A20.6090800@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:g8guva0zoRZAne9HnVjW/bTlSknivA2yC4FDNaN2JHi
 yqQixskCtTd3HJmqL7IVLTEmgrXZwmA+OobWOA4nipO3CMrokk
 PSihLIe8gQ8lQAxU22D9Gpzk8/WwI+/LVLSczON60lTb5neIYG
 mpo4LdXu2KXpOjxo4jMkIGe7gbyDT9FHYtsj28WBZf65mqGWU4
 jAM5aEwm0rCjke8sU1wCRdqLtUYEQA149KuRsYvFW70bsqsM7y
 TQiLBs5JsFGCbYaoRh5kXH3dP57lWCv38UDwrZ0/zpdw1LMOtW
 OGzGBwd9zblZnO4HeWWOMBhwvWAZ7C+Xa/hsyRTs9gJll7A7NY
 GfpWEqC8TAAWFPCc7E04=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2014 07:30:56 Guenter Roeck wrote:
> On 06/23/2014 03:31 AM, Maxime Ripard wrote:
> > On Thu, May 22, 2014 at 02:12:07PM -0700, Guenter Roeck wrote:
> >> On Thu, May 22, 2014 at 10:34:44PM +0200, Maxime Ripard wrote:
> >>> On Mon, May 19, 2014 at 05:04:22PM +0200, Maxime Ripard wrote:
> >>
> >> The patches _are_ in my watchdog-next branch and get some coverage from
> >> both my auto-builders and from Fenguang's build robots, so while they are
> >> not in linux-next, they are not completely in the dark either.
> >
> > So, this patch finally didn't make it into 3.16. Great. Now, we can't
> > even reboot the boards.
> >
> > Given how it's just impossible to get something merged reliably
> > through the watchdog tree, I guess I should just start merging the
> > patches through mine?
> >
> 
> You can not really blame Wim here.
> 
> In this case, I suspect the major reason for not accepting the patch
> is that I tried to provide a clean method / API for "reset through watchdog
> subsystem", which went nowhere, in my understanding because someone objected
> that it would be the wrong thing to do [1] and it didn't get approval /
> acceptance from the arm maintainers. If it is wrong to reset the board
> from the watchdog subsystem in a clean way, it is for sure even more wrong
> to do it as you proposed in your patch.
> 
> My conclusion therefore is that all board reset code should move back out
> of the watchdog subsystem, and that we should not accept such code in the
> future. This is not my personal preference, but I do believe that we should
> do it in a clean way or not at all.

Moved to where?

I certainly don't want it in the platform directories, and for arm64 we
intentionally don't have a place to put this stuff.

drivers/power/reset would be an option, but then we have to solve the
problem of loading two drivers for one device first.

	Arnd

