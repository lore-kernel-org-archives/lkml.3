Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaJIIC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:02:57 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:33791 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaJIICp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:02:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140926133920.GG7422@leverpostej>
References: <1394052739-8589-1-git-send-email-marek@goldelico.com>
	<1394052739-8589-4-git-send-email-marek@goldelico.com>
	<20140922110320.GI3290@leverpostej>
	<CAAfyv352GrgTzKf-XxPNthtoR9rdhssnOSdx1mZ-q=D4okBSAA@mail.gmail.com>
	<20140926133920.GG7422@leverpostej>
Date: Thu, 9 Oct 2014 10:02:43 +0200
Message-ID: <CAAfyv35EdDo5=9HPctzmovH4CQoaGoKmJDgZLUKz1ZVzEsS2Lw@mail.gmail.com>
Subject: Re: [PATCH v2] Documentation: DT: Document twl4030-madc-battery bindings.
From: Belisko Marek <marek.belisko@gmail.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "dbaryshkov@gmail.com" <dbaryshkov@gmail.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "hns@goldelico.com" <hns@goldelico.com>,
        "sre@debian.org" <sre@debian.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Sep 26, 2014 at 3:39 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Mon, Sep 22, 2014 at 09:35:03PM +0100, Belisko Marek wrote:
>> Hi Mark,
>>
>> On Mon, Sep 22, 2014 at 1:03 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>> > Hi,
>> >
>> > On Wed, Mar 05, 2014 at 08:52:19PM +0000, Marek Belisko wrote:
>> >> Signed-off-by: Marek Belisko <marek@goldelico.com>
>> >> ---
>> >>  .../bindings/power_supply/twl4030_madc_battery.txt | 43 ++++++++++++++++++++++
>> >>  1 file changed, 43 insertions(+)
>> >>  create mode 100644 Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
>> >>
>> >> diff --git a/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt b/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
>> >> new file mode 100644
>> >> index 0000000..fd0b6d2
>> >> --- /dev/null
>> >> +++ b/Documentation/devicetree/bindings/power_supply/twl4030_madc_battery.txt
>> >> @@ -0,0 +1,43 @@
>> >> +twl4030_madc_battery
>> >> +
>> >> +Required properties:
>> >> + - compatible : "ti,twl4030-madc-battery"
>> >
>> > I'm rather confused by this; the code seems to have stripped away all
>> > the twl4030 dependencies and this now seems to be a generic ADC battery
>> > status driver. So why does this need to be specific to twl4030?
>> You are right. Also possibly driver name is incorrect :). Better name could be
>> ti, madc-battery.
>
> Ok.
>
>> >
>> >> + - capacity : battery capacity in uAh
>> >
>> > I would make the units explicit in the name; "capacity" can be measured
>> > in many ways.
>> OK capacity_uAh should be fine I believe.
>
> Well, "capacity-uah" to match naming conventions.
OK.
>
>> >
>> >> + - charging-calibration-data : list of voltage(mV):level(%) values
>> >> +     for charging calibration (see example)
>> >> + - discharging-calibration-data : list of voltage(mV):level(%) values
>> >> +     for discharging calibration (see example)
>> >
>> > Regardless of the prefixing of these property names, the specifics are
>> > unclear to me.
>> Do you suggest to rename it completely or is enough to add "ti, " prefix?
>
> I'm not suggesting prefixing. I'm suggesting that "calibration data"
> could mean a variety of things, so having a more specific name would be
> beneficial.
Charging and discharging data are used for some kind of interpolation
within voltage interval.
So we get volume from ADC and then convert it according
charging/discharging table to some value
which is then useded in various battery properties (status,
charge_now, capacity, time_to_empty_now).
So maybe battery-charging/discharging-calibration-data could be property name?

>
>> > Does this apply to vbat?
>> Yes bat is read and then interpolation algorithm is applied for
>> various power properties.
>> So mapping from voltage to percentage is defined in table.
>> >
>> > Is vbat guaranteed to read in mV?
>> Yes.
>> >
>> > Is any particular order required? The example seems to go be in
>> > descending percentage values.
>> There is done sorting in driver so ordering it's not necessary.
>> >
>> > Is any particular interpolation expected on behalf of the OS, or is this
>> > just an informative set of measurements that hte OS can use as it sees
>> > fit?
>> >
>> >> + - io-channels: Should contain IIO channel specifiers
>> >> +     for each element in io-channel-names.
>> >> +- io-channel-names: Should contain the following values:
>> All 3 statements was copied from rx51-battery and documentation is the same.
>> There is not unit for all channels just raw values which are then
>> converted in driver.
>
> I don't understand. How do you figure out the mapping of those raw
> values to sensible units? Surely you need additional information to do
> so?
Yes mapping from raw values is done in driver. Like current read from
iio channel_ichg
is multiplied by 1000 or read from channel_temp is multiplied by 10 to
have proper values for
battery properties.
>
> Mark.

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
