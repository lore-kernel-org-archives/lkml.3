Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750757Ab3LJT2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:28:18 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:7580
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840Ab3LJT2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:28:15 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzbb2dI98dI9371I936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh2a8h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h286p1155h)
Message-ID: <1386703586.6211.7.camel@linux-builds1>
Subject: Re: [PATCHv5 1/2] clocksource: dw_apb_timer_of: Fix read_sched_clock
From: Dinh Nguyen <dinguyen@altera.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: <dinh.linux@gmail.com>, <mingo@kernel.org>, <tglx@linutronix.de>,
        <jamie@jamieiles.com>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <heiko@sntech.de>
Date: Tue, 10 Dec 2013 13:26:26 -0600
In-Reply-To: <52A76329.7070704@linaro.org>
References: <1386691678-29618-1-git-send-email-dinguyen@altera.com>
	 <52A76329.7070704@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 19:53 +0100, Daniel Lezcano wrote:
> On 12/10/2013 05:07 PM, dinguyen@altera.com wrote:
> > From: Dinh Nguyen <dinguyen@altera.com>
> >
> > The read_sched_clock should return the ~value because the clock is a
> > countdown implementation. read_sched_clock() should be the same as
> >   __apbt_read_clocksource().
> >
> > Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
> > ---
> > v5: Split up into 2 patches
> > v4: Simplify the fix by simply returning ~__raw_readl(sched_io_base)
> > v3: Use APBTMR_N_CURRENT_VALUE define in read_sched_clock()
> > v2: Maintain backwards compatibility for "dw-apb-timer-sp" and
> >        "dw-apb-timer-osc".
> > ---
> >   drivers/clocksource/dw_apb_timer_of.c |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
> > index 45ba8ae..b29d7cd 100644
> > --- a/drivers/clocksource/dw_apb_timer_of.c
> > +++ b/drivers/clocksource/dw_apb_timer_of.c
> > @@ -108,7 +108,7 @@ static void __init add_clocksource(struct device_node *source_timer)
> >
> >   static u64 read_sched_clock(void)
> >   {
> > -	return __raw_readl(sched_io_base);
> > +	return ~__raw_readl(sched_io_base);
> >   }
> 
> Dinh,
> 
> I dropped the patch moving the macro definitions as it is not applied 
> for urgent and I assume it is not needed for the 3.14 as there are no 
> more patches depending on it.

That's fine. Thanks Daniel!

Dinh
> 
>    -- Daniel
> 
> >   static const struct of_device_id sptimer_ids[] __initconst = {
> >
> 
> 



