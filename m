Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaCNMil (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 08:38:41 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:44755 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaCNMij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 08:38:39 -0400
Message-ID: <5322F82A.9000507@ahsoftware.de>
Date: Fri, 14 Mar 2014 13:38:02 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v2] gpio: davinci: fix gpio selection for OF
References: <5316FFCE.1060603@ti.com>	<1394018461-757-1-git-send-email-holler@ahsoftware.de>	<CACRpkdaF=jc9Z1XZCtH8VPuih01t--qyV-sgH1R_ix0VM4RzVA@mail.gmail.com>	<5322D529.4070904@ahsoftware.de> <CACRpkdaghneo1MvNCfxjTED+sJepHgeZCgmKsRteG9qrBNWAfQ@mail.gmail.com>
In-Reply-To: <CACRpkdaghneo1MvNCfxjTED+sJepHgeZCgmKsRteG9qrBNWAfQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.03.2014 12:02, schrieb Linus Walleij:
> On Fri, Mar 14, 2014 at 11:08 AM, Alexander Holler <holler@ahsoftware.de> wrote:
>> Am 11.03.2014 11:15, schrieb Linus Walleij:
>>> On Wed, Mar 5, 2014 at 12:21 PM, Alexander Holler <holler@ahsoftware.de> wrote:
>>>
>>>> The driver missed an of_xlate function to translate gpio numbers
>>>> as found in the DT to the correct chip and number.
>>>>
>>>> While there I've set #gpio_cells to a fixed value of 2.
>>>>
>>>> I've used gpio-pxa.c as template for those changes and tested my changes
>>>> successfully on a da850 board using entries for gpio-leds in a DT. So I didn't
>>>> reinvent the wheel but just copied and tested stuff.
>>>>
>>>> Thanks to Grygorii Strashko for the hint to the existing code in gpio-pxa.
>>>>
>>>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>>
>>> This v2 version applied, thanks!
>>
>> Thanks, but actually that should have been a fix for 3.14 with which the
>> OF functionality for davinci gpio gets introduced. I assum with the
>> patch in for-next, 3.14 will appear with that functionality broken and
>> it will become a candidate for -stable.
>
> I just get the impression that DT support for DaVinci in v3.14 is so risky
> and unstable that noone except those implementing it (i.e. you) is really
> using it, is that correct?

Yes. DT support for DaVinci is still incomplete and I don't think there 
are much people out there which already try to use it. Nevertheless is 
using DT a much easier way (and more future-proof) than patching 
board-files, if a board isn't one of those few supported dev-boards and 
needs different configurations.

> In that case it is hardly a fix that we need to rush out to the entire world.

Hmm, I think it's better to send something working and tested to world, 
than something untested and non-working.

And especially things like pinctrl and gpio are fundamental to even try 
to use DT. E.g. in my case I didn't even try to use DT for DaVinci 
because it doesn't make sense without support for DT in gpio. And now 
people will get promised but broken support for gpio in 3.14, which 
might cost a lot of time, if someone tries to use it.

And I thought the reason for -rc is actually to fix bugs. But I never 
understood the magical ways and timings patches make their way into 
mainline. ;)

Regards,

Alexander Holler
