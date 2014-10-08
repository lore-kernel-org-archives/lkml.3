Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbaJHUOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:14:41 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:43340 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaJHUOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:14:40 -0400
Date: Wed, 8 Oct 2014 13:12:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: atull <atull@opensource.altera.com>
Cc: jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v5 1/4] hwmon: ltc2978: device tree bindings documentation
Message-ID: <20141008201254.GA21065@roeck-us.net>
References: <1412275071-6417-1-git-send-email-atull@opensource.altera.com>
 <1412275071-6417-2-git-send-email-atull@opensource.altera.com>
 <20141006172845.GA21902@roeck-us.net>
 <alpine.DEB.2.02.1410081103110.18439@atx-linux-37>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1410081103110.18439@atx-linux-37>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.54359B2F.0148,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 12
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 11:12:29AM -0500, atull wrote:
> On Mon, 6 Oct 2014, Guenter Roeck wrote:
> 
> > On Thu, Oct 02, 2014 at 01:37:48PM -0500, atull@opensource.altera.com wrote:
> > > From: Alan Tull <atull@opensource.altera.com>
> > > 
> > > Add device tree bindings documentation for ltc2978.
> > > 
> > > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > > ---
> > > v2: clean whitespace
> > > ---
> > >  .../devicetree/bindings/hwmon/ltc2978.txt          |   41 ++++++++++++++++++++
> > >  1 file changed, 41 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/hwmon/ltc2978.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/hwmon/ltc2978.txt b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
> > > new file mode 100644
> > > index 0000000..b2d9c4d
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/hwmon/ltc2978.txt
> > > @@ -0,0 +1,41 @@
> > > +ltc2978
> > > +
> > > +Required properties:
> > > + - compatible: one of: ltc2974, ltc2977, ltc2978, ltc3880, ltc3883, ltm4676
> > > + - reg: I2C address
> > > +
> > > +Optional properties:
> > > + Name of the optional regulator subnode must be "regulators".
> > 
> > This is currently a problem. The regulator core trats it as mandatory,
> > meaning I get error messages such as
> > 
> > ltc2978 5-005e: Failed to find regulator container node
> > 
> > if not specified. We'll have to sort out with the regulator core how this should
> > be handled.
> > 
Followup on this: Since the regulator core considers the property to be
mandatory (which I guess makes some sense for a presumed regulator),
you'll have to check in the calling code and ensure that a 'regulators'
entry is there prior to calling the regulator code.

> > > +  - #address-cells must be 1.
> > > +  - #size-cells must be 0.
> > > +
> > 
> > Checking this out, those do not seem to be necessary.
> 
> I just tried it, and don't see a need for it myself.
> 	 
> > 
> > > + For each regulator:
> > > +  - reg: regulator number
> > 
> > This does not seem to be necessary either.
> 
> Same here.  For some reason I thought they were required.  
> I'll take them out of the bindings doc.
> 
> > 
> > > +  - regulator-compatible: must be vout_en<regulator number> such as vout_en3
> > > +    valid range is:
> > > +      ltc2977, ltc2978 : vout_en0 - vout_en7
> > > +      ltc2974          : vout_en0 - vout_en3
> > > +      ltc3880, ltm4676 : vout_en0 - vout_en1
> > > +      ltc3883          : vout_en0 only
> > 
> > Besides the unnecessary _en,
> 
> I don't mind taking out the '_en'.  I was trying to name these
> after pin names on the device.  I thought that was the norm.
> If someone adds voltage support later, that will look even
> weirder, so I agree that should change.
> 
> > this is a problem if there is more than one
> > supported chip in the system, if DEBUG_FS is enabled, and if names are not
> > specified in the devicetree file. I get a lot of error messages in a
> > system with a large number of LTC2978 chips.
> > 
> > vout3: Failed to create debugfs directory
> > vout4: Failed to create debugfs directory
> > vout5: Failed to create debugfs directory
> > vout6: Failed to create debugfs directory
> > vout7: Failed to create debugfs directory
> > vout2: Failed to create debugfs directory
> > vout3: Failed to create debugfs directory
> > 
> > and so on (40+ times in my system). We will have to find a solution for this
> > problem.
> 
> Note that whatever name is here is going to be the compatible
> string for this particular regulator output in the DT.
> 
Yes, but I don't want to have to specify dummy names even for unused
regulator channels. There are lots of those in our systems (see below).

> It seems like this can't be the only case of this in the kernel.
> I imagine there are lots of boards with multiple regulators but
> no regulator info specified. I'll have to dig a bit to see why
> this isn't an issue for other regulator drivers.
> 
My wild guess is that it is quite atypical to have multiple regulators
of the same type in a system, so maybe it is as simple as no one hitting
the problem before.

Problem is that we can not add bus numbers and/or the device address
into the name either. Bus numbers can change across reboots, and
there can be multiple chips with the same i2c address on different
busses.

Example:

ltc2978-i2c-2-5c
ltc2978-i2c-5-5d
ltc2978-i2c-5-5e
ltc2978-i2c-5-5f
ltc2978-i2c-5-60
ltc2978-i2c-5-61
ltc2978-i2c-5-62
ltc2978-i2c-11-5c
ltc2978-i2c-12-5c

>From another system:

ltc2978-i2c-37-5d
ltc2978-i2c-37-5e
ltc2978-i2c-37-5f
ltc2978-i2c-37-60
ltc2978-i2c-37-61
ltc2978-i2c-37-62
ltc2978-i2c-45-5d
ltc2978-i2c-45-5e
ltc2978-i2c-45-5f
ltc2978-i2c-45-60
ltc2978-i2c-45-61
ltc2978-i2c-45-62
ltc2978-i2c-53-5d
ltc2978-i2c-53-5f
ltc2978-i2c-53-60
ltc2978-i2c-53-61
ltc2978-i2c-53-62
ltc2978-i2c-61-5d
ltc2978-i2c-61-5e
ltc2978-i2c-69-5d
ltc2978-i2c-69-5e
ltc2978-i2c-21-5c
ltc2978-i2c-22-5c

Yes, that may be a bit excessive, but it is from real systems.

> > 
> > I also get
> > 
> > vout7: no parameters
> > 
> > for each regulator which is a bit annoying with 50+ of those regulators
> > in the system.
> 
> Yes I see that and tried to make it stop (but couldn't).  It is not
> really helpful information.
> 
I think this will have to be fixed in the infrastructure. The message
should probably be a debug message.

Thanks,
Guenter
