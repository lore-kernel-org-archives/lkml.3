Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaBJUzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:55:05 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:62879 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaBJUzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 15:55:03 -0500
Subject: Re: OMAP: clock DT conversion issues with omap36xx
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
        Nishanth Menon <nm@ti.com>
In-Reply-To: <52F4E45B.1020107@ti.com>
References: <52E697C0.6000202@gmail.com> <1390848104.4936.62.camel@mars>
	 <52E772A3.4090401@ti.com> <1390901735.2963.8.camel@lovely>
	 <52E77D03.8090001@ti.com>  <52E7B361.2030601@ti.com>
	 <1390928565.4904.88.camel@mars> <1390994505.5023.32.camel@mars>
	 <52F10C3D.7000507@ti.com> <1391767923.4937.110.camel@mars>
	 <52F4E45B.1020107@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Feb 2014 21:54:56 +0100
Message-ID: <1392065696.4898.163.camel@mars>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-07 at 15:49 +0200, Tomi Valkeinen wrote:
> On 07/02/14 12:12, Christoph Fritz wrote:
> 
> > Yes, your patch fixes the issues for sys_clkout2. Thanks! If you want,
> > you can add my:
> > Tested-by: Christoph Fritz <chf.fritz@googlemail.com>
> > 
> > Below is my clock fix for dss:
> > 
> > From b90a62128068e1b6b0ba2a11c5cc0c8e587cf301 Mon Sep 17 00:00:00 2001
> > From: Christoph Fritz <chf.fritz@googlemail.com>
> > Date: Fri, 7 Feb 2014 10:51:15 +0100
> > Subject: [PATCH] ARM: dts: omap36xx: fix dpll4_m4_ck tree
> > 
> > OMAP36xx has different hardware implementation for the dpll4_m4_ck tree
> > compared to other OMAP3 variants. Reflect this properly in the dts file.
> 
> I rebased the DSS DT branch on top of v3.14-rc1, and I'm trying to get
> beagle-xM working. Pinmuxing was wrong, but after fixing that, the
> clk_set_rate for dss fclk failed. I applied Tero's and your patches, but
> now when starting omapdss I see:
> 
> [   19.704193] omap clock: module associated with clock
> dss1_alwon_fck_3430es2 didn't enable in 1000
> 00 tries
> 
> I wonder if I'm still missing some patch?

Is beagle-xM using DSI? Because here the LILLY-A83X board is not. The
clock registers are all fine now as before the dt clock conversion
patches.

I suppose you are using current linus tree. I tested 'next' but didn't
get DSS working. I guessed that it would have something to do with early
DSS DT integration issues.

I'll rebase my current dt board support patchset for LILLY-A83X to
current linus tree and investigate DSS further.

 Thanks
  -- Christoph

