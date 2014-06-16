Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbaFPQtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:49:32 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:37153 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaFPQt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:49:28 -0400
MIME-Version: 1.0
In-Reply-To: <539ED2C0.8030405@gmail.com>
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
	<1402464739-19044-4-git-send-email-tushar.b@samsung.com>
	<CAD=FV=XqqP7+xDOAKCixivzgaO0xvJX7L+CCN+unAEuf-6aUbQ@mail.gmail.com>
	<539ED2C0.8030405@gmail.com>
Date: Mon, 16 Jun 2014 09:49:26 -0700
Message-ID: <CAD=FV=UaaRQVq3TmXMTv9OkER+zORC89YfPNjwZwfCQKmuavrw@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: dts: Enable audio support for Peach-pi board
From: Doug Anderson <dianders@google.com>
To: Tushar Behera <trblinux@gmail.com>
Cc: Tushar Behera <tushar.b@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Kevin Hilman <khilman@linaro.org>, Mark Brown <broonie@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tushar,

On Mon, Jun 16, 2014 at 4:19 AM, Tushar Behera <trblinux@gmail.com> wrote:
> On 06/13/2014 10:33 PM, Doug Anderson wrote:
>> Tushar,
>>
>> On Tue, Jun 10, 2014 at 10:32 PM, Tushar Behera <tushar.b@samsung.com> wrote:
>>> Peach-pi board has MAX98090 audio codec connected on HSI2C-7 bus.
>>
>> If you want to be a stickler about it, peach-pi actually has a
>> max98091.  That requires code changes to the i2c driver, though.
>> ...and unfortunately listing two compatible strings for i2c devices is
>> broken.  :(
>>
> Hi Doug,
>
> You are right. I checked the boot logs, the detected codec type is
> MAX98091. Since both these CODECs are supported through a single driver
> and the detection of chip is done during runtime, I would suggest we go
> ahead with "max98090" compatible string. I will update the commit
> message accordingly.
>
> Does that sound okay to you?

As per my understanding you shouldn't do this.  You should have two patches:

1. Add "max98091".  You could simply post Wonjoon's patch from
<https://chromium-review.googlesource.com/184091>

2. Change the device tree to refer to "max98091"

The argument that the "current kernel driver has a single driver" is
an argument that you're not supposed to make for device tree.  The
same device tree is supposed to work for U-Boot, BSD, or any other
platform.  On those platforms it might not be a shared driver.


> If you so desire, I will submit a patch to sort peach-pi device-tree
> nodes (w.r.t. peach-pit dts file).

Yes please.  I think there's supposed to be some official ordering of
things.  If anyone reading this has a pointer to the official sort
order of things in the device tree I'd love to see it!  ;)

-Doug
