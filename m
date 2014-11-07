Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaKGPks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:40:48 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:43277 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbaKGPkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:40:46 -0500
Message-ID: <1415374852.26058.3.camel@mm-sol.com>
Subject: Re: [PATCH] mfd: qcom-spmi-pmic: Add support for more chips versions
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Date: Fri, 07 Nov 2014 17:40:52 +0200
In-Reply-To: <1415374390.26058.1.camel@mm-sol.com>
References: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
	 <CAJAp7OgU64=KCuDhYEZTYppVeBz6wKvTDsof5vDRznfdZgAfZw@mail.gmail.com>
	 <1415212271.14949.1.camel@mm-sol.com>
	 <CAJAp7OgXHGWQj7MWh51LTUdmZpgZc=6m=o-Az=z8QxR7yfrw7g@mail.gmail.com>
	 <1415260480.13103.3.camel@mm-sol.com>
	 <CAJAp7OgPGhM=EnMNU2JfjG6Qb-EiWSPSRyZWGicSPmpicBQW7g@mail.gmail.com>
	 <1415374390.26058.1.camel@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.6-fta3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2014-11-07 at 17:33 +0200, Ivan T. Ivanov wrote:
> On Thu, 2014-11-06 at 08:55 -0800, Bjorn Andersson wrote:
> > On Wed, Nov 5, 2014 at 11:54 PM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> > > On Wed, 2014-11-05 at 17:36 -0800, Bjorn Andersson wrote:
> > > > On Wed, Nov 5, 2014 at 10:31 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> > [..]
> > > > > Some of the child device drivers have to know PMIC chip revision.
> > > > > 
> > > > 
> > > > So your plan is to have a strstr(parent->compatible, "-v2") there?
> > > 
> > > Actually also PMIC subtype (pm8841, pm8226...) is also required, so
> > > the plan is to have something like this:
> > > 
> > > {
> > >         static const struct of_device_id pmic_match_table[] = {
> > >                 { .compatible = "qcom,pm8941-v1.0" },
> > >                 { .compatible = "qcom,pm8841-v0.0" },
> > >                 { }
> > > 
> > >         };
> > > 
> > >         const struct of_device_id *match;
> > > 
> > >         match = of_match_device(pmic_match_table, pdev->dev.parent);
> > >         if (match) {
> > >                 dev_info(&pdev->dev, "%s chip detected\n", match->compatible);
> > >         }
> > > }
> > > 
> > 
> > To me this is a hack, you should not alter the devicetree to make it
> > "better express the hardware". Either you know these things from boot
> > and they go in device tree, or you can probe them and they should not
> > go in device tree.
> > 
> > If you really need these values you should expose them through some api.
> 
> I would like to avoid compile time dependency between these drivers.
> There are several precedents of using of_update_property() for enhancing
> compatible property already.
> 
> > > > Could you be a little bit more elaborate on what you're trying to do
> > > > and which child devices that might be?
> > > 
> > > For example ADC drivers are required temperature compensation based
> > > on PMIC variant and chip manufacturer.
> > > 
> > 
> > I see, is that compensation of any practical value? Or is the
> > compensation of academic proportions?
> 
> It depends of what you mean by academic :-). Attached file have test
> application which dump difference between non compensated and compensated
> values for different temperature, manufacture and input value.
> 
> Output format of the program is:
> Column 1: manufacturer GF=0, SMIC=1, TSMC=2
> Column 2: chip revision
> Column 3: die temperature in mili deg Celsius
> Column 4: input for compensation in micro Volts
> Column 5: compensated result in micro Volts
> Column 6: difference in micro Volts

Forgot to add. PMIC subtype and version are used also in charger and BMS
drivers to workaround hardware issues.

Ivan
