Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaIJRK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:10:56 -0400
Received: from www.augenpunkt.de ([213.239.207.9]:59528 "EHLO
	www.augenpunkt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaIJRKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:10:54 -0400
Message-ID: <54108B34.6010701@lategoodbye.de>
Date: Wed, 10 Sep 2014 19:32:36 +0200
From: Stefan Wahren <info@lategoodbye.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "stefan.wahren@i2se.com" <stefan.wahren@i2se.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC 2/3] ARM: regulator: add Freescale MXS regulator driver
References: <1410089869-6611-1-git-send-email-info@lategoodbye.de> <1410089869-6611-3-git-send-email-info@lategoodbye.de> <20140909182211.GG3896@leverpostej> <540F523D.4010904@lategoodbye.de> <20140910141853.GA4994@leverpostej> <20140910151316.GG7960@sirena.org.uk>
In-Reply-To: <20140910151316.GG7960@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Am 10.09.2014 17:13, schrieb Mark Brown:
> On Wed, Sep 10, 2014 at 03:18:53PM +0100, Mark Rutland wrote:
>> On Tue, Sep 09, 2014 at 08:17:17PM +0100, Stefan Wahren wrote:
>
> Ugh, this looks like it might be a regulator driver but since the
> subject line was "ARM: " I deleted it unread - if your changelog looks
> different to all the other changelogs in the subsystem it probably needs
> changing.

sorry about the confusion, i will remove ARM in the next version.

Changelog? I didn't send a changelog because it was my first version.

Should i resend this version only to you?

>
>>>>> +       sreg = devm_kzalloc(dev, sizeof(*sreg), GFP_KERNEL);
>>>>> +       if (!sreg)
>>>>> +               return -ENOMEM;
>>>>> +       sreg->initdata = initdata;
>>>>> +       sreg->name = of_get_property(np, "regulator-name", NULL);
>
>>>> I'm not keen on using of_get_property here. We have no idea if
>>>> regulator-name is even a string (it should be, but we have no
>>>> guarantee).
>
>>> Better using of_property_read_string?
>
>> Yes. That will check the value is NUL-terminated, at least.
>
> Or just remove the property entirely...  without having seen the
> bindings if we're specifying the name of the device via the device tree
> something seems wrong.
>

BR Stefan
