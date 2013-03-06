Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab3CFRlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:41:22 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:23994 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753291Ab3CFRlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:41:20 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX180fJSDno5XTamH/m/sMspE
Date: Wed, 6 Mar 2013 09:16:13 -0800
From: Tony Lindgren <tony@atomide.com>
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 6/9] [media] ir-rx51: fix clock API related build issues
Message-ID: <20130306171612.GL11806@atomide.com>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
 <1362521809-22989-7-git-send-email-arnd@arndb.de>
 <20130305212351.4993d8c6@redhat.com>
 <20130306010952.GJ11806@atomide.com>
 <20130306062218.GA1638@itanic.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130306062218.GA1638@itanic.dhcp.inet.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Timo Kokkonen <timo.t.kokkonen@iki.fi> [130305 22:26]:
> On 03.05 2013 17:09:53, Tony Lindgren wrote:
> > * Mauro Carvalho Chehab <mchehab@redhat.com> [130305 16:28]:
> > > Em Tue,  5 Mar 2013 23:16:46 +0100
> > > Arnd Bergmann <arnd@arndb.de> escreveu:
> > > 
> > > > OMAP1 no longer provides its own clock interfaces since patch
> > > > a135eaae52 "ARM: OMAP: remove plat/clock.h". This is great, but
> > > > we now have to convert the ir-rx51 driver to use the generic
> > > > interface from linux/clk.h.
> > > > 
> > > > The driver also uses the omap_dm_timer_get_fclk() function,
> > > > which is not exported for OMAP1, so we have to move the
> > > > definition out of the OMAP2 specific section.
> > > > 
> > > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > > Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> > > 
> > > From my side:
> > > Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > There's just one issue, this driver most likely only needed on
> > rx51 board.. So I suggest we just mark the driver depends on
> > ARCH_OMAP2PLUS and let's drop this patch.
> > 
> > This driver is already disabled for ARCH_MULTIPLATFORM
> > as we need to move dmtimer.c to drivers and have some minimal
> > include/linux/timer-omap.h for it.
> >  
> 
> I've also had this cunning plan that if or when the PWM subsystem
> starts supporting the PWM output in OMAP3, I could convert this driver
> to generate the IR carrier wave through the PWM subsystem and then use
> HR timers to generate the pulses. I think that's much better approach
> than trying to depend on interfaces that are not easily
> available. Should be possible, but I haven't proven yet that it will
> work :)

Sounds good to me.
 
> Unfortunately I haven't got into executing on that plan yet. In
> addition to the challenge of scheduling some of my free time for doing
> this, my RX51 device is not enumerating the USB with the latest kernel
> and I haven't figured out that yet. And because of that, I haven't
> been able to get my user space running over nfsroot setup I've been
> using..

Git bisect might help there. Maybe post the output and cc the usb
people?

Regards,

Tony
