Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbaLCQPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:15:22 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40562 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbaLCQPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:15:20 -0500
Date: Wed, 3 Dec 2014 11:14:52 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Andrey Skvortsov <andrej.skvortzov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Gary.Zambrano@qlogic.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        b43-dev <b43-dev@lists.infradead.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH] SSB / B44: fix WOL for BCM4401
Message-ID: <20141203161452.GD2896@tuxdriver.com>
References: <20141201111125.GA11974@localhost.localdomain>
 <1417466798-15735-1-git-send-email-Andrej.Skvortzov@gmail.com>
 <20141201221023.79ffb40d@wiggum>
 <20141202200129.GA4580@crion89>
 <20141202211211.7e08b935@wiggum>
 <547E3BF5.5060201@lwfinger.net>
 <20141203161855.50951aa8@wiggum>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141203161855.50951aa8@wiggum>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 04:18:55PM +0100, Michael Büsch wrote:
> On Tue, 02 Dec 2014 16:23:49 -0600
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
> > On 12/02/2014 02:12 PM, Michael Büsch wrote:
> > > On Tue, 2 Dec 2014 23:01:29 +0300
> > > Andrey Skvortsov <andrej.skvortzov@gmail.com> wrote:
> > >
> > >> On Mon, Dec 01, 2014 at 10:10:23PM +0100, Michael Büsch wrote:
> > >>> On Mon,  1 Dec 2014 23:46:38 +0300
> > >>> Andrey Skvortsov <andrej.skvortzov@gmail.com> wrote:
> > >>>
> > >>>> Wake On Lan was not working on laptop DELL Vostro 1500.
> > >>>> If WOL was turned on, BCM4401 was powered up in suspend mode. LEDs blinked.
> > >>>> But the laptop could not be woken up with the Magic Packet. The reason for
> > >>>> that was that PCIE was not enabled as a system wakeup source and
> > >>>> therefore the host PCI bridge was not powered up in suspend mode.
> > >>>> PCIE was not enabled in suspend by PM because no child devices were
> > >>>> registered as wakeup source during suspend process.
> > >>>> On laptop BCM4401 is connected through the SSB bus, that is connected to the
> > >>>> PCI-Express bus. SSB and B44 did not use standard PM wakeup functions
> > >>>> and did not forward wakeup settings to their parents.
> > >>>> To fix that B44 driver enables PM wakeup and registers new wakeup source
> > >>>> using device_set_wakeup_enable(). Wakeup is automatically reported to the parent SSB
> > >>>> bus via power.wakeup_path. SSB bus enables wakeup for the parent PCI bridge, if there is any
> > >>>> child devices with enabled wakeup functionality. All other steps are
> > >>>> done by PM core code.
> > >>>
> > >>> Thanks, this looks good.
> > >>> I assume you tested this (I currently don't have a device to test this).
> > >>
> > >> Sure, I've tested it. WOL from suspend is working and after resume from hibernate Ethernet is working too.
> > >
> > > That sounds good, indeed.
> > > I'd still prefer, if someone with b43 (wireless) would test it, too.
> > 
> > I did a partial test with my PowerBook G4. With the patch installed, it would 
> > both suspend and hibernate, but WOL would be impossible. This computer uses a 
> > PCMCIA version of the BCM4318, and power is turned off to the PCMCIA card when 
> > suspended or hibernating.
> 
> Thanks for testing.
> 
> John, can you take this one? Or do we need to split the b44 part out?
> I added my Signed-off.

Um, sure...3.19 is OK I presume?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
