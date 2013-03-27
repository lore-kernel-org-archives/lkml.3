Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab3C0J0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:26:24 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:55583 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992Ab3C0J0U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:26:20 -0400
Subject: Re: [PATCH 2/5] capemgr: Add beaglebone's cape driver bindings
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20130326173619.E6F483E2585@localhost>
Date: Wed, 27 Mar 2013 11:26:10 +0200
Cc: Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <EE83C8C3-5EB7-415A-840C-831F574E15BE@antoniou-consulting.com>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com> <1357584666-17374-3-git-send-email-panto@antoniou-consulting.com> <20130326173619.E6F483E2585@localhost>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant

On Mar 26, 2013, at 7:36 PM, Grant Likely wrote:

> On Mon,  7 Jan 2013 20:51:03 +0200, Pantelis Antoniou <panto@antoniou-consulting.com> wrote:
>> Document the beaglebone's cape driver bindings.
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> 
> Hi Pantelis,
> 
> I'll go back and review the driver in a minute, but I'll start here
> since this is the data model that we'll be using for a long time.
> Overall this looks pretty sane. It's pretty well contained too which I
> like. Long term I do want to try and create some common patterns for
> overlay connections, but it's really hard to do that when this is the
> first serious attempt at implementing one.  :-) This is nicely contained
> to only the beaglebone use case which makes it easy to try out without
> forcing this exact data model on all users. If it works in other places,
> then fantastic! we've got our generic model. If not, then we can refine
> the interface for new boards without breaking beaglebone.
> 

Glad you liked it. I really tried hard to keep things nicely separated since
we're definitely on to uncharted waters.

We will definitely adopt this for the beagleboard too (maybe some other boards too)
so some rearrangement will take place for the v2 of the patches.

We're under the gun for the new beaglebone that's coming out shortly, so the new patches
will be out in a couple of weeks.

> Comments below...
> 
>> ---
>> .../devicetree/bindings/misc/capes-beaglebone.txt  | 110 +++++++++++++++++++++
>> 1 file changed, 110 insertions(+)
>> create mode 100644 Documentation/devicetree/bindings/misc/capes-beaglebone.txt
>> 
>> diff --git a/Documentation/devicetree/bindings/misc/capes-beaglebone.txt b/Documentation/devicetree/bindings/misc/capes-beaglebone.txt
>> new file mode 100644
>> index 0000000..f73cab5
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/misc/capes-beaglebone.txt
>> @@ -0,0 +1,110 @@
>> +* TI Beaglebone DT Overlay Cape Driver
>> +
>> +Required properties:
>> +
>> +- compatible: "ti,bone-capemgr"
> 
> "capemgr" sounds like a software construct. Can you rename this to
> something that sounds more like describing concrete hardware? From that
> perspective, "ti,bone-capebus" would be appropriate here, regardless of
> where the driver actually lives in the kernel tree.
> 

Hum, well I guess so, that would work. Perhaps same as with 
ti,beagle-capebus.

But I thought using the work bus was out :)

> It would be better to be more specific here with the compatible
> property also. Put the actual board name into the compatible string.
> Following the lead of the board level compatible property, call it
> 'ti,am335x-bone-capebus". Newer boards can claim compatibilty with the
> older where appropriate.
> 

Let's not put am335x there, there's nothing SoC specific. The bone is
a am335x, but the beagleboard is not, etc.

There's also some crazy talk about compatibility between different board
families; we can keep it aside for now, but let's not assign anything
SoC specific. 

>> +
>> +- eeprom: Contains the phandle beaglebone's baseboard i2c eeprom.
>> +
>> +- baseboardmaps - node containing a list of supported
>> +	beaglebone revisions; each node in should have the
>> +	following properties:
>> +	- board-name: The board name stored in the baseboard
>> +		eeprom.
> 
> If it is stored in the baseboard eeprom, then why does it need to appear
> in the .dtb?

It needs to because there are slightly different revisions of the bone.
Defining the revisions it allows us to auto-load the dtbos containing the
differences for the baseboard revision.

In this way we keep the same kernel/software images working on all the
bone revisions, significantly reducing the support burden.

> 
>> +	- compatible-name: The name which will be used for
>> +		matching compatible capes.
> 
> What is the matching logic for this compatible capes? How does it get
> used?
> 

See below.

>> +
>> +- slots: node containing a list of slot nodes (which in the beaglebone
>> +	case correspond to I2C addresses for dynamically probed capes,
>> +	or an override slot definition for hardcoded capes.
>> +	- eeprom: Contains the phandle beaglebone's cape i2c eeprom.
>> +
>> +	It is possible to define override slots that will be activated
>> +	when the baseboard matches, and/or if supplied on the kernel command
>> +	line and/or when dynamically requested on runtime.
>> +	In that case the slot is marked with
>> +	- ti,cape-override: Marks a slot override.
>> +	- compatible: any of the "runtime", "kernel", or any compatible-name
>> +	  on a matching baseboardmap node.
>> +	- Any of the eeprom-format-revision, board-name, version, manufacturer,
>> +	  part-number, number-of-pins, serial-number, pin-usage, vdd-3v3exp,
>> +	  vdd-5v, sys-5v, dc-supplied properties which fill in the simulated
>> +	  cape's EEPROM fields. The part-number field is required, the rest
>> +	  are optional taking into default values.
> 
> I could use some help understanding the use-case for the override slots.
> It isn't clear to me how the override is intended to work. Can you
> describe exactly what happens when an override slot is defined? Do
> override slots replace detected slots, or are they separate?
> 

Override slots are slots that are not probed via the eeprom,
but instead are loaded as a result of

1) User configuration
2) Base board match

