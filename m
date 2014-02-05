Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbaBEO5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:57:24 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:60766 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbaBEO5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:57:22 -0500
Message-ID: <52F25122.50400@ti.com>
Date: Wed, 5 Feb 2014 08:56:34 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matt Porter <mporter@linaro.org>
CC: Jack Mitchell <ml@embed.me.uk>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Jack Mitchell <jack@embed.me.uk>
Subject: Re: [PATCH RESEND] ARM: dts: add BeagleBone Audio Cape (Rev A) dtsi
References: <1391608084-12665-1-git-send-email-ml@embed.me.uk> <52F2460C.3080908@ti.com> <20140205143800.GB22153@beef>
In-Reply-To: <20140205143800.GB22153@beef>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 08:38 AM, Matt Porter wrote:
> On Wed, Feb 05, 2014 at 08:09:16AM -0600, Nishanth Menon wrote:
>> On 02/05/2014 07:48 AM, Jack Mitchell wrote:
[...]
>>> + * --- a/arch/arm/boot/dts/am335x-boneblack.dts
>>> + * +++ b/arch/arm/boot/dts/am335x-boneblack.dts
>>> + * @@ -73,6 +74,6 @@
>>> + *  		pinctrl-names = "default", "off";
>>> + *  		pinctrl-0 = <&nxp_hdmi_bonelt_pins>;
>>> + *  		pinctrl-1 = <&nxp_hdmi_bonelt_off_pins>;
>>> + * -		status = "okay";
>>> + * +		status = "disabled";
>>> + *  	};
>>> + *  };
>>> + */
>>> +
>> how about making the audio-cape-reva.dts which includes and overrides
>> parameters of boneblack.dts?
> 
> Yeah, that might be a little cleaner. Black makes things unfortunately
> messy for these capes that were really intended for BBW :(

yes indeed - we might have to live with more dts in such a case.
> 
>> Further, I see a bunch of capes in
>> http://elinux.org/Beagleboard:BeagleBone_Capes
>>
>> Assuming that we dont want to discuss capebus all over again, is this
>> the approach we'd like to consider in the interim?
> 
> I think that's a fair assumption...I'll note that there is work slowly
> in progress on a very minimal implementation DT overlays upstream. But
> that doesn't exist. We are simply interested in a sane way to use the
> hardware we own in mainline and this approach makes it possible to build
> a kernel+dtb from mainline that works for this configuration. If
> there's a better way to support this hardware *today* let's discuss it.
> One of the big benefits to having this upstream is that it's no longer
> out of sight out of mind. It should be managed alongside all the other
> am335x dts data.
> 
> Incidentally, I'm hoping to contribute a similar patch for the DVI cape
> I have here.

If I am not mistaken, the capes are stackable (within reason), and are
not exactly hotpluggable.. question pops up as to how do we handle
multiple cape descriptions on the same board without having the user
to create custom dts which includes each relevant cape dts he has on
his/her bone? I wonder(without proper research, just thinking aloud)
if u-boot can do some sort of merge of dtbs - assuming ofcourse eeprom
data is used to detect the capes plugged on board?

-- 
Regards,
Nishanth Menon
