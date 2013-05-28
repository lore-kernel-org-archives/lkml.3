Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263Ab3E1LmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 07:42:18 -0400
Received: from smtp2.goneo.de ([212.90.139.82]:57665 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933051Ab3E1LmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 07:42:17 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.843
From: Lars Poeschel <poeschel@lemonage.de>
To: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH 00/14] misc/ep93xx_pwm: cleanup driver for conversion to PWM framework
Date: Tue, 28 May 2013 13:42:05 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>,
        "mcrapet@gmail.com" <mcrapet@gmail.com>
References: <201305241619.52328.hartleys@visionengravers.com> <201305271912.08882.arnd@arndb.de> <20130528110011.GC11547@mithrandir>
In-Reply-To: <20130528110011.GC11547@mithrandir>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201305281342.05530.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 May 2013 at 13:00:12, Thierry Reding wrote:
> On Mon, May 27, 2013 at 07:12:08PM +0200, Arnd Bergmann wrote:
> > On Monday 27 May 2013, H Hartley Sweeten wrote:
> > > Also, I have a question about the conversion.
> > > 
> > > If I strip the sysfs support out of this driver the conversion is
> > > quite simple. But, my use for this driver requires user space
> > > control of the PWM.
> > > 
> > > Should I:
> > > 1) convert the driver to the PWM framework and leave the sysfs stuff
> > > in it 2) work out a generic sysfs support for the PWM framework and
> > > then
> > > 
> > >     convert the driver
> > > 
> > > 3) other...
> > > 
> > > I've been looking at 2) by doing something like how gpiolib does it.
> > > Do you think that would be acceptable?
> > 
> > That would be for Thierry to decide. It does sound better to me than
> > the 1) and I don't have a better idea for 3).
> > 
> > I wonder how the arbitration between in-kernel and user-space
> > consumers of the pwm lines would work though.
> 
> I've added Lars Poeschel on Cc, who's done some work on a sysfs
> interface for the PWM subsystem already. It's undergone some review
> already[0] and I think he's working on a v2 now.
> 
> Thierry
> 
> [0]: http://marc.info/?l=linux-kernel&m=136499756101273&w=2

I currently do not have the time to work on a v2 of the pwm sysfs patch but 
I will do it as soon as possible - if not someone else will do. 
Unfortunately my current involvements in other project will not allow me to 
do so for at least next two months.
I received some off-list reactions to my patches from users asking for pwm 
sysfs, so there is definitely a need for it!
If you decide to take attempt 2) (which is preferable) I recommend you to 
take a look at what I have done and Thierrys review comments. I took the 
gpiolib way and the result got rejected for very good reasons.

Regards,
Lars
