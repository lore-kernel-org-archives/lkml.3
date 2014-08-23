Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaHWC0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 22:26:18 -0400
Received: from mail-oi0-f50.google.com ([209.85.218.50]:64508 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaHWC0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 22:26:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140822075041.GT4266@lee--X1>
References: <1407796988-25872-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1407796988-25872-3-git-send-email-bjorn.andersson@sonymobile.com>
	<20140821132204.GH4266@lee--X1>
	<20140822012748.GB12494@sonymobile.com>
	<20140822075041.GT4266@lee--X1>
Date: Fri, 22 Aug 2014 19:26:14 -0700
Message-ID: <CAJAp7OgmBUfNOZNbD0jW_fgO+rO=02PmEU64=c2ty6-2ENkBww@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] mfd: qcom-rpm: Driver for the Qualcomm RPM
From: Bjorn Andersson <bjorn@kryo.se>
To: Lee Jones <lee.jones@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Andy Gross <agross@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 12:50 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 21 Aug 2014, Bjorn Andersson wrote:
>> On Thu 21 Aug 06:22 PDT 2014, Lee Jones wrote:
>> > > +struct qcom_rpm *dev_get_qcom_rpm(struct device *dev)
>> > > +{
>> > > + return dev_get_drvdata(dev);
>> > > +}
>> > > +EXPORT_SYMBOL(dev_get_qcom_rpm);
>> >
>> > No need for this at all.  Use dev_get_drvdata() direct instead.
>> >
>>
>> I see that others have put this as static inline in the header file, so I will
>> follow that. I don't want to expose this directly in the implementation of the
>> clients.
>>
>> Let me know if you object.
>
> I do (unless you convince me otherwise).  Why is this a good idea and
> why 'exposing' this directly is a bad one?  At the moment this looks
> to me like abstraction for the sake of abstraction.
>

There's no other reason for it than to abstract because "it's nice",
so I'll change it.

>> > > + res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> > > + rpm->status_regs = devm_ioremap_resource(&pdev->dev, res);
>> > > + rpm->ctrl_regs = rpm->status_regs + 0x400;
>> > > + rpm->req_regs = rpm->status_regs + 0x600;
>> > > + if (IS_ERR(rpm->status_regs))
>> > > +         return PTR_ERR(rpm->status_regs);
>> >
>> > You should probably do this _before_ using it above.
>>
>> There's no difference in behaviour, but it just feels cleaner than:
>>
>> res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> rpm->status_regs = devm_ioremap_resource(&pdev->dev, res);
>> if (IS_ERR(rpm->status_regs))
>>       return PTR_ERR(rpm->status_regs);
>> rpm->ctrl_regs = rpm->status_regs + 0x400;
>> rpm->req_regs = rpm->status_regs + 0x600;
>>
>> If you don't like it, I'll change it.
>
> There is a difference.  In the current implementation you're doing math
> with a possible error code and assigning rubbish to rpm->ctrl_regs and
> rpm->req_regs.
>

Unfortunately, I still don't understand what practical drawback this
has, but I will of course change it per your request.

> [...]
>
>> > > +MODULE_DESCRIPTION("Qualcomm Resource Power Manager driver");
>> > > +MODULE_LICENSE("GPL v2");
>> >
>> > No one authored this driver?
>> >
>>
>> Thought that was optional, will update.
>
> It's also helpful.  Can you place an Author: line in the header(s) too.
>

Will do.

Regards,
Bjorn
