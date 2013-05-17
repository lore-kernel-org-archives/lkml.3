Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3EQMSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 08:18:25 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59986 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754469Ab3EQMSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 08:18:23 -0400
X-Sasl-enc: Vxx881UpGVN0C9fech/IjaRd2CSyEUtfWy4ebzPHFubk 1368793102
Date: Fri, 17 May 2013 22:18:19 +1000
From: Robert Norris <robn@opera.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Daniel Kurtz <djkurtz@chromium.org>, linux-kernel@vger.kernel.org,
        Linux I2C <linux-i2c@vger.kernel.org>
Subject: Re: PROBLEM: modprobe hang at startup (3.8.x, 3.9.x, IBM x3550)
Message-ID: <20130517121819.GA3165@pyro.melbourne.osa>
References: <1368408152.29197.140661229821177.2C1CC406@webmail.messagingengine.com>
 <20130514231626.GA12961@pyro.melbourne.osa>
 <20130515112044.753bb7bb@endymion.delvare>
 <20130515112741.GA23766@pyro.melbourne.osa>
 <20130515214923.036dabdb@endymion.delvare>
 <20130516034455.GA19452@pyro.melbourne.osa>
 <20130517103622.5000d277@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130517103622.5000d277@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17, 2013 at 10:36:22AM +0200, Jean Delvare wrote:
> IPMI is still likely to access the SMBus controller. If there's a BMC
> in the machine, it can also access the SMBus slave with its own
> controller. It would be good to rule this out by disabling IPMI
> completely, removing the BMC from the machine if it has one, and
> checking if it makes the issue go away or not.

This ended up being easier than I thought. The BMC can't be physically
removed, but there is a jumper on the board to disable it. We flipped it
and got a message during POST about it not being present. Additionally
all IPMI functions did nothing (hung, but interruptable) which is what
you'd expect. I think it really is disabled.

In this state, I re-ran the previous tests, with identical results. That
is:

- "modprobe i2c_i801" succeeds
- "modprobe i2c_i801 disable_features=0x10" succeeds
- With interrupts disabled, "modprobe ics932s401"
- With interrupts enabled, "modprobe ics932s401" hangs
- With interrupts enabled, "i2cget 4 0x50 0x00" hangs

I'll leave the BMC disabled for now in case that's important for further
testing. If you need other tests run with the BMC enabled, I'll use a
differen machine.

Cheers,
Rob.
