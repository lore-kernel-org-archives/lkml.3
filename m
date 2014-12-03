Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbaLCRrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:47:06 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:35308 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaLCRrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:47:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Dec 2014 18:49:13 +0100
From: Stefan Agner <stefan@agner.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, shawn.guo@linaro.org,
        kernel@pengutronix.de, linux@arm.linux.org.uk,
        u.kleine-koenig@pengutronix.de, jason@lakedaemon.net, olof@lixom.net,
        daniel.lezcano@linaro.org, tglx@linutronix.de, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/12] Documentation: dt: imx: add MSCM documentation
In-Reply-To: <57320597.hlx9GuXmaF@wuerfel>
References: <1417565531-4507-1-git-send-email-stefan@agner.ch>
 <1417565531-4507-8-git-send-email-stefan@agner.ch>
 <57320597.hlx9GuXmaF@wuerfel>
Message-ID: <b1d6e3afefac65c6424040c08689b750@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Dec  3 18:46:27 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 547f4c7312815259298571
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-03 11:52, Arnd Bergmann wrote:
> On Wednesday 03 December 2014 01:12:06 Stefan Agner wrote:
>> +Freescale Vybrid Miscellaneous System Control Module
>> +
>> +The MSCM IP contains Access Control and TrustZone Security hardware,
>> +CPU Configuration registers and Interrupt Router control.
>> +
>> +Required properties:
>> +- compatible : "fsl,vf610-mscm"
>> +- reg : the register range of the MSCM module
>> +
>> +Example:
>> +       mscm: mscm@40001000 {
>> +               compatible = "fsl,vf610-mscm";
>> +               reg = <0x40001000 0x1000>;
>> +       };
> 
> This sounds like one of those generic system controller devices.
> Should this be marked as syscon an accessed through
> syscon_regmap_lookup_by_phandle()?
> 
> If you only eve have one driver touching these registers, that
> won't be necessary of course.
> 

So far, in upstream code the module is not used at all (other than in
U-Boot setting up the interrupt router in a static manner). I think it
is not that "miscellaneous" as it sounds, it mainly controls and
provides information regarding the dual-core stuff, for instance provide
interrupt flags for the CPU-to-CPU interrupts or exports CPU information
(beside the interrupt routing thing). I don't know (yet) if and how we
want export support for that interrupt. We would certainly need it to
support some message based framework (Freescale used it for their
out-of-tree MCC (multi-core communication) stuff, probably we would need
it to implement rpmsg support...).

--
Stefan

