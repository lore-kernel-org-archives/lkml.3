Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaBNCSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 21:18:15 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:49165 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaBNCSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 21:18:14 -0500
Subject: Re: OMAP: clock DT conversion issues with omap36xx
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        Nishanth Menon <nm@ti.com>
In-Reply-To: <52FC98FF.20800@ti.com>
References: <52E697C0.6000202@gmail.com> <1390848104.4936.62.camel@mars>
	 <52E772A3.4090401@ti.com> <1390901735.2963.8.camel@lovely>
	 <52E77D03.8090001@ti.com>  <52E7B361.2030601@ti.com>
	 <1390928565.4904.88.camel@mars> <1390994505.5023.32.camel@mars>
	 <52F10C3D.7000507@ti.com> <1391767923.4937.110.camel@mars>
	 <52FB748E.6050007@ti.com> <52FC8A78.1050500@ti.com> <52FC98FF.20800@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Feb 2014 03:18:07 +0100
Message-ID: <1392344287.4893.11.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-13 at 12:05 +0200, Tomi Valkeinen wrote:
> On 13/02/14 11:03, Tomi Valkeinen wrote:
> > On 12/02/14 15:18, Tomi Valkeinen wrote:
> > 
> >> However, I hacked together the patch below, which "fixes" the issue for
> >> 96m and dss fclk. It sets the clock parents so that the x2 clocks are
> >> skipped, and makes the x2 clock nodes compatible with "unused", making
> >> them effectively disappear. I only verified dss fclk, so Christoph, can
> >> you verify the 96m clock?
> > 
> > Aaand the hack patch I sent is crap... We can't skip the x2 clock path,
> > as the dpll4_mNx2_ck clock nodes handle enable/disable bit, which is
> > present on 3630 also.
> > 
> > I think the best and simplest way to fix this is by setting the
> > multiplier in the dpll4_mNx2_mul_ck nodes to 1. I don't know why I
> > didn't think of it yesterday.
> > 
> > I have a bunch of other patches needed to get the clocks right, so I'll
> > send a series separately a bit later today.
> 
> I just sent the "OMAP: OMAP3 DSS related clock patches" series to l-o
> and arm lists, which hopefully solves issues discussed in this thread.

Yes, thanks Tomi. I tested your patch series on a83x board. 96m clock
and DSS-clocks are fine now. If you want, you can add my:

 Tested-by: Christoph Fritz <chf.fritz@googlemail.com>

to your series "OMAP: OMAP3 DSS related clock patches".

The only issue left on current mainline for a83x board is that twl4030
(tps65920) doesn't set VIO as on next-20140120.

 Thanks
  -- Christoph

