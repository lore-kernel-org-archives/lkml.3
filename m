Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbaKEQTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:19:33 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:39392 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaKEQTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:19:32 -0500
MIME-Version: 1.0
In-Reply-To: <20141105100827.GP31358@localhost>
References: <1414568135-8311-1-git-send-email-romain.perier@gmail.com>
	<1414568135-8311-2-git-send-email-romain.perier@gmail.com>
	<20141105100827.GP31358@localhost>
Date: Wed, 5 Nov 2014 17:19:30 +0100
Message-ID: <CABgxDoJ4CCjvtFxPFu+wBAWDNNJufsRqaDihMVdPkF1ckGZJwA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] of: Rename "poweroff-source" property to "system-power-controller"
From: Romain Perier <romain.perier@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-05 11:08 GMT+01:00 Johan Hovold <johan@kernel.org>:
> [ Resend with lkml, arm, Felipe on CC -- why were these dropped from CC? ]
>
> On Wed, Oct 29, 2014 at 07:35:32AM +0000, Romain Perier wrote:
>> As discussed on the mailing list, it makes more sense to rename this property
>> to "system-power-controller".
>
> Please also refer to the commit in the regulator tree renaming it to
> "poweroff-source", and that this in effect is a revert to the old name
> but without the vendor prefix.

Ok

>
>> Problem being that the word "source" usually tends
>> to be used for inputs and that is out of control of the OS. The poweroff
>> capability is an output which simply turns the system-power off. Also, this
>> property might be used by drivers which power-off the system and power back on
>> subsequent RTC alarms. This seems to suggest to remove "poweroff" from the
>> property name and to choose "system-power-controller" as the more generic name.
>> This patchs adds the required renaming changes and defines an helper function
>> which is compatible with both properties, the old one prefixed by a vendor name
>> and the new one without any prefix.
>>
>> Signed-off-by: Romain Perier <romain.perier@gmail.com>
>
> First of all, always run your patches through checkpatch.pl before
> submitting. There's a few warnings there for you to fix.

Ok, noted.

>
> I think this is the wrong approach. This way any driver will recognise
> the old deprecated vendor prefixes. But not only those -- also
> misspelled vendor prefixes.
>
> Keep it simple and only parse the new property name (inline in the
> header file).
>
> If we need to support the old property names with vendor prefix (we have
> dropped vendor prefixes in the past), then you could add a second helper
>
>         of_is_system_power_controller_compat(np, compat_propname)
>
> where you pass in the whole old property name (e.g.
> "ti,system-power-controller") and use that name as a fall back.
>
> This way it will be clear which drivers are still supporting the
> deprecated property names, and we can make sure that no new ones will.
>

I just want to be sure, do we need to keep backward compatibility or
not ? Previous series did not contain backward compatibility and it
was like "The Nursery Chainsaw Massacre" and created a lot of drama...
People's opinion are welcome.
