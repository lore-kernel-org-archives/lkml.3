Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaKDPtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:49:40 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:48443 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557AbaKDPti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:49:38 -0500
Message-ID: <1415116195.29957.16.camel@mm-sol.com>
Subject: Re: [PATCH] mfd: qcom-spmi-pmic: Add support for more chips versions
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Date: Tue, 04 Nov 2014 17:49:55 +0200
In-Reply-To: <5458F039.3030809@mm-sol.com>
References: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
	  <5458EB64.3030203@mm-sol.com> <1415114567.29957.14.camel@mm-sol.com>
	 <5458F039.3030809@mm-sol.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.6-fta3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2014-11-04 at 17:26 +0200, Stanimir Varbanov wrote:
> On 11/04/2014 05:22 PM, Ivan T. Ivanov wrote:
> > On Tue, 2014-11-04 at 17:06 +0200, Stanimir Varbanov wrote:

<snip>

> > > > +       snprintf(compatible, ARRAY_SIZE(compatible), "qcom,%s-v%d.%d",
> > > > +       name, major, minor);
> > > > +       prop = kzalloc(sizeof(*prop), GFP_KERNEL);
> > > > +       if (prop) {
> > > > +       prop->name = kstrdup("compatible", GFP_KERNEL);
> > > > +       prop->value = kstrdup(compatible, GFP_KERNEL);
> > > > +       prop->length = strlen(prop->value);
> > > > +       of_update_property(root, prop);
> > > 
> > > of_update_property can fail, check the returned value.
> > 
> > Same thing as above, but probably allocated memory at least can be freed.
> 
> might be better idea to use devm_kzalloc and devm_kstrdup?
> 

compatible property is attached to device not to driver, so
memory should be there even after driver is unloaded, I think.

Regards,
Ivan
