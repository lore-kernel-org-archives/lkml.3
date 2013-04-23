Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab3DWNo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:44:26 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:39848
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179Ab3DWNoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:44:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I1432I1447Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h1151h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 23 Apr 2013 21:44:50 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Andres Salomon <dilinger@queued.net>, <arm@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: Re: RFC: [PATCH] clocksource: tcb: fix min_delta calculation
Message-ID: <20130423134448.GG27475@S2101-09.ap.freescale.net>
References: <517687AB.1040309@pengutronix.de>
 <1366722524-25991-1-git-send-email-mkl@pengutronix.de>
 <51768885.4080301@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <51768885.4080301@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 03:11:33PM +0200, Marc Kleine-Budde wrote:
> On 04/23/2013 03:08 PM, Marc Kleine-Budde wrote:
> > The commit
> > 
> >     77cc982 clocksource: use clockevents_config_and_register() where possible
> > 
> > switches from manually calculating min_delta_ns (and others) and
> > clockevents_register_device() to automatic calculation via
> > clockevents_config_and_register(). During this conversation the "+ 1" in
> > 
> >     min_delta_ns = clockevent_delta2ns(1, &clkevt.clkevt) + 1;
> > 
> > was lost. This leads to problems with schedule_delayed_work() with a delay of
> > "1". Resulting in the work not scheduled in time.
> > 
> > This patch fixes the problem by increasing the min_delta to "2" ticks.
> > 
> > Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> The problem appears on at91sam9263. This patch successfully fixes the
> problem and applies to current linus/master (post v3.9-rc8).

Thanks for the fixing, Marc.

Acked-by: Shawn Guo <shawn.guo@linaro.org>

