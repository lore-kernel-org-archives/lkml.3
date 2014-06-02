Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaFBNOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 09:14:39 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:52115 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbaFBNOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 09:14:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140602122332.GA31751@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
	<20140527192923.GC12304@sirena.org.uk>
	<CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
	<20140528173858.GG5099@sirena.org.uk>
	<CAKohpokk_sNQ7Be5F8NLa7pLrssPm9qPf-fDEUYkiurJ6Etrpg@mail.gmail.com>
	<20140602095112.GV5099@sirena.org.uk>
	<CAKohpom7XNFJ7dBzNVW0TX3gyxo4RJdJ4yriYLa_noforhyciw@mail.gmail.com>
	<20140602100201.GX5099@sirena.org.uk>
	<CAKohpomj5-tHPkBLMrgGpsDCaCxW-8hGMunMTmJgXGgEgTR=vA@mail.gmail.com>
	<20140602122332.GA31751@sirena.org.uk>
Date: Mon, 2 Jun 2014 18:44:35 +0530
Message-ID: <CAKohpo=vPojhX_9u6Coa=2Kiu0jY9hCTg2B0WiWfJS8ZQxK4Rg@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulators: Add definition of regulator_set_voltage_time()
 for !CONFIG_REGULATOR
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 June 2014 17:53, Mark Brown <broonie@kernel.org> wrote:
> If the consumer tried to set a voltage presumably it cares if that
> voltage was set - for example if your cpufreq driver tries to increase
> the voltage of a core supply so that it can then raise the frequency the
> user is going to be upset if the voltage was not actually raised and it
> goes off and raises the clock rate causing the system to become unstable.

If the driver continued despite getting regulator as NULL, it means that
regulator isn't a MUST for it. For example a CPUFreq driver may work
with or without a regulator.

Now if the dummy calls return *error* for some cases then these driver
will have to do
if(xyz)
    API-call()..

And so dummy APIs like clk_set_rate(), clk_get_rate(),
regulator_set_voltage() must return zero..

To get rid of this in drivers these dummy routines *must* behave as
they passed, if the drivers really care about them then they must
quit as soon as regulator_get() returned NULL.

This is why we have such implementations in clk framework which are
very well thought earlier.

Does this make sense?
