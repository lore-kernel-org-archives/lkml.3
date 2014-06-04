Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaFDK5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:57:50 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:57655 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaFDK5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:57:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140604103846.GF2520@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
	<20140527192923.GC12304@sirena.org.uk>
	<CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
	<20140528173858.GG5099@sirena.org.uk>
	<CAKohpo=T3BG9X0gHfRA-x8B3ou3Y=XHcs=OTYAHikX61iAJ9xw@mail.gmail.com>
	<20140603145347.GE31751@sirena.org.uk>
	<CAKohpo=VLCf2nz1WsL-iGw6BWwpmqZ+8JwGFFHFFtjZyAS9LrA@mail.gmail.com>
	<20140603154854.GG31751@sirena.org.uk>
	<CAKohpon9G=JdZ1jSStHZH29VZDggZXm+EOqDAwedk2K0ZxD0Qg@mail.gmail.com>
	<20140604103846.GF2520@sirena.org.uk>
Date: Wed, 4 Jun 2014 16:27:48 +0530
Message-ID: <CAKohpomS24eoqJ7h9d_5mPsyXhmnRSMW4fiCT0JnLRy5U6ARgw@mail.gmail.com>
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

On 4 June 2014 16:08, Mark Brown <broonie@kernel.org> wrote:
> Please, go and *think* about what's going on here.  I've repeatedly
> asked you to consider the case where we need to raise the voltage prior
> to raising the frequency for cpufreq but you've not responded to these
> requests either directly or in showing any sign of having understood the
> issue.

I replied to that only when I said:

- For platforms with regulators support, we _must_ check if the voltage
change is successful or not and fail if regulator_set_voltage() failed.

And what you wrote earlier was correct, we may end up with unstable
systems if we ramp frequencies even when changing voltage failed.

> If the code fails to change the voltage it needs to handle that
> (including remembering that attempts to lower the voltage fail); if the
> code handles the errors sensibly I would expect that to handle
> everything.

That's what I was asking, how should the code handle it? Code also
has to take care of platforms which haven't configured regulators
in kernel and want to use this generic driver.

Sorry if I still didn't answer it properly :(
