Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbbAJQiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 11:38:08 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34164 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbbAJQiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 11:38:07 -0500
Message-ID: <54B1556C.7070401@wwwdotorg.org>
Date: Sat, 10 Jan 2015 09:38:04 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bart Tanghe <bart.tanghe@thomasmore.be>, lee@kernel.org,
        devicetree@vger.kernel.org
CC: thierry.reding@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]dts: add bcm2835-pwm bindings
References: <1420471983-29945-1-git-send-email-bart.tanghe@thomasmore.be>
In-Reply-To: <1420471983-29945-1-git-send-email-bart.tanghe@thomasmore.be>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 08:33 AM, Bart Tanghe wrote:
> To probe the bcm2835-pwm driver properly, this dts bindings has to be added 
> to the bcm2835 dtsi file.
> In expectation of a bcm2835 clock driver, I've added fixed-clock clock binding.
> To change the status of the gpio pins into pwm output pins, some additional 
> bindings has to be added but this has not to be done automatically.
> Is it possible to document this bindings somewhere?

The pinctrl bindings allow you to do this. They're documented in:

Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
Documentation/devicetree/bindings/pinctrl/brcm,bcm2835-gpio.txt

pinctrl setup would typically be added to the board file (i.e.
arch/arm/boot/dts/bcm2835-rpi-b.dts) rather than the SoC file. I think
on the RPi, the pins that can generate PWM aren't dedicated to PWM by
the RPi board design (they could be GPIOs and probably other functions
too) so we probably need to leave it up to individual users to add PWM
configuration to their DT, if/when they use the PWM feature.
