Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab3JQOxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:53:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56323 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3JQOxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:53:51 -0400
Message-ID: <1382021369.4093.44.camel@weser.hi.pengutronix.de>
Subject: Re: [PATCH v5 1/4] i2c: busses: i2c-st: Add ST I2C controller
From: Lucas Stach <l.stach@pengutronix.de>
To: srinivas kandagatla <srinivas.kandagatla@st.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen GALLIMORE <stephen.gallimore@st.com>,
        Stuart MENEFY <stuart.menefy@st.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Maxime COQUELIN <maxime.coquelin@st.com>
Date: Thu, 17 Oct 2013 16:49:29 +0200
In-Reply-To: <525FF498.3060202@st.com>
References: <1381754813-4679-1-git-send-email-maxime.coquelin@st.com>
	 <1381754813-4679-2-git-send-email-maxime.coquelin@st.com>
	 <20131016151419.GA14104@ns203013.ovh.net> <525F915D.9020501@st.com>
	 <525FAEED.7030207@st.com> <20131017141957.GE14104@ns203013.ovh.net>
	 <525FF498.3060202@st.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:fa0f:41ff:fe58:4010
X-SA-Exim-Mail-From: l.stach@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 17.10.2013, 15:30 +0100 schrieb srinivas kandagatla:
[...]
> Sorry to ask this but, Where is this requirement coming from?
> I have not spotted any thing as such in ePAPR specs.
> 
> 
> All the spec says is.
> ===
> The compatible property value consists of one or more strings that
> define the specific programming model for the device. This list of
> strings should be used by a client program for device driver selection.
> The property value consists of a concatenated list of null terminated
> strings, *from most specific to most general.* They allow a device to
> express its compatibility with a family of similar devices, potentially
> allowing a single device driver to match against several devices.
> The recommended format is “manufacturer,model”, where manufacturer is a
> string describing the name of the manufacturer (such as an OUI), and
> model specifies the model number.
> 
> Example:
> compatible = “fsl,mpc8641-uart”, “ns16550";
> In this example, an operating system would first try to locate a device
> driver that supported fsl,mpc8641-uart. If a driver was not found, it
> would then try to locate a driver that supported the more general
> ns16550 device type.
> ===
> 
> The more general compatible string in this case is "st,comms-ssc-i2c",
> rather than the first soc name.
> How can a first SOC name be more general?
> 
> As this driver is not very specific to StiH415, it is generic driver for
> ST comms-ssc-i2c block.
> 

You just can't know if someone in the future decides to subtly change
the register layout or make some other incompatible change to the
comms-ssc-i2c block.

So as a general rule of thumb you take the first SoC where a particular
IP block appeared as the compatible string, so you can just pick the
name of the SoC where the incompatible change was made as the next
string and not need to invent generic and unspecific comms-ssc-i2c-v2
compatibles.

Regards,
Lucas
-- 
Pengutronix e.K.                           | Lucas Stach                 |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-5076 |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

