Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaA0EaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 23:30:07 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:48335 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaA0EaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 23:30:03 -0500
Date: Sun, 26 Jan 2014 23:30:00 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Alan Cox <alan@etchedpixels.co.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Mark Brown <broonie@kernel.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
 device probe
In-Reply-To: <20140126115402.GA25689@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.11.1401262318350.1652@knanqh.ubzr>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org> <1390208555-27770-2-git-send-email-tushar.behera@linaro.org> <20140120100530.GY15937@n2100.arm.linux.org.uk> <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
 <20140120214305.54f65ffa@www.etchedpixels.co.uk> <20140120231457.GZ17314@sirena.org.uk> <20140120234734.11b78578@www.etchedpixels.co.uk> <20140121001657.GO15937@n2100.arm.linux.org.uk> <50b66ac6-1150-4ad7-aeaf-3d0dce77334d@email.android.com>
 <20140126115402.GA25689@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jan 2014, Russell King - ARM Linux wrote:

> On Tue, Jan 21, 2014 at 12:45:05AM +0000, Alan Cox wrote:
> > Peter handed it on. Try using git log on Documentation/devices.txt. It
> > still gets updates.
> > 
> > Perhaps you'd care to stick to reality and fix the tree instead of trying
> > to excuse the mess ?
> 
> Perhaps returning to reality might be advantageous rather than trying
> to repeat statements which can't have any bearing on this - especially
> as the git history which you're referring to only goes back to 2.6.12-rc2,
> and this predates 2.6.12-rc2 by a long shot.
> 
> > More importantly certain folks need to stop abusing static numbers
> > allocated properly. Repeating it having made a total hash of it before
> > is dismal.
> 
> And if you continue these stupid accusations which have no basis at all,
> we're going to get into a real big argument, because you are soo _wrong_
> on that point.  I was always the one arguing /against/ the re-use of
> existing major/minor numbers.  I was the one arguing /against/ Nicolas'
> patches to make every serial port appear in the 4,64 ttyS namespace.

If you remember correctly, that was my attempt at making serial port 
minor assignment to be dynamic... just like everything else is today.  
And it seemed to me that you thought this was a good idea.

But that was objected by the X86 folks who insisted on always having 
COM1 == ttyS0 and COM2 == ttyS1, whether or not COM1 was present.

Nowdays serial ports have pretty much disappeared from the X86 world.  
But the problem they've created is still with us.

Either everything is dynamic, or everything follows proper minor 
assignment process.


Nicolas
