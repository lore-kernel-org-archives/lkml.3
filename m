Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbbAZLzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:55:24 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:48431 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbAZLzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:55:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Jan 2015 12:55:07 +0100
From: Stefan Agner <stefan@agner.ch>
To: Thomas Gleixner <tglx@linutronix.de>, marc.zyngier@arm.com
Cc: jason@lakedaemon.net, u.kleine-koenig@pengutronix.de, shawn.guo@linaro.org,
        kernel@pengutronix.de, arnd@arndb.de, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v3 0/3] irqchip: vf610-mscm: add support for MSCM
 interrupt router
In-Reply-To: <alpine.DEB.2.11.1501261115300.5526@nanos>
References: <1421309046-22452-1-git-send-email-stefan@agner.ch>
 <alpine.DEB.2.11.1501261115300.5526@nanos>
Message-ID: <36990c90fa3d2ee0849227f31cbafb54@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015-01-26 11:16, Thomas Gleixner wrote:
> On Thu, 15 Jan 2015, Stefan Agner wrote:
> 
>> Splitted out version of the MSCM driver. My first driver based on the
>> routeable domain support and was part of the Vybrid Cortex-M4 support
>> patchset.
>>
>> So far the MSCM interrupt router was initialized by the boot loader
>> and configured all interrupts for the Cortex-A5 CPU. There are two
>> use cases where a proper driver is necessary:
>> - To run Linux on the Cortex-M4. When the kernel is running on the
>>   non-preconfigured CPU, the interrupt router need to be configured
>>   properly.
>> - To support deeper sleep modes: LPSTOP clears the interrupt router
>>   configuration, hence a driver needs to restore the configuration
>>   on resume.
>> I created a seperate patchset for that driver which hopefully makes
>> it easier to get it into mergeable state.
>>
>> Since I identified some registers likely to be used by other drivers
>> (e.g. CPU ID or the CPU Generate Interrupt Register) I also added
>> the "syscon" compatible string to make the registers available for
>> other drivers in case needed.
>>
>> This resend version of this patchset is rebased on v3.19-rc4.
> 
> Has the discussion with Marc on the original V3 set been resolved?

There was no answer to the original v3 patch. The comments of Marc was
back in the v2 set, and has been resolved in v3. However, no Ack from
Marc so far.

 
> What about the DT bindings? I'm relucant to pick that up w/o acks from
> the DT folks.

The bindings are straight forward interrupt-controller bindings, since
it uses the hierarchic irq domain stuff. The only uncommon thing is that
I also added "syscon" as compatible, since the module has functionality
which might be required by other drivers (e.g. register to generate
CPU2CPU interrupt or processor personality information).

--
Stefan
