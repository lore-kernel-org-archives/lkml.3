Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaBEP3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 10:29:47 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:48522 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaBEP3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:29:45 -0500
Date: Wed, 5 Feb 2014 10:29:40 -0500
From: Matt Porter <mporter@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Jack Mitchell <ml@embed.me.uk>, bcousson@baylibre.com, tony@atomide.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Jack Mitchell <jack@embed.me.uk>
Subject: Re: [PATCH RESEND] ARM: dts: add BeagleBone Audio Cape (Rev A) dtsi
Message-ID: <20140205152940.GD22153@beef>
References: <1391608084-12665-1-git-send-email-ml@embed.me.uk>
 <52F2460C.3080908@ti.com>
 <20140205143800.GB22153@beef>
 <52F25122.50400@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F25122.50400@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 08:56:34AM -0600, Nishanth Menon wrote:
> On 02/05/2014 08:38 AM, Matt Porter wrote:
> > On Wed, Feb 05, 2014 at 08:09:16AM -0600, Nishanth Menon wrote:
> >> On 02/05/2014 07:48 AM, Jack Mitchell wrote:
> [...]
> >>> + * --- a/arch/arm/boot/dts/am335x-boneblack.dts
> >>> + * +++ b/arch/arm/boot/dts/am335x-boneblack.dts
> >>> + * @@ -73,6 +74,6 @@
> >>> + *  		pinctrl-names = "default", "off";
> >>> + *  		pinctrl-0 = <&nxp_hdmi_bonelt_pins>;
> >>> + *  		pinctrl-1 = <&nxp_hdmi_bonelt_off_pins>;
> >>> + * -		status = "okay";
> >>> + * +		status = "disabled";
> >>> + *  	};
> >>> + *  };
> >>> + */
> >>> +
> >> how about making the audio-cape-reva.dts which includes and overrides
> >> parameters of boneblack.dts?
> > 
> > Yeah, that might be a little cleaner. Black makes things unfortunately
> > messy for these capes that were really intended for BBW :(
> 
> yes indeed - we might have to live with more dts in such a case.
> > 
> >> Further, I see a bunch of capes in
> >> http://elinux.org/Beagleboard:BeagleBone_Capes
> >>
> >> Assuming that we dont want to discuss capebus all over again, is this
> >> the approach we'd like to consider in the interim?
> > 
> > I think that's a fair assumption...I'll note that there is work slowly
> > in progress on a very minimal implementation DT overlays upstream. But
> > that doesn't exist. We are simply interested in a sane way to use the
> > hardware we own in mainline and this approach makes it possible to build
> > a kernel+dtb from mainline that works for this configuration. If
> > there's a better way to support this hardware *today* let's discuss it.
> > One of the big benefits to having this upstream is that it's no longer
> > out of sight out of mind. It should be managed alongside all the other
> > am335x dts data.
> > 
> > Incidentally, I'm hoping to contribute a similar patch for the DVI cape
> > I have here.
> 
> If I am not mistaken, the capes are stackable (within reason), and are
> not exactly hotpluggable.. question pops up as to how do we handle
> multiple cape descriptions on the same board without having the user
> to create custom dts which includes each relevant cape dts he has on
> his/her bone? I wonder(without proper research, just thinking aloud)
> if u-boot can do some sort of merge of dtbs - assuming ofcourse eeprom
> data is used to detect the capes plugged on board?

Well covered in the original discussion. gcl summarizes options in
https://lkml.org/lkml/2012/11/5/615

Since then, the basic overlay support for the kernel is pretty much a
done deal. It has a wide variety of users (FPGA folks) beyond this board
specific case. The problem you describe about resource management and
conflicts would probably need to be built on top of that. Pantelis
had a PoC implementation with capebus/not-a-capebus but that's not part
of what is being upstreamed. I'm not sure if there's anybody with enough
time out of the Beagleboard community to upstream a resource manager on
top of the basic overlay support that's in progress. However, it might
make a nice GSoC2014 project. :)

-Matt
