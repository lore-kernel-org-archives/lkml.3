Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaKXM6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:58:54 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:56019 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbaKXM6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:58:51 -0500
MIME-Version: 1.0
In-Reply-To: <20141124113518.GC6875@localhost>
References: <1415885699-1465-1-git-send-email-user@radxa>
	<1415885699-1465-2-git-send-email-user@radxa>
	<20141121105951.GA20679@localhost>
	<20141124102456.GE4241@x1>
	<20141124113518.GC6875@localhost>
Date: Mon, 24 Nov 2014 13:58:50 +0100
Message-ID: <CABgxDoLA=QL6vzU-v1w4vMZ3qhorjRdYOWFFMrjJE6xvZ7QO3g@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] of: Rename "poweroff-source" property to "system-power-controller"
From: Romain Perier <romain.perier@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Grant Likely <grant.likely@linaro.org>, robh <robh@kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
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

2014-11-24 12:35 GMT+01:00 Johan Hovold <johan@kernel.org>:
> On Mon, Nov 24, 2014 at 10:24:56AM +0000, Lee Jones wrote:
>> On Fri, 21 Nov 2014, Johan Hovold wrote:
>> > On Thu, Nov 13, 2014 at 01:34:58PM +0000, Auto Configured wrote:
>> > > From: Romain Perier <romain.perier@gmail.com>
>> > >
>> > > It reverts commit a4b4e0461ec5 ("of: Add standard property for poweroff capability").
>> > > As discussed on the mailing list, it makes more sense to rename back to the
>> > > old established property name, without the vendor prefix. Problem being that
>> > > the word "source" usually tends to be used for inputs and that is out of control
>> > > of the OS. The poweroff capability is an output which simply turns the
>> > > system-power off. Also, this property might be used by drivers which power-off
>> > > the system and power back on subsequent RTC alarms. This seems to suggest to
>> > > remove "poweroff" from the property name and to choose "system-power-controller"
>> > > as the more generic name. This patchs adds the required renaming changes and
>> > > defines an helper function which is compatible with both properties, the old one
>> > > which was only used by tps65910 and the new one without vendor-prefix.
>> >
>> > Now this is a bit of a mess.
>> >
>> > There's a commit in the mfd tree, 25f833c1171d ("mfd: tps65910: Convert
>> > ti,system-power-controller DT property to poweroff-source"), which
>> > breaks all dts using tps65910 since these are never updated to the now
>> > retracted property name ("poweroff-source").
>>
>> My word!
>>
>> Romain, what conversation on the MLs are you talking about?
>
> I think Romain is referring to this thread:
>
>         https://lkml.org/lkml/2014/10/23/161

Yes, this is this one.

>
>> > This one should simply be reverted ASAP.
>>
>> No need to revert, I can just remove the patch from the MFD tree.
>
> Ok, good. Then this is limited to the regulator tree, and we could
> proceed as I outlined below.
>
>
> Romain, care to resend this patch without the tps65910 chunks?

If you can just drop the patch from mfd tree Lee, please do.
Yes Johan, np, what I want is that we find a smart solution, nothing more.

>
> You should also fix the commit message, which claims to define a "helper
> function which is compatible with both properties", something which was
> no longer the case.
>
> Thanks,
> Johan

So I need to resend this patch which would only introduce an helper
function which checks for "system-power-controller" property (it would
also have a new commit message).
As you suggested, this helper might be named
"of_device_is_system_power_controller" ?

Everything is okay ?

Romain
