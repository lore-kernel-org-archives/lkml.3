Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3GDLns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:43:48 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:53688 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3GDLnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:43:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130704092249.GK27646@sirena.org.uk>
References: <1372072858-6559-1-git-send-email-yadi.brar@samsung.com>
	<1372072858-6559-4-git-send-email-yadi.brar@samsung.com>
	<20130703180511.GA374@sirena.org.uk>
	<CAKew6eVs+D4Yf+9=e+0fj0UaZQ98gJ-1=CX30_H0p-xnF75gaw@mail.gmail.com>
	<20130704092249.GK27646@sirena.org.uk>
Date: Thu, 4 Jul 2013 17:13:46 +0530
Message-ID: <CAKew6eVWt==t3NZTwvULTBmWSHkAf6jNuPcj8p711st_7ZmRAw@mail.gmail.com>
Subject: Re: [PATCH 3/4] mfd: s2mps11: Add device tree support
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

On Thu, Jul 4, 2013 at 2:52 PM, Mark Brown <broonie@kernel.org> wrote:
> On Thu, Jul 04, 2013 at 10:37:30AM +0530, Yadwinder Singh Brar wrote:
>
>> -  Currently ramp-delay (= 0) if not defined in DT, leaves the
>> hardware with default
>
> That's just an issue in the code if that is the case, you can test for
> the presence of a property independently of getting its value.
>

Yes, for that we will need an extra flag (ramp_disable) in
constraints, to figure out whether
ramp-rate is actually set to zero or its left (by default) zero if we
do it in common code as
now we have locally in driver.

>> - As ramp time is inversely propositional to ramp-rate(i.e. ramp-delay ,
>> its wrongly named, my mistake :( ) so it may look weired to use ramp-rate =0
>> as no ramp(ramp_time = 0).
>
> I think it's fairly obvious what's going on there, it fits in with the
> general pattern that a lower number is faster too.
>

yes, lower number(ramp_time) is faster, but I meant to say that lower
ramp-rate means higher ramp_time.

I think its matter of assumption, so to conclude our discussion,
please let me know that which approach we should use:
- assume "regulator-ramp-delay = <0>" as ramp_disable.
or
- parsing "regulator_ramp_disable" from DT.



Regards,
Yadwinder
