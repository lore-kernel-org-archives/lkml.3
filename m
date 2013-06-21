Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423300Ab3FUIMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 04:12:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:37449 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161189Ab3FUIMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 04:12:37 -0400
Date: Fri, 21 Jun 2013 10:12:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: =?ISO-8859-15?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: clocksource with changing frequency?
In-Reply-To: <51C39B1A.5070902@linaro.org>
Message-ID: <alpine.DEB.2.02.1306211010000.4013@ionos.tec.linutronix.de>
References: <f5e5d3d7-699d-4f89-80c8-849e432e8b26@VA3EHSMHS017.ehs.local> <51C39B1A.5070902@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1027165253-1371802358=:4013"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1027165253-1371802358=:4013
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 20 Jun 2013, John Stultz wrote:

> On 06/20/2013 05:01 PM, Sören Brinkmann wrote:
> > Hi all,
> > 
> > I have a question/problem with a clocksource whose input frequency can
> > change.
> 
> That behavior isn't supported by the clocksource core. We expect frequency
> changing clocksources to be detected and disqualified (as we do w/ freq
> changing TSCs on older laptops).
> 
> 
> > On Zynq we use the cadece_ttc timer as clocksource. Its input clock is
> > tightly coupled to the CPU clock. I.e. it changes when cpufreq scales
> > the CPU clocks.
> > To compensate this, I added a clock notifier doing this on a frequency
> > change:
> > 	clocksource_unregister(&ttccs->cs);
> > 	clocksource_register_hz(&ttccs->cs, ndata->new_rate / PRESCALE);
> 
> This will definitely have problems if this is the only high-res capable
> clocksource.

And starting with 3.11 it will be not longer possible to unregister
the only high-res capable clocksource exactly to prevent the wreckage
you are talking about :)

Thanks,

	tglx

--8323329-1027165253-1371802358=:4013--
