Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaKKUYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 15:24:08 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:14912 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944AbaKKUYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 15:24:06 -0500
Date: Tue, 11 Nov 2014 12:27:08 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Bjorn Andersson <bjorn@kryo.se>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH] mfd: qcom-spmi-pmic: Add support for more chips versions
Message-ID: <20141111202708.GA13013@sonymobile.com>
References: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
 <CAJAp7OgU64=KCuDhYEZTYppVeBz6wKvTDsof5vDRznfdZgAfZw@mail.gmail.com>
 <1415212271.14949.1.camel@mm-sol.com>
 <CAJAp7OgXHGWQj7MWh51LTUdmZpgZc=6m=o-Az=z8QxR7yfrw7g@mail.gmail.com>
 <1415260480.13103.3.camel@mm-sol.com>
 <CAJAp7OgPGhM=EnMNU2JfjG6Qb-EiWSPSRyZWGicSPmpicBQW7g@mail.gmail.com>
 <1415374390.26058.1.camel@mm-sol.com>
 <1415374852.26058.3.camel@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1415374852.26058.3.camel@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 04:40:52PM +0100, Ivan T. Ivanov wrote:
> On Fri, 2014-11-07 at 17:33 +0200, Ivan T. Ivanov wrote:
> > On Thu, 2014-11-06 at 08:55 -0800, Bjorn Andersson wrote:
> > > On Wed, Nov 5, 2014 at 11:54 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> > > > On Wed, 2014-11-05 at 17:36 -0800, Bjorn Andersson wrote:
[...]
> > > > > Could you be a little bit more elaborate on what you're trying to do
> > > > > and which child devices that might be?
> > > > 
> > > > For example ADC drivers are required temperature compensation based
> > > > on PMIC variant and chip manufacturer.
> > > > 
> > > 
> > > I see, is that compensation of any practical value? Or is the
> > > compensation of academic proportions?
> > 
> > It depends of what you mean by academic :-). Attached file have test
> > application which dump difference between non compensated and compensated
> > values for different temperature, manufacture and input value.
> > 
[...]
> Forgot to add. PMIC subtype and version are used also in charger and BMS
> drivers to workaround hardware issues.

All of the blocks on the PM8x41 series have their own version numbers.
There's no need to look at the chip revision.

In fact, the SMBB (charger) documentation (80-NA555-12) specifically
refers to the SMBB_MISC block revision registers as the method for
determining the hardware version.  The "qpnp-charger" SMBB driver in the
CAF 3.4 & 3.10 trees utilizes block specific revision numbers, as do the
"qpnp-bms" BMS driver, the "qpnp-adc-current" IADC driver, and the
"qpnp-adc-voltage" VADC driver.

The revision of the PMIC itself should be completely irrelevant to any
of the software interfacing with it.

-Courtney
