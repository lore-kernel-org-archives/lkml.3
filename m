Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbbAMPqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:46:22 -0500
Received: from rhcavspool01.kulnet.kuleuven.be ([134.58.240.193]:36544 "EHLO
	cavspool01.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752208AbbAMPqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:46:20 -0500
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 10:46:20 EST
X-KULeuven-Envelope-From: bart.tanghe@thomasmore.be
X-KULeuven-Scanned: Found to be clean
X-KULeuven-ID: E09CA12833B.A5355
X-KULeuven-Information: Katholieke Universiteit Leuven
Message-ID: <54B53C86.4030903@thomasmore.be>
Date: Tue, 13 Jan 2015 16:40:54 +0100
X-Kuleuven: This mail passed the K.U.Leuven mailcluster
From: Bart Tanghe <bart.tanghe@thomasmore.be>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, lee@kernel.org,
        devicetree@vger.kernel.org
CC: thierry.reding@gmail.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]dts: add bcm2835-pwm bindings
References: <1420471983-29945-1-git-send-email-bart.tanghe@thomasmore.be> <54B1556C.7070401@wwwdotorg.org>
In-Reply-To: <54B1556C.7070401@wwwdotorg.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2015 05:38 PM, Stephen Warren wrote:
> On 01/05/2015 08:33 AM, Bart Tanghe wrote:
>> To probe the bcm2835-pwm driver properly, this dts bindings has to be added 
>> to the bcm2835 dtsi file.
>> In expectation of a bcm2835 clock driver, I've added fixed-clock clock binding.
>> To change the status of the gpio pins into pwm output pins, some additional 
>> bindings has to be added but this has not to be done automatically.
>> Is it possible to document this bindings somewhere?
> 
> The pinctrl bindings allow you to do this. They're documented in:
> 
> Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> Documentation/devicetree/bindings/pinctrl/brcm,bcm2835-gpio.txt
> 
> pinctrl setup would typically be added to the board file (i.e.
> arch/arm/boot/dts/bcm2835-rpi-b.dts) rather than the SoC file. I think
> on the RPi, the pins that can generate PWM aren't dedicated to PWM by
> the RPi board design (they could be GPIOs and probably other functions
> too) so we probably need to leave it up to individual users to add PWM
> configuration to their DT, if/when they use the PWM feature.
> 

Indeed, the pins aren't dedicated to pwm and can be used for other functions.
Is it usefull to add  the pwm pinctrl description to 
Documentation/devicetree/bindings/pinctrl/brcm,bcm2835-gpio.txt or is this 
useless? 

Regards,

Bart
