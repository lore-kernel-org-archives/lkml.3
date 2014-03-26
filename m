Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226AbaCZGue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 02:50:34 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:57013 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaCZGuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 02:50:32 -0400
Date: Wed, 26 Mar 2014 07:50:29 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alexander Elbs <alex@segv.de>, Nicolas Pitre <nico@fluxnic.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: mvsdio: unhandled interrupt, mmc writes queuing up
Message-ID: <20140326075029.4fcc6675@pluto>
In-Reply-To: <20140326000735.GI28304@titan.lakedaemon.net>
References: <20140325192759.GJ29769@segv.de>
	<53320055.9080307@gmail.com>
	<20140326000735.GI28304@titan.lakedaemon.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

Will try this out this evening when I'm back home (and have some time
to reboot the sheevaplug).


Note that the write-back stalls seem to be nilfs2 specific (I'm getting
them on usb-storage as well while ext4 filesystem on usb-storage
does not present the stall issue).

Bruno


On Tue, 25 Mar 2014 20:07:35 -0400 Jason Cooper wrote:
> On Tue, Mar 25, 2014 at 11:16:53PM +0100, Sebastian Hesselbarth wrote:
> > On 03/25/2014 08:27 PM, Alexander Elbs wrote:
> > >> On Wed, 19 Mar 2014, Bruno Prémont wrote:
> > >>> Since upgrading my Sheevaplug from 3.7.2 to 3.13.6 (FDT) I'm seeing
> > >>>   mvsdio f1090000.mvsdio: unhandled interrupt status=0x8810 en=0x0000 pio=0
> > >>> at varied timings.
> > > 
> > > I have the same problem on my sheevaplug.
> > > 
> > >> It has been many years since I've looked at the code for this driver.  
> > >> I'm therefore including Thomas Petazzoni to the CC list as he appears to 
> > >> have been the most active since then.
> > >>
> > >> The reported status seems to indicate missing data in the context of a 
> > >> transfer with CMD12, and a CRC error ensued of course.
> > >>
> > >> At this point I'd suggest testing intermediate kernels between 3.7 and 
> > >> 3.13, and try bisection until you find the offending commit.
> > >>
> > >> [...]
> > >>> I get same results with 3.14-rc7.
> > >>
> > >> Excellent, that reduces the search space significantly.  You can do a 
> > >> git bisect directly.
> > > 
> > > I did a git bisect.
> > >   good: no message "unhandled interrupt"
> > >   bad: message above appears
> > >   skipped: unbootable kernel, usually stuck after the line "Uncompressing Linux". 
> > > 
> > > So far I am down to a few commits after 3.11.
> > > 
> > > $ git bisect view --oneline
> > > 2326f04 (refs/bisect/bad) ARM: kirkwood: convert to DT irqchip and clocksource
> > 
> > Can you please try the patches contained in [1]?
> > 
> > They have been Acked-by Jason Cooper, but I guess we simply lost
> > track of them.
> > 
> > Sebastian
> > 
> > [1] https://lkml.org/lkml/2013/11/15/276
> 
> Bruno,
> 
> If these work for you, please send a Tested-by and I'll keep better
> track of them this time.  I think these were sent before we had a
> process for shuttling things into irqchip...
> 
> thx,
> 
> Jason.
