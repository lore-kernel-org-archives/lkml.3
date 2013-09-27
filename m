Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681Ab3I0N51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 09:57:27 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:37143 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab3I0N5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 09:57:25 -0400
X-AuditID: cbfec372-b7fe76d000003347-02-52458ec31bf5
Date: Fri, 27 Sep 2013 10:57:16 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: srinivas.kandagatla@st.com
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] media: rc: OF: Add Generic bindings for remote-control
Message-id: <20130927105716.64349f02@samsung.com>
In-reply-to: <52458774.1060909@st.com>
References: <1380274391-26577-1-git-send-email-srinivas.kandagatla@st.com>
 <20130927113458.GB18672@e106331-lin.cambridge.arm.com>
 <52458774.1060909@st.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t/hEN0jfa5BBidWMlrMP3KO1eLcKyBr
	YdsSFovLu+awWfRs2MpqsfT6RSaLCdPXslgcXnGAyWLdy+ksFlOe9bJavDrYxuLA7bFm3hpG
	jwWfr7B7rFz+hc3j1eqZrB5Pf+xl9vi8Sc5j49zQAPYoLpuU1JzMstQifbsErox9Ny6yFFwU
	r+jY/5exgXGLUBcjB4eEgInEodMlXYycQKaYxIV769m6GLk4hASWMEo8nrOFGcLpYZLo+HyG
	FaSKRUBV4unRZWwgNpuAkcSrxhawuIiAnMTHue9YQRqYBT4wS5xpBOnm4BAW8Je43sMOUsMr
	YChx6u41JpAwp4CaxLYNUPPnM0psur6JEeIgJ4mtU30hygUlfky+xwJiMwtoSWze1sQKYctL
	bF7zlnkCo8AsJGWzkJTNQlK2gJF5FaNoaXFyQXFSeq6hXnFibnFpXrpecn7uJkZIdBTtYHy2
	weoQowAHoxIPr0CGS5AQa2JZcWXuIUYJDmYlEV6RTtcgId6UxMqq1KL8+KLSnNTiQ4xMHJxS
	DYzy66rSxeZFTvI3El2nNGeN0+/jez7lTXv8Lm2x6aSsvWvZF/y7bljZtuSpcpJG8b6+w96z
	J+Q337Bce9Ox/5DVWkZD/pnKGq/LtFf8mZMtcc3YTWWSu957t4aiY56JzS+Uv+nvDKk44jqX
	SfLCub/7k33O6AspnZz0/f7VFIYDgk9P67J/WJCnxFKckWioxVxUnAgAAMkAemwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 27 Sep 2013 14:26:12 +0100
Srinivas KANDAGATLA <srinivas.kandagatla@st.com> escreveu:

> On 27/09/13 12:34, Mark Rutland wrote:
> 
> >> > +	- rx-mode: Can be "infrared" or "uhf". rx-mode should be present iff
> >> > +	  the rx pins are wired up.
> > I'm unsure on this. What if the device has multiple receivers that can
> > be independently configured? What if it supports something other than
> > "infrared" or "uhf"? What if a device can only be wired up as
> > "infrared"? 
> > 
> > I'm not sure how generic these are, though we should certainly encourage
> > bindings that can be described this way to be described in the same way.
> > 
> >> > +	- tx-mode: Can be "infrared" or "uhf". tx-mode should be present iff
> >> > +	  the tx pins are wired up.
> > I have similar concerns here to those for the rx-mode property.
> > 
> Initially rx-mode and tx-mode sounded like more generic properties
> that's the reason I ended up in this route. But after this discussion it
> looks like its not really generic enough to cater all the use cases.
> 
> It make sense for me to perfix "st," for these properties in the st-rc
> driver rather than considering them as generic properties.

Well, for sure the direction (TX, RX, both) is a generic property.

I'd say that the level 1 protocol (IR, UHF, Bluetooth, ...) is also a
generic property. Most remotes are IR, but there are some that are
bluetooth, and your hardware is using UHF.

Btw, we're even thinking on mapping HDMI-CEC remote controller RX/TX via
the RC subsystem. So, another L1 protocol would be "hdmi-cec".

Yet, it seems unlikely that the very same remote controller IP would use
a different protocol for RX and TX, while sharing the same registers.

So, for example, a hardware with "hdmi-cec" and "infrared" will actually
have two remote controller devices. Eventually, the "infrared" being
just RX, while "hdmi-cec" being bi-directional.

So, IMHO, this could be mapped as "l1_protocol" ("infrared", "uhf", ...)
and another one "direction" ("rx", "tx", "bi-directional").

> 
> > I think what we actually need to document is the process of creating a
> > binding in such a way as to encourage uniformity. Something like the
> > following steps:
> I agree, It will help.. :-)
> > 
> > 1. Look to see if a binding already exists. If so, use it.
> > 
> > 2. Is there a binding for a compatible device? If so, use/extend it.
> > 
> > 3. Is there a binding for a similar (but incompatible) device? Use it as
> >    a template, possibly factor out portions into a class binding if
> >    those portions are truly general.
> > 
> > 4. Is there a binding for the class of device? If so, build around that,
> >    possibly extending it.
> > 
> > 5. If there's nothing relevant, create a binding aiming for as much
> >    commonality as possible with other devices of that class that may
> >    have bindings later.
> 
> Thanks for this little guide...
> 
> --srini


-- 

Cheers,
Mauro
