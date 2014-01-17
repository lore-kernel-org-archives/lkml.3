Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaAQHmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 02:42:07 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:40161 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaAQHmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 02:42:04 -0500
Message-ID: <1389944445.2794.48.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH v2 1/2] i2c: qup: Add device tree bindings information
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Bill Brown <bill.e.brown@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Jean Delvare <khali@linux-fr.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        James Ralston <james.d.ralston@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 17 Jan 2014 09:40:45 +0200
In-Reply-To: <20140116232047.GK30911@sonymobile.com>
References: <1389659437-16406-1-git-send-email-bjorn.andersson@sonymobile.com>
	 <1389659437-16406-2-git-send-email-bjorn.andersson@sonymobile.com>
	 <1389689841.2794.8.camel@iivanov-dev.int.mm-sol.com>
	 <20140116232047.GK30911@sonymobile.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Thu, 2014-01-16 at 15:20 -0800, Bjorn Andersson wrote: 
> On Tue 14 Jan 00:57 PST 2014, Ivan T. Ivanov wrote:
> 
> > 
> > Thanks Bjorn, 
> > 
> > I have prepared second version, but never send it out :-).
> > One thing suggested by Mark was missed in this version.
> 
> Yeah, Mattew told me you we're assigned to other things and asked me to send
> out an update as I had gotten it to work on our boards.
> 
> I did modify the wording of most of these to match how it is written in the
> other Qualcomm definitions.
> 
> @Mark, would you rather have me change this to your suggested wording?
> 
> > 
> > 
> > On Mon, 2014-01-13 at 16:30 -0800, Bjorn Andersson wrote: 
> > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > 
> [snip]
> > > + - clocks: Should contain the core clock and the AHB clock.
> > 
> > + - clocks: a list of phandle + clock-specifier pairs for each entry in
> > +           clock-names
> > 
> 
> This is in line with how it's written in other drivers, so if the DT
> maintainers doesn't disagree I would like to keep phandles out of the
> description. This specific line is a verbatime copy of the msm_serial
> documentation (same block, different mode)...
> 
> > > + - clock-names: Should be "core" for the core clock and "iface" for the
> > > +                AHB clock.
> > > +
> > > + - #address-cells: Should be <1> Address cells for i2c device address
> > > + - #size-cells: Should be <0> as i2c addresses have no size component
> > > +
> > > +Optional properties:
> > > + - clock-frequency: Should specify the desired i2c bus clock frequency in Hz,
> > > +                    default is 100kHz if omitted.
> > > +
> > > +Child nodes should conform to i2c bus binding.
> > > +
> > > +Example:
> > > +
> > > + i2c2: i2c@f9924000 {
> > > + 	compatible = "qcom,i2c-qup";
> > > + 	reg = <0xf9924000 0x1000>;
> > > + 	interrupts = <0 96 0>;
> > > +
> > > + 	clocks = <&gcc_blsp1_qup2_i2c_apps_clk>, <&gcc_blsp1_ahb_clk>;
> > 
> > In the light of the latest patches from Stephen, this could be 
> > 
> > + 	clocks = <&gcc GCC_BLSP1_QUP2_I2C_APPS_CLK>, <&gcc GCC_BLSP1_AHB_CLK>;
> 
> Yes, that's exactly what I have in my dts. However as this is just an example
> I didn't feel it was worth tainting the documentation with all those capital
> letters ;)
> So unless DT maintainers disagree I would like to just keep it as an example.

Until, we get some meaningful board DTS files for Qualcomm platforms, it
is easy for people which will like to test or use drivers to just copy
and paste these definitions.

Regards,
Ivan

> 
> Regards,
> Bjorn
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


