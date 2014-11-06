Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaKFBhE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 20:37:04 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46638 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaKFBhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 20:37:01 -0500
MIME-Version: 1.0
In-Reply-To: <1415212271.14949.1.camel@mm-sol.com>
References: <1415108003-16387-1-git-send-email-iivanov@mm-sol.com>
	<CAJAp7OgU64=KCuDhYEZTYppVeBz6wKvTDsof5vDRznfdZgAfZw@mail.gmail.com>
	<1415212271.14949.1.camel@mm-sol.com>
Date: Wed, 5 Nov 2014 17:36:59 -0800
Message-ID: <CAJAp7OgXHGWQj7MWh51LTUdmZpgZc=6m=o-Az=z8QxR7yfrw7g@mail.gmail.com>
Subject: Re: [PATCH] mfd: qcom-spmi-pmic: Add support for more chips versions
From: Bjorn Andersson <bjorn@kryo.se>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 10:31 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
>
> On Wed, 2014-11-05 at 10:11 -0800, Bjorn Andersson wrote:
>> On Tue, Nov 4, 2014 at 5:33 AM, Ivan T. Ivanov <iivanov@mm-sol.com>
>> wrote:
>> [..]
>> > @@ -28,11 +144,27 @@ static int pmic_spmi_probe(struct spmi_device
>> > *sdev)
>> >  {
>> >         struct device_node *root = sdev->dev.of_node;
>> >         struct regmap *regmap;
>> > +       struct property *prop;
>> > +       int major, minor, ret;
>> > +       char *name, compatible[32];
>> >
>> >         regmap = devm_regmap_init_spmi_ext(sdev,
>> > &spmi_regmap_config);
>> >         if (IS_ERR(regmap))
>> >                 return PTR_ERR(regmap);
>> >
>> > +       ret = pmic_spmi_read_revid(regmap, &name, &major, &minor);
>> > +       if (!ret) {
>> > +               snprintf(compatible, ARRAY_SIZE(compatible),
>> > "qcom,%s-v%d.%d",
>> > +                        name, major, minor);
>> > +               prop = kzalloc(sizeof(*prop), GFP_KERNEL);
>> > +               if (prop) {
>> > +                       prop->name = kstrdup("compatible",
>> > GFP_KERNEL);
>> > +                       prop->value = kstrdup(compatible,
>> > GFP_KERNEL);
>> > +                       prop->length = strlen(prop->value);
>> > +                       of_update_property(root, prop);
>> > +               }
>> > +       }
>> > +
>>
>> Why would you do this?
>> What benefit does it give to patch the of_node to have a more
>> specific
>> compatible?
>
> Some of the child device drivers have to know PMIC chip revision.
>

So your plan is to have a strstr(parent->compatible, "-v2") there?

Could you be a little bit more elaborate on what you're trying to do
and which child devices that might be?

Regards,
Bjorn
