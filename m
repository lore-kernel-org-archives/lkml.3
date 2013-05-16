Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3EPWa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:30:58 -0400
Received: from gloria.sntech.de ([95.129.55.99]:52564 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab3EPWa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:30:56 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: samsung: fix suspend/resume functionality
Date: Fri, 17 May 2013 00:30:38 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Doug Anderson <dianders@chromium.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Prathyush K <prathyush.k@samsung.com>,
        "linux-samsung-soc" <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1368724352-10849-1-git-send-email-dianders@chromium.org> <CAD=FV=Uqhw4GXjfQrnxzJ4U95wudF1whBcRxK8y3LZMWHTurNw@mail.gmail.com> <2099430.Q29j0K3hPy@flatron>
In-Reply-To: <2099430.Q29j0K3hPy@flatron>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305170030.39266.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 17. Mai 2013, 00:08:34 schrieb Tomasz Figa:
> On Thursday 16 of May 2013 14:51:53 Doug Anderson wrote:
> > Tomasz,
> > 
> > On Thu, May 16, 2013 at 2:27 PM, Tomasz Figa <tomasz.figa@gmail.com>
> 
> wrote:
> > > OK. I will be fine to go with your patches, after addressing the
> > > comments. In the end it's good that you posted them, as reviewing
> > > them allowed me to find even better ways of doing some things than I
> > > had in mine ;) .
> > 
> > Yes.  I often find that the best way to review code is to think about
> > how I would implement it myself.  Certainly I think we've ended up
> > with something better / less buggy this way.  ;)
> > 
> > > How all of this works is basically a good question. I couldn't find
> > > any
> > > mention about pins switching from power down to normal mode in the
> > > documentation, but maybe there is a small side note somewhere, which I
> > > could miss.
> > > 
> > > On S3C6410, for example, there are two modes. State is switched to
> > > power down mode automatically, but can be switched out either
> > > automatically on wake-up (exact timing is unknown to me) or by
> > > clearing a special bit, depending on value of other special bit.
> > > 
> > > IMHO this is rather important, so we should find out how it work on
> > > other SoCs and make the code account for it.
> > 
> > Agreed that it's important.  ...but it's also good not to have tons of
> > complexity when it's not needed.  It sounds like S3C6410 could be
> > handled OK by just using the special bits and waiting to take things
> > out of power down mode.
> > 
> > ...thinking about it, all SoCs that have power down modes (which you
> > _must_ have if your pinctrl state is lost across a low power) would be
> > slightly broken if they didn't have a bit to switch out of power down
> > mode.  Otherwise you're asking for at least some type of glitch
> > because you'll end up in the default state of pins for a little while
> > during resume.
> > 
> > That's not to say that there aren't broken SoCs out there and it's
> > entirely possible that people even designed systems around them
> > (knowing that the default state of each pin after wakeup is not
> > harmful to whatever is connected to that pin).  If there are any cases
> > like this then they would need the special code like my V1 patch had.
> > Do you know of any SoCs like this that we need to support on kernel
> > 3.10 and higher?
> 
> Hmm, I just checked documentation of S3C2440 and S3C2416 they seem to
> retain GPIO settings completely in sleep mode. This would mean that they
> don't require any suspend/resume support in pinctrl driver. Heiko, can you
> confirm this?

Hmm, my system does not have a working suspend right now, but looking at the 
legacy code (mach-s3c24xx/pm.c, etc) tells me that the gpio banks were never 
saved during suspend.

And as there were (and still are) systems with working suspend around, I'd 
assume that you're correct that the pins retain their state.

Is the same true for the s3c64xx, as I didn't find any gpio suspend handling 
for it either.


Heiko
