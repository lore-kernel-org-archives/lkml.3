Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab3LGK4R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 05:56:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:34254 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab3LGK4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 05:56:14 -0500
Date: Sat, 7 Dec 2013 11:56:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 4/9] clocksource/cadence_ttc: Use enable/disable_irq
In-Reply-To: <f6d25456-8e30-4792-b184-21eb02dfaa1c@AM1EHSMHS001.ehs.local>
Message-ID: <alpine.DEB.2.02.1312071151340.30673@ionos.tec.linutronix.de>
References: <1385514296-26702-1-git-send-email-soren.brinkmann@xilinx.com> <1385514296-26702-5-git-send-email-soren.brinkmann@xilinx.com> <52972F3A.9090103@linaro.org> <alpine.DEB.2.02.1311281507280.30673@ionos.tec.linutronix.de>
 <b2ed3cbc-c9df-4235-8137-93514c05bffa@DB8EHSMHS031.ehs.local> <alpine.DEB.2.02.1311281939000.30673@ionos.tec.linutronix.de> <f6d25456-8e30-4792-b184-21eb02dfaa1c@AM1EHSMHS001.ehs.local>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1212725415-1386413767=:30673"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1212725415-1386413767=:30673
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 6 Dec 2013, Sören Brinkmann wrote:
> On Thu, Nov 28, 2013 at 08:07:10PM +0100, Thomas Gleixner wrote:
> > There is a solution to this. We can identify the broadcast device in
> > the core and serialize all callers including interrupts on a different
> > cpu against the update. So no need for the disable/enable_irq() dance.
> 
> IIUC, and please correct me if I'm wrong, with the patch I'd simply call
> 'clockevents_update_freq() without having to disable IRQs. But I'm not
> sure whether periodic mode is covered. I found, that I had to reprogram
> the timer interval in my clock notifier callback when the timer
> frequency changes. I think 'clockevents_update_freq()' only handles
> oneshot mode. For that reason I call 'ttc_set_interval()' in the clock
> notifier in case the timer is in periodic mode. For that call we'd still
> have possible races. I guess the best solution would be to move that
> functionality into 'clockevents_update_freq()'?

Indeed.

--8323329-1212725415-1386413767=:30673--
