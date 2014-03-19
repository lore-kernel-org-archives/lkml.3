Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbaCSGhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 02:37:47 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:46568 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaCSGhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 02:37:45 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9DbcbmpiO4kpRAxeHilw==
X-RZG-CLASS-ID: mo00
Message-ID: <53293B31.2060406@hartkopp.net>
Date: Wed, 19 Mar 2014 07:37:37 +0100
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Markus Pargmann <mpa@pengutronix.de>,
        Benedikt Spranger <b.spranger@linutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [patch 02/12] can: c_can: Fix hardware raminit function
References: <20140318171007.528610837@linutronix.de> <20140318171126.720944558@linutronix.de> <532892BC.7080406@pengutronix.de> <alpine.DEB.2.02.1403182313110.18573@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403182313110.18573@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.03.2014 23:15, Thomas Gleixner wrote:
> On Tue, 18 Mar 2014, Marc Kleine-Budde wrote:
>> On 03/18/2014 06:19 PM, Thomas Gleixner wrote:
>>> +static void c_can_hw_raminit_wait(const struct c_can_priv *priv, u32 mask,
>>> +				  u32 val)
>>> +{
>>> +	/* We look only at the bits of our instance. */
>>> +	val &= mask;
>>> +	while ((readl(priv->raminit_ctrlreg) & mask) != val)
>>> +		udelay(1);
>>
>> Do we have to add a timeout here, or is it "safe" to have a potential
>> endless loop here? As you have probably tortured the hardware and driver
>> a lot (or have been tortured by them), I assume you would have added a
>> timeout check if you had seen a lockup here.
> 
> I haven't seen any failure on that. We could add a timeout for
> paranoia reasons. I'm quite sure that the raminit works as advertised
> when we do it the right way. The only way to wreckage it so far is by
> not waiting for it to complete.

As long as it is 100% guaranteed that we

1. really work on a valid C_CAN core
2. this CAN controller can not be unplugged

not adding a timeout would be ok.

I remember a system hang with a SJA1000 based PCMCIA card when unplugged
under heavy load:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=a7762b10c12a70c5dbf2253142764b728ac88c3a

Regards,
Oliver

