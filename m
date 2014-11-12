Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaKLJMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 04:12:09 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:44380 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaKLJMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 04:12:05 -0500
Message-ID: <1415783543.4820.4.camel@mm-sol.com>
Subject: Re: [PATCH] mfd: qcom-spmi-pmic: Add support for more chips versions
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: Bjorn Andersson <bjorn@kryo.se>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Date: Wed, 12 Nov 2014 11:12:23 +0200
In-Reply-To: <20141111202708.GA13013@sonymobile.com>
References: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
	 <CAJAp7OgU64=KCuDhYEZTYppVeBz6wKvTDsof5vDRznfdZgAfZw@mail.gmail.com>
	 <1415212271.14949.1.camel@mm-sol.com>
	 <CAJAp7OgXHGWQj7MWh51LTUdmZpgZc=6m=o-Az=z8QxR7yfrw7g@mail.gmail.com>
	 <1415260480.13103.3.camel@mm-sol.com>
	 <CAJAp7OgPGhM=EnMNU2JfjG6Qb-EiWSPSRyZWGicSPmpicBQW7g@mail.gmail.com>
	 <1415374390.26058.1.camel@mm-sol.com> <1415374852.26058.3.camel@mm-sol.com>
	 <20141111202708.GA13013@sonymobile.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.6-fta3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2014-11-11 at 12:27 -0800, Courtney Cavin wrote:
> On Fri, Nov 07, 2014 at 04:40:52PM +0100, Ivan T. Ivanov wrote:
> > 
> > Forgot to add. PMIC subtype and version are used also in charger and BMS
> > drivers to workaround hardware issues.
> 
> All of the blocks on the PM8x41 series have their own version numbers.
> There's no need to look at the chip revision.

I am suspecting that, for whatever the reason is, after updates inside blocks,
the PMIC chip revisions update was made instead of blocks own version update.

> 
> In fact, the SMBB (charger) documentation (80-NA555-12) specifically

It would be nice if I had this document :-).

> refers to the SMBB_MISC block revision registers as the method for
> determining the hardware version.  The "qpnp-charger" SMBB driver in the
> CAF 3.4 & 3.10 trees utilizes block specific revision numbers, as do the
> "qpnp-bms" BMS driver, the "qpnp-adc-current" IADC driver, and the
> "qpnp-adc-voltage" VADC driver.

Hm, they read its own block revision, but they are using PMIC chip revision
for workaround decisions. What could be the reason for this?

> 
> The revision of the PMIC itself should be completely irrelevant to any
> of the software interfacing with it.
> 

It will be really nice if this is the case, but I am afraid it is not.

Regards,
Ivan



