Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaBDSCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:02:17 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:54257 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaBDSCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:02:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140204110531.GR22609@sirena.org.uk>
References: <1391493268-3242-1-git-send-email-bjorn.andersson@sonymobile.com>
	<20140204110531.GR22609@sirena.org.uk>
Date: Tue, 4 Feb 2014 10:02:14 -0800
Message-ID: <CAJAp7OjCnJ=P9Gi20=D9gybREiSaqd1CaQ0K=9fGbCzU1gTFLw@mail.gmail.com>
Subject: Re: [PATCH] regulator: core: Make regulator object reflect configured voltage
From: Bjorn Andersson <bjorn@kryo.se>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 3:05 AM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Feb 03, 2014 at 09:54:28PM -0800, Bjorn Andersson wrote:
>
>> +     /*
>> +      * Make the regulator reflect the configured voltage selected in
>> +      * machine_constraints_voltage()
>> +      */
>> +     if (rdev->constraints->apply_uV &&
>> +         rdev->constraints->min_uV == rdev->constraints->max_uV) {
>> +             regulator->min_uV = rdev->constraints->min_uV;
>> +             regulator->max_uV = rdev->constraints->min_uV;
>> +     }
>> +
>
> Why not do this at the time we apply the voltage?  That would seem to be
> more robust, doing it in a separate place means that we might update one
> bit of code and not the other or might change the execution path so that
> one gets run and the other doesn't.

I do share your concerns about having this logic mirrored here is
risky, unfortunately the regulator object is created upon request from
a consumer; so it is not available when regulator_register() calls
set_machine_constraints().

An alternative is to drop the conditional setting of
REGULATOR_CHANGE_VOLTAGE from of_regulator.c and force the regulator
drivers to set this flag explicitly; to avoid the difference in
behavior depending on configuration.

Regards,
Bjorn
