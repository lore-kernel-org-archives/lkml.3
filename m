Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaJJM3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 08:29:06 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:64492 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJJM3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 08:29:02 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6vmBSgGpJgJ51Ki5KbQO65GDw3kSGSxnswYMfE8OGj9gw@mail.gmail.com>
References: <1412711104-15902-1-git-send-email-romain.perier@gmail.com>
	<CABgxDoL2cztT6Y0oodtk4Q4jaDc1Rtx_RokxC+f0XykSojrdyg@mail.gmail.com>
	<CACxGe6vmBSgGpJgJ51Ki5KbQO65GDw3kSGSxnswYMfE8OGj9gw@mail.gmail.com>
Date: Fri, 10 Oct 2014 14:29:00 +0200
Message-ID: <CABgxDoKo8RkM3etK7Yu+8vHQSWs-53wnZujF_QvXR0GJAwBfoA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 1/4] regulator: Add helper function to get
 "poweroff-source" property
From: PERIER Romain <romain.perier@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree <devicetree@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, robh <robh@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> What I'm more concerned about is the semantics of the property. What
> do the generic code paths gain by standardizing this property? Is it
> expected that

We really need to come up with a standard property for this and document
it rather than continuing to add individual device specific properties
each time a driver adds poweroff capability,
all doing the same thing (a lot of regulators driver, mfd drivers, soc
specific drivers, power drivers already do that, that's very redudant)
. This is a simple unification logic.
About its name, I found my inspiration with "wakeup-source" which
marks an device as able to wakeup the system, poweroff capability is
exactly the same
except that the device will control the power of the system, so I
choose "poweroff-source". However, suggestions are welcome ;)

About of_regulator.c, I agree with Mark. poweroff capability is not
really specific to regulators, so it does not make sense to put the
helper there, imho.

Romain
