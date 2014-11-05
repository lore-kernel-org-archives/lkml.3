Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaKESbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:31:20 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:50682 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaKESbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:31:16 -0500
Message-ID: <1415212271.14949.1.camel@mm-sol.com>
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
Date: Wed, 05 Nov 2014 20:31:11 +0200
In-Reply-To: <CAJAp7OgU64=KCuDhYEZTYppVeBz6wKvTDsof5vDRznfdZgAfZw@mail.gmail.com>
References: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
	 <CAJAp7OgU64=KCuDhYEZTYppVeBz6wKvTDsof5vDRznfdZgAfZw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.13.8 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2014-11-05 at 10:11 -0800, Bjorn Andersson wrote:
> On Tue, Nov 4, 2014 at 5:33 AM, Ivan T. Ivanov <iivanov@mm-sol.com> 
> wrote:
> [..]
> > @@ -28,11 +144,27 @@ static int pmic_spmi_probe(struct spmi_device 
> > *sdev)
> >  {
> >         struct device_node *root = sdev->dev.of_node;
> >         struct regmap *regmap;
> > +       struct property *prop;
> > +       int major, minor, ret;
> > +       char *name, compatible[32];
> > 
> >         regmap = devm_regmap_init_spmi_ext(sdev, 
> > &spmi_regmap_config);
> >         if (IS_ERR(regmap))
> >                 return PTR_ERR(regmap);
> > 
> > +       ret = pmic_spmi_read_revid(regmap, &name, &major, &minor);
> > +       if (!ret) {
> > +               snprintf(compatible, ARRAY_SIZE(compatible), 
> > "qcom,%s-v%d.%d",
> > +                        name, major, minor);
> > +               prop = kzalloc(sizeof(*prop), GFP_KERNEL);
> > +               if (prop) {
> > +                       prop->name = kstrdup("compatible", 
> > GFP_KERNEL);
> > +                       prop->value = kstrdup(compatible, 
> > GFP_KERNEL);
> > +                       prop->length = strlen(prop->value);
> > +                       of_update_property(root, prop);
> > +               }
> > +       }
> > +
> 
> Why would you do this?
> What benefit does it give to patch the of_node to have a more 
> specific
> compatible?

Some of the child device drivers have to know PMIC chip revision.

Regards,
Ivan
