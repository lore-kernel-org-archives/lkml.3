Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab3AQQ4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:56:33 -0500
Received: from nm3.access.bullet.mail.mud.yahoo.com ([66.94.237.204]:24411
	"EHLO nm3.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754787Ab3AQQ4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:56:31 -0500
X-Yahoo-Newman-Id: 262744.78599.bm@smtp103.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 7SiJkjYVM1k6w5LXVAJj_XAD6ImXE2qPmLwy8Gz9C2BKsEF
 8GEoss1Lb4Jc7dym7wNS10I9XKYTvQeexTm5eWLU_KcJ26mbIGBHvS.ZI.CT
 hx5fUiOgXRgQWWXApsu3_ETFsjD1zXDl2OlFjrsTMTGQi4_RK_RlHzZhytH3
 I8lsJwO41mEfNVP0mlspS00NlmF6q.VJR.mZwmmn70AJuMi.UTYA7SuZcu2c
 SdCauIwX23NDomd9q_KG5KGDaCGP0pJCPNT_Qj6fhO1DsKA_FGwbg7qCaK8T
 4guTWn3RBgmx0ioZKGiOahEh30lUZIZqeod5ioGtTneLwkmF0QGC2TlDE4HY
 wIh_H9O.anlxGzfvQQNeF0uzBrQTteCtWyiL9c0deUodsqe8oedhyPZEEz0c
 L.AIFE3ZWIpIzGIyp2Lyga.29oixz1jJ2_xlIMsRXVWOTLmK.4WOhUqJzz6y
 Fj_QBgGT84m9OpVLNDtjULmAByA--
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc
To: Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH 0/4] gpio: introduce descriptor-based interface
Date: Thu, 17 Jan 2013 08:50:43 -0800
User-Agent: KMail/1.9.9
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alex Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <CACRpkda6dqAj+DzrMCnKET7Z9PtuW0+k9ea3YDL8Z1D=oFVRpQ@mail.gmail.com> <50F7E83E.8000105@uclinux.org>
In-Reply-To: <50F7E83E.8000105@uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201301170850.43655.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 January 2013 4:02:06 am Greg Ungerer wrote:
> Hi Linus,
>
> (My gerg@snapgear.com email no longer gets to me, gerg@uclinux.org is
> the best direct email for me now).
>
> On 01/17/2013 09:15 PM, Linus Walleij wrote:
> > On Thu, Jan 10, 2013 at 11:08 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> I've tried to find platforms that don't yet use GPIOLIB and fortunately
> >> there are very few left:
> >>
> >> I found two that provide the generic gpio interfaces when gpiolib
> >> is disabled, but use gpiolib otherwise for the same hardware,
> >> arch/m68k/include/asm/mcfgpio.h and arch/blackfin/include/asm/gpio.h.
> >> I would assume that we can simply remove the non-gpiolib shortcut
> >> here at cost of a small overhead.
> >
> > Geert/Greg: interested in looking into this issue?
> >
> > The GPIO maintainers want to get rid of non-gpiolib platforms.
>
> Steven King did most of the ColdFire GPIO work (CC'ed on this).
> Steven: are you happy to drop the non-gpiolib support?
>
> Regards
> Greg

Well, my concern is the small, single chip platforms with limited ram and 
speeds measured in MHz.  My goal was that these platforms that had very basic 
gpio needs, no offboard gpio, just toggling a few pins for spi or whatever, 
could do that without pulling in a bunch of code they dont need.  I realize 
that for x86 or arm people with their giga Hz cpus with gigabytes of ram, its 
no big deal, but my little 60 MHz coldfire v2s with only 16 megs of ram (and 
even more constraining, 2 megs of flash) need all the help they can get.

I haven't been keeping up with the kernel list of late, can someone point me 
to what''s being discussed so I can see what were talking about here?
