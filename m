Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245Ab3GVTnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:43:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58582 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab3GVTns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:43:48 -0400
Message-ID: <51ED8B6F.6020700@wwwdotorg.org>
Date: Mon, 22 Jul 2013 12:43:43 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Eduardo Valentin <eduardo.valentin@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, wni@nvidia.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, l.stach@pengutronix.de
Subject: Re: [lm-sensors] [RESEND PATCH V1 0/9] thermal: introduce DT thermal
 zone build
References: <1374074248-31690-1-git-send-email-eduardo.valentin@ti.com> <20130717220942.GB990@roeck-us.net> <51E7F341.8020508@ti.com> <51E8234D.1020607@wwwdotorg.org> <20130718212108.GC4110@roeck-us.net> <51E98A07.4050402@wwwdotorg.org> <20130721110807.GC24303@roeck-us.net>
In-Reply-To: <20130721110807.GC24303@roeck-us.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2013 04:08 AM, Guenter Roeck wrote:
> ... [a bunch of good points re: why DT shouldn't describe thermal
> profiles]

Yes, lots of good arguments there.

So, where/how in your opinion should thermal profiles be defined, and
how should they get into the kernel? The nice thing about DT is that
it's a single place that describes the platform, with a well-defined
method of getting that information into the kernel. What alternatives exist?

> Other but related subject .. from a thermal / hwmon driver's perspective, if
> such a driver supports thermal subsystem, it should just register itself as
> thermal sensor device, because that is what it is. If and how it is tied to
> cooling devices should be part of the thermal subsystem and be decided there.

For audio, we have individual DT nodes that represent individual
audio-related components such as audio controllers, audio CODECs, etc.
We also have a "virtual" node that describes how those components
interact and create a complete sound card. Would it make sense to do
something similar with thermal sensors and cooling devices; represent
them all individually, have them register themselves with the
thermal/hwmon subsystem as you describe, but then have another "system
level" node that describes how the system designer intended them to
interact?

If you don't think so, how would the kernel represent and gain that
higher-level knowledge?
