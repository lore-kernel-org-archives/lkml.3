Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaGNHLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:11:04 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:60999 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaGNHKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:10:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Mon, 14 Jul 2014 09:10:54 +0200
From: Stefan Agner <stefan@agner.ch>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>, wg@grandegger.com,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: flexcan: add vf61x support for flexcan
In-Reply-To: <cecd42e333cdf65ad512f719125f9180@agner.ch>
References: <1405075933-22317-1-git-send-email-stefan@agner.ch>
 <53BFD401.8030101@pengutronix.de>
 <dac76ccd134f41b86f00352d10cfae4b@agner.ch> <20140714060344.GB2197@dragon>
 <cecd42e333cdf65ad512f719125f9180@agner.ch>
Message-ID: <7da069ecd355069d82cbe95adc1043f5@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-07-14 09:06, schrieb Stefan Agner:
> Am 2014-07-14 08:04, schrieb Shawn Guo:
>> On Fri, Jul 11, 2014 at 03:58:37PM +0200, Stefan Agner wrote:
>>> >> @@ -362,7 +374,7 @@
>>> >>
>>> >>  			esdhc1: esdhc@400b2000 {
>>> >>  				compatible = "fsl,imx53-esdhc";
>>> >> -				reg = <0x400b2000 0x4000>;
>>> >> +				reg = <0x400b2000 0x1000>;
>>> >
>>> > What's that doing here? :)
>>>
>>> That's an error I just stumbled upon.
>>
>> I do not see why it's an error.  From Table 2-1. System Memory Map in
>> i.MX53 RM, the size of ESDHC1 is 16K.
>>
>> Shawn
> 
> But then, the memory map within the SDHC peripheral has some registers
> also located in 0x400B3000. Hence I think 0x2000 is correct. Will send
> an updated and separated patch.
> 

Sorry, I read this wrong. It is SDHC1 which is in the upper 0x1000 of
the memory map.

So I would say 0x1000 is really correct, since SDHC0 is at 0x400B1000
and SDHC1 is at 0x400B2000.

--
Stefan