In essence, overrides are when the normal probing method isn't applicable.

To understand why there's needed let's take two examples, one is the
development version of the Geiger cape.

That version did not have an EEPROM (mainly because it's a wired up board
with no SMD components).

It's override definition is:

>  /* geiger cape version A0 without an EEPROM */
>  slot@5 {
>  	ti,cape-override;
>  	compatible = "kernel-command-line", "runtime";
>  	board-name = "Bone-Geiger";
>  	version = "00A0";
>  	manufacturer = "Geiger Inc.";
>  	part-number = "BB-BONE-GEIGER";
>  };


The compatible property declares this to be an override which is enabled
either from the command line or at runtime.

To load this cape, you can either use the sysfs/slots property or add a kernel
parameter of the form capemgr.extra_override=BB-BONE-GEIGER:00A0

There's also a new 'force' compatible option in the updated patchset which always
applies the override (but that's mostly for development purposes).

Let's take a look at new beaglebone that's coming out shortly.

One of the differences it has from the original is that of onboard HDMI.

It's override definition is:

> 
>  /* Beaglebone black has it soldered on */
>  slot@6 {
>   	ti,cape-override;
>   	compatible = "ti,beaglebone-black";
>  	board-name = "Bone-Black-HDMI";
>  	version = "00A0";
>  	manufacturer = "Texas Instruments";
>  	part-number = "BB-BONELT-HDMI";
>  };
> 



It's compatible property is "ti,beaglebone-black"

This means that this is an override that should be applied for the new beaglebone.

Taking a look at the baseboardmaps node we see that there's board node that maps
the internal board-name (A335BNLT) to the well formed DT name ti,beaglebone-black.

And that's the reason of the baeboardsmaps nodes, mapping from some internal
representation of board revision to a single well formed DT compatible property.

>> +
>> +- capemaps: node contains list of cape mappings, which allow converting
>> +	from a part-number & version tuple to the filename of the dtbo file.
>> +	- part-number: part number contained in the EEPROM
>> +	- version node containing a
>> +		- version: specific version to map to
>> +		- dtbo: name of the dtbo file 
> 
> I think you'd be better off here defining a direct 1:1 mapping from
> board name + revision to dtb filename. Maintaining a list of mappings in
> the dtb file means it needs to be updated when new capes are created. It
> would be nicer to drop the new overlay in the root filesystem (or initrd
> if that is more convenient) and have the kernel know when to pick it up.
> 

I'm ambivalent about this. There is a direct 1:1 mapping, using directly the
part number works just as well, but knowing the hardware people, I'm not sure
I can trust them not to use part number that are not filename friendly.
I.e. they might sneak a '/' in there and we'll be SOL.

You can think of the capemaps node as an optional filename sanitizer, it's
not required, but guarantees that we're not dependent on sane part-number fields.

>> +
>> +Example:
>> +bone_capemgr {
>> +	compatible = "ti,bone-capemgr";
>> +	status = "okay";
>> +
>> +	eeprom = <&baseboard_eeprom>;
>> +
>> +	baseboardmaps {
>> +		baseboard_beaglebone: board@0 {
>> +			board-name = "A335BONE";
>> +			compatible-name = "ti,beaglebone";
>> +		};
>> +	};
>> +
>> +	slots {
>> +		slot@0 {
>> +			eeprom = <&cape_eeprom0>;
>> +		};
>> +
>> +		slot@1 {
>> +			eeprom = <&cape_eeprom1>;
>> +		};
>> +
>> +		slot@2 {
>> +			eeprom = <&cape_eeprom2>;
>> +		};
>> +
>> +		slot@3 {
>> +			eeprom = <&cape_eeprom3>;
>> +		};
>> +	};
>> +
>> +	/* mapping between board names and dtb objects */
>> +	capemaps {
>> +		/* Weather cape */
>> +		cape@0 {
>> +			part-number = "BB-BONE-WTHR-01";
>> +			version@00A0 {
>> +				version = "00A0";
>> +				dtbo = "cape-bone-weather-00A0.dtbo";
>> +			};
>> +		};
>> +	};
>> +};
>> +
>> +Example of the override syntax when used on a bone compatible foo board.
>> +
>> +{
>> +	...
>> +
>> +	baseboardmaps {
>> +		...
>> +		baseboard_beaglebone: board@0 {
>> +			board-name = "A335FOO";
>> +			compatible-name = "ti,foo";
>> +		};
>> +
>> +		slot@6 {
>> +			ti,cape-override;
>> +			compatible = "ti,foo";
>> +			board-name = "FOO-hardcoded";
>> +			version = "00A0";
>> +			manufacturer = "Texas Instruments";
>> +			part-number = "BB-BONE-FOO-01";
>> +		};
>> +	};
>> +
>> +};
>> +	
>> -- 
>> 1.7.12
>> 
> 
> -- 
> Grant Likely, B.Sc, P.Eng.
> Secret Lab Technologies, Ltd.

Regards

-- Pantelis

