Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab3AONXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 08:23:41 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59085 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930Ab3AONXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:23:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 04/18] power: ab8500_fg: Replace msleep() with usleep_range() for greater accuracy
Date: Tue, 15 Jan 2013 13:23:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Joe Perches <joe@perches.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        cbouatmailru@gmail.com, Jonas Aaberg <jonas.aberg@stericsson.com>
References: <1357909986-9262-1-git-send-email-lee.jones@linaro.org> <1358183857.19400.13.camel@joe-AO722> <20130115084821.GT12385@gmail.com>
In-Reply-To: <20130115084821.GT12385@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301151323.28879.arnd@arndb.de>
X-Provags-ID: V02:K0:1n0rEc1zASYf3rrcJtVISbQGxJW7q823zmk/T3mHtw4
 0Po6n97Q+Z5rIg+2Kw+QQJacqn608AYNjsLXzzJVep9XcJL3yb
 /5PZO39s0ss1z9wlefNEkf7R3FqmWPccMYpnQ/fGX2iiLDAQ3e
 vxpJV+jTiIWdISkDjrJW5YkenG1F9ygszPFTLoEzyaKn2rS7Q4
 LGwQpcTECIishnc0zA99Ar139pwXNGhGxofkcAJU2LWGCjEarq
 dYHLVtKLFuDSJiHTzXQ311+gUcDFlZVIvNRVqR2Nm/UfsJPy9K
 LCYwbuoZ1ZF31IVGG22u5/pGGUkC2bTkXDfLdCBZSKtVWxiuuH
 EAIOXkImm3dQGOcXWfCk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2013, Lee Jones wrote:
> > > @@ -956,7 +956,7 @@ static int ab8500_fg_load_comp_volt_to_capacity(struct ab8500_fg *di)
> > >     do {
> > >             vbat += ab8500_fg_bat_voltage(di);
> > >             i++;
> > > -           msleep(5);
> > > +           usleep_range(5000, 5001);
> > 
> > If you're going to give a range that small
> > you might as well use usleep instead.
> > 
> > Otherwise, add some tolerance to allow any
> > other coalesced wakeup to occur.
> 
> I can't increase the tolerance, as I don't know how that would
> effect the running of the system, and the person who would know
> is off on parental leave.

The function only averages the voltage between a couple of readings.
It won't change much if those register reads are slightly more
uniformly timed. Note that the thread can still be preempted for
a much longer time if anything else is running, and the entire
interrupt handling in this driver looks so fragile that I would
not rely on the interrupt actually happening at the right time
anyway. I think it should first be debugged properly to remove
the need for the enable_irq/disable_irq calls.

	Arnd
