Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbaEIU2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:28:06 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:17157 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754063AbaEIU2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:28:04 -0400
Date: Fri, 9 May 2014 13:30:14 -0700
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Josh Cartwright <joshc@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        David Collins <collinsd@codeaurora.org>
Subject: Re: [PATCH 1/2] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
Message-ID: <20140509203013.GA5568@sonymobile.com>
References: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
 <20140423214626.GA3215@joshc.qualcomm.com>
 <20140423233621.GM17066@sonymobile.com>
 <20140424181829.GA19254@joshc.qualcomm.com>
 <1399639530.8165.32.camel@iivanov-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1399639530.8165.32.camel@iivanov-dev>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 02:45:30PM +0200, Ivan T. Ivanov wrote:
[...]
> > > > 
> > > > I'm thinking we should probably have a generic compatible entry as well,
> > > > "qcom,pmic-qpnp" or similar.  We should still specify in the binding
> > > > that PMIC slaves specify a version-specific string as well as the
> > > > generic string.  That is, a slave should have:
> > > > 
> > > > 	compatible = "qcom,pm8841", "qcom,pmic-qpnp";
> > > > 
> > > > ...in case we would ever need to differentiate in the future.
> > > > 
> > > > (I recall that in a previous version I had done this, but I don't
> > > > remember why I had changed it..)
> > >
> > > I gave this some thought but came to the conclusion that there is no
> > > benefit of adding a generic compatible to a new binding.  Please clarify
> > > a use-case where this would be ... useful.
> > 
> > Having a generic compatible entry allows for easily supporting new PMICs
> > without having to add yet another vacuous entry in the ID table.  In
> > this case I think it's perfectly acceptable given that this driver isn't
> > really defining a programming model for a specific device, but rather
> > acting much more like a bus.
> > 
> > Requiring a specific PMIC listed before a generic one allows us an
> > escape hatch in the future if for some reason we need to add a quirk for
> > a specific PMIC.
> 
> Is there a conclusion on this issue? I am voting for generic name :-)
> "qcom,pm-qpnp".

Josh and I have discussed this offline, and I think we have come to the
conclusion that this should be a generic driver with only a generic
binding.  The current proposed name is "spmi-ext", as there is specific
functional relation to Qualcomm, PMICs or QPNP.

Further, the binding documentation should be specific to pm8[89]41 as
'mfd/pm8x41.txt', and should contain the compatibles:
	- "qcom,pm8941", "spmi-ext"
	- "qcom,pm8841", "spmi-ext"

This naming has been discussed to death, so a few more shed color
suggestions can't possibly hurt.

> Further complication is that several sub function drivers expect to
> runtime detect the exact version of the controller ("qcom, qpnp-iadc",
> "qcom, qpnp-vadc", "qcom, qpnp-linear-charger").  This is realized by the
> exported function of the driver "qcom, qpnp-revid". Would it be good
> idea to merge qpnp-revid and "qcom,pm-qpnp" driver?

Each block within the PMICs have--undocumented--version registers, so a
global version number is not particularly useful.  A good example of
this is the ADC code [1], as you mentioned.

-Courtney

[1] https://www.codeaurora.org/cgit/quic/la/kernel/msm-3.10/tree/drivers/thermal/qpnp-adc-tm.c#n469
