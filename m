Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab3KZVcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 16:32:17 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44888 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545Ab3KZVcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 16:32:14 -0500
MIME-Version: 1.0
In-Reply-To: <20131126094505.GC27752@ulmo.nvidia.com>
References: <1384800901-21711-1-git-send-email-tim.kryger@linaro.org>
	<1384800901-21711-3-git-send-email-tim.kryger@linaro.org>
	<20131125110854.GI22043@ulmo.nvidia.com>
	<CAAYSxhr7=Pa8RdnEsD2MGTR4hvfHCcHQCP77GRjx1Fqb-=kRrA@mail.gmail.com>
	<20131126094505.GC27752@ulmo.nvidia.com>
Date: Tue, 26 Nov 2013 13:32:13 -0800
Message-ID: <CAAYSxhqquF87NEJj8n3M7E8LWNgQGQdTqQmHPX9sdmvtBiSBTA@mail.gmail.com>
Subject: Re: [PATCH 2/5] pwm: kona: Introduce Kona PWM controller support
From: Tim Kryger <tim.kryger@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Christian Daudt <bcm@fixthebug.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback List 
	<bcm-kernel-feedback-list@broadcom.com>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linaro Patches List <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 1:45 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Nov 25, 2013 at 05:38:44PM -0800, Tim Kryger wrote:

> Okay, that's fine then. Do you have a pointer to that documentation?

Unfortunately the documentation is not publicly available at the moment.

>> The hardware is always enabled and at best can be be configured to
>> operate at zero duty.
>
> What good are the PWMOUT_ENABLE bits then? Is that really only used for
> triggering updates? That's what another comment suggests, but if so, can
> the comment in kona_pwmc_apply_settings() be extended to mention that?

The guidance from the documentation is to treat the enable bits as a trigger.

Sure I can expand the comment to try and make this more clear.

>> The settings in HW may have already been triggered and might not be
>> what you want.
>>
>> For example:
>>
>> /sys/class/pwm/pwmchip0/pwm1# echo 1 > enable
>> /sys/class/pwm/pwmchip0/pwm1# echo 5000 > period
>> /sys/class/pwm/pwmchip0/pwm1# echo 2000 > duty_cycle
>> /sys/class/pwm/pwmchip0/pwm1# echo 0 > enable
>> /sys/class/pwm/pwmchip0/pwm1# echo 1 > enable
>
> I'm not exactly sure what this is supposed to demonstrate.

The computation has to be performed for every operation except the disable.

> All of that said, I wasn't able to dig up a normative policy and either
> of your proposed alternatives do exist in the kernel, so I withdraw any
> objections regarding MODULE_AUTHOR. Take your pick.

Thanks
