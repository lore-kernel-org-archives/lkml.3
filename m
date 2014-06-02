Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaFBKPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:15:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51652 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbaFBKPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:15:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140602100201.GX5099@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
	<20140527192923.GC12304@sirena.org.uk>
	<CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
	<20140528173858.GG5099@sirena.org.uk>
	<CAKohpokk_sNQ7Be5F8NLa7pLrssPm9qPf-fDEUYkiurJ6Etrpg@mail.gmail.com>
	<20140602095112.GV5099@sirena.org.uk>
	<CAKohpom7XNFJ7dBzNVW0TX3gyxo4RJdJ4yriYLa_noforhyciw@mail.gmail.com>
	<20140602100201.GX5099@sirena.org.uk>
Date: Mon, 2 Jun 2014 15:45:37 +0530
Message-ID: <CAKohpomj5-tHPkBLMrgGpsDCaCxW-8hGMunMTmJgXGgEgTR=vA@mail.gmail.com>
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

On 2 June 2014 15:32, Mark Brown <broonie@kernel.org> wrote:
> No, think about what you're changing here.  You're changing the stub -
> the stub has a regulator_get() which always succeeeds.

Right, things might start to break with the change to
regulator_set_voltage()..

When I compare this to clk-APIs, the dummy implementations always
pass and so we are allowed to send NULL clk to any routine (the way
we can do it here, probably to simply code)..

Now, why do we want to return -EINVAL from set_voltage here ? Similar
routines in clk-API are returning 0 and even clk_get_rate() returns zero,
unlike in regulators, as we return -EINVAL..

Not sure which of these frameworks is doing the right thing.

What do you suggest.
