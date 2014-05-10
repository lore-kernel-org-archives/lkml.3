Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbaEJIHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 04:07:46 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:39105 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaEJIHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 04:07:40 -0400
Message-ID: <1399709209.8165.44.camel@iivanov-dev>
Subject: Re: [PATCH 1/2] mfd: pm8x41: add support for Qualcomm 8x41 PMICs
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: Josh Cartwright <joshc@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        David Collins <collinsd@codeaurora.org>
Date: Sat, 10 May 2014 11:06:49 +0300
In-Reply-To: <20140509203013.GA5568@sonymobile.com>
References: <1398213110-28135-1-git-send-email-courtney.cavin@sonymobile.com>
	 <20140423214626.GA3215@joshc.qualcomm.com>
	 <20140423233621.GM17066@sonymobile.com>
	 <20140424181829.GA19254@joshc.qualcomm.com>
	 <1399639530.8165.32.camel@iivanov-dev>
	 <20140509203013.GA5568@sonymobile.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.1-2ubuntu2~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Courtney,

On Fri, 2014-05-09 at 13:30 -0700, Courtney Cavin wrote:

> > > Requiring a specific PMIC listed before a generic one allows us an
> > > escape hatch in the future if for some reason we need to add a quirk for
> > > a specific PMIC.
> > 
> > Is there a conclusion on this issue? I am voting for generic name :-)
> > "qcom,pm-qpnp".
> 
> Josh and I have discussed this offline, and I think we have come to the
> conclusion that this should be a generic driver with only a generic
> binding.  The current proposed name is "spmi-ext", as there is specific
> functional relation to Qualcomm, PMICs or QPNP.
> 
> Further, the binding documentation should be specific to pm8[89]41 as
> 'mfd/pm8x41.txt', and should contain the compatibles:
> 	- "qcom,pm8941", "spmi-ext"
> 	- "qcom,pm8841", "spmi-ext"
> 
> This naming has been discussed to death, so a few more shed color
> suggestions can't possibly hurt.

I am fine with this. Thanks.

> 
> > Further complication is that several sub function drivers expect to
> > runtime detect the exact version of the controller ("qcom, qpnp-iadc",
> > "qcom, qpnp-vadc", "qcom, qpnp-linear-charger").  This is realized by the
> > exported function of the driver "qcom, qpnp-revid". Would it be good
> > idea to merge qpnp-revid and "qcom,pm-qpnp" driver?
> 
> Each block within the PMICs have--undocumented--version registers, so a
> global version number is not particularly useful.  A good example of
> this is the ADC code [1], as you mentioned.

Do you happen to know how to match local subdevices revisions to global 
PMIC revision? Earlier mentioned drivers are using global chip revision. 

I will not be surprised if local subdevice version is not changed, but
instead global version is changed, when only subdevice functionality is 
changed ;-)

Regards,
Ivan

