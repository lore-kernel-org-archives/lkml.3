Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618AbaJGMhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:37:07 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:64093 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaJGMhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:37:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAH6sp9O=Hb3uGk3=5Gc+bb+AAZVZu=xHqNnUBHPG8BJUn==ZzQ@mail.gmail.com>
References: <1411564278-17207-1-git-send-email-frans.klaver@xsens.com>
	<1411564278-17207-2-git-send-email-frans.klaver@xsens.com>
	<20140924131655.GG5729@leverpostej>
	<20140924142222.GC22872@ci00147.xsens-tech.local>
	<20140924143848.GH5729@leverpostej>
	<20140924151448.GD22872@ci00147.xsens-tech.local>
	<20140924153431.GJ5729@leverpostej>
	<20140924185933.GA2221@gmail.com>
	<20140925092715.GA3524@leverpostej>
	<CAH6sp9O=Hb3uGk3=5Gc+bb+AAZVZu=xHqNnUBHPG8BJUn==ZzQ@mail.gmail.com>
Date: Tue, 7 Oct 2014 14:37:03 +0200
Message-ID: <CAH6sp9O+EnmvSHtXBSKuHT-hQJx3xE1SQxb1kzdYs37Yv+71CA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] sbs-battery: add forced instantiation from device tree
From: Frans Klaver <fransklaver@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "olof@lixom.net" <olof@lixom.net>,
        "anton.vorontsov@linaro.org" <anton.vorontsov@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof, Anton,

Care to pitch in?

Thanks,
Frans

On Thu, Sep 25, 2014 at 11:32 AM, Frans Klaver <fransklaver@gmail.com> wrote:
> On Thu, Sep 25, 2014 at 11:27 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> On Wed, Sep 24, 2014 at 07:59:34PM +0100, Frans Klaver wrote:
>>> On Wed, Sep 24, 2014 at 04:34:32PM +0100, Mark Rutland wrote:
>>> > On Wed, Sep 24, 2014 at 04:14:48PM +0100, Frans Klaver wrote:
>>> > > On Wed, Sep 24, 2014 at 03:38:49PM +0100, Mark Rutland wrote:
>>> > > > On Wed, Sep 24, 2014 at 03:22:22PM +0100, Frans Klaver wrote:
>>> > > > You mention that there's a GPIO that can be used to detect the battery
>>> > > > presence. Why can't the driver always probe and then on check for the
>>> > > > presence of the battery dynamically using that GPIO? That should cover
>>> > > > both cases.
>>> > >
>>> > > I would say that this was the case before [1] was done. The GPIO is
>>> > > optional and if not configured, the presence or absence of the battery
>>> > > is detected by checking a status register much like probe() currently
>>> > > does. It seems all cases were covered before that patch. If you worry
>>> > > about speed, you should use the GPIO. I wonder if we might be able to
>>> > > revert [1] without doing much harm.
>>> >
>>> > But reverting that would re-introduce the lag on some systems, no? Given
>>> > the wording of the original commit I would guess that the GPIO wasn't
>>> > available. Perhaps Olof or Anton can enlighten us?
>>>
>>> It probably would yes. The battery_detect gpio was last touched in 2011, the
>>> probe check was added somewhere in 2012.
>>
>> We can't revert it unless we know doing so won't reintroduce the
>> problem. From the above it sounds like we can't revert it.
>>
>>> We could keep it as a compile option.
>>
>> Perhaps.
>>
>>> > In the cases where a GPIO is available, I think we should be able to be
>>> > less pessimistic. Is a GPIO available in your case?
>>>
>>> We don't have the battery_detect pin available. Incidentally, a bit of
>>> lag reading out the battery is not a problem for us.
>>
>> So now we're back at sqaure one. The hardware is likely identical in the
>> your case and the care-about-lag case. Whether or not you care about lag
>> is a property of the user rather than the HW, so I don't think that
>> belongs in the dt.
>>
>> It would be interesting to know what the lag was adversely affecting.
>> Perhaps there's another way around this.
>
> Exactly. I can imagine this really being a problem if the i2c bus
> already has a lot of priority traffic.
>
> Frans
