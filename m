Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3GDFOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:14:37 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:55020 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab3GDFOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:14:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130703180033.GX27646@sirena.org.uk>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
	<1372072858-6559-5-git-send-email-yadi.brar@samsung.com>
	<20130703180033.GX27646@sirena.org.uk>
Date: Thu, 4 Jul 2013 10:44:36 +0530
Message-ID: <CAKew6eUGK+g1__m8QHFiz_miNPLwaMc0CG5ViwNGr2qQX5ESoQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] regulator: s2mps11: Add device tree support
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>, linux-kernel@vger.kernel.org,
        sbkim73@samsung.com, Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 11:30 PM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Jun 24, 2013 at 04:50:58PM +0530, Yadwinder Singh Brar wrote:
>
>> +static void s2mps11_pmic_parse_dt(struct of_regulator_match *rdata,
>> +                                     struct s2mps11_info *s2mps11)
>> +{
>> +     if (!of_find_property(rdata[S2MPS11_BUCK2].of_node,
>> +                             "regulator-ramp-disable", NULL))
>> +             s2mps11->buck2_ramp = true;
>
> This property should be specific to this binding rather than named as a
> generic regulator property.  It's also a bit odd that setting a property
> called "regulator-ramp-disable" causes the flag buckN_ramp to be set to
> true - if the ramp is being disabled I'd expect a flag with that name to
> be false not true.  Seems something isn't named right.

Yes, it seems incorrect but in existing code based on pdata, its name like that.
If you insist, I can rename it ? as It seems sensible to put
"regulator-ramp-disable" as our intension is to do that(by default its
always enable).


Thanks,
Yadwinder
