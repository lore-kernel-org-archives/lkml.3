Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaCaIYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 04:24:06 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:41793 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaCaIYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 04:24:01 -0400
MIME-Version: 1.0
In-Reply-To: <20140213162249.GT28112@sirena.org.uk>
References: <1392059868-8782-1-git-send-email-arend@broadcom.com>
	<52FC8CB3.4090305@gmail.com>
	<52FCB571.4020904@broadcom.com>
	<52FCBC1D.7050501@samsung.com>
	<20140213162249.GT28112@sirena.org.uk>
Date: Mon, 31 Mar 2014 10:24:00 +0200
Message-ID: <CAPDyKFpU=nQAgfjMm6KNRAEKwChAx_SxFMC-pLbq8yis2mgB=Q@mail.gmail.com>
Subject: Re: [RFC] dt: bindings: add bindings for Broadcom bcm43xx sdio devices
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mark Brown <broonie@kernel.org>, Tomasz Figa <t.figa@samsung.com>
Cc: Arend van Spriel <arend@broadcom.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chen-Yu Tsai <wens@csie.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 February 2014 17:22, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Feb 13, 2014 at 01:35:41PM +0100, Tomasz Figa wrote:
>> On 13.02.2014 13:07, Arend van Spriel wrote:
>> >On 02/13/2014 10:13 AM, Tomasz Figa wrote:
>
>> >>The BCM43xx WLAN chips I used to work always have been controlled by a
>> >>simple power enable GPIO of the chip itself. Has this changed in newer
>> >>chips?
>
>> >>If you need to simply toggle a GPIO to control the power, you don't need
>> >>to use the regulator API at all, controlling the GPIO directly.
>
>> >Not sure I understand. Do you really mean 'chip' or 'wifi module' here.
>> >The chip needs to be powered and for that it is hooked up to a
>> >host/module provided GPIO (at least that is my understanding).
>
>> Your binding asks for a regulator, not a simple GPIO, which is all I
>> believe you need for BCM43xx power handling.
>
>> Mark (added to Cc), could we get your opinion on this?
>
> If it's a GPIO connected directly to the device it should be using
> gpiolib, the fact that it happens to have an effect on power rather than
> (say) just being a reset isn't terribly relevant to anything outside the
> driver.  If it's an external regulator that happens to be controlled
> using a GPIO on the current system then a regulator is better since
> another system might use a regulator with a different control interface.

>From an SDIO point of view, we need to find the corresponding OCR mask
the mmc host driver supports. The OCR mask gives the voltage levels
the host supports and it's being used during SDIO initialization while
negotiating the voltage level with the SDIO card.

Using a gpio regulator would simplify here, since the driver don't
need specific "SDIO hacks" but can use the mmc_regulator_get_supply()
API, which calculates the OCR mask, based upon the regulator's
supported voltages.

Kind regards
Ulf Hansson
