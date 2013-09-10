Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3IJEOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 00:14:00 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44154 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab3IJEN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 00:13:59 -0400
Message-ID: <522E9C84.9070405@wwwdotorg.org>
Date: Mon, 09 Sep 2013 22:13:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Wei Ni <wni@nvidia.com>, Mark Brown <broonie@kernel.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
References: <1378722552-10357-1-git-send-email-wni@nvidia.com> <1378722552-10357-2-git-send-email-wni@nvidia.com> <20130909111242.GW29403@sirena.org.uk> <522DB253.6000707@roeck-us.net> <20130909135022.GZ29403@sirena.org.uk> <20130909155043.GA18975@roeck-us.net> <522E9059.3070305@nvidia.com> <522E93D6.2010304@roeck-us.net> <522E94AE.7000804@wwwdotorg.org> <522E97CE.4070300@roeck-us.net>
In-Reply-To: <522E97CE.4070300@roeck-us.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 09:53 PM, Guenter Roeck wrote:
> On 09/09/2013 08:40 PM, Stephen Warren wrote:
>> On 09/09/2013 09:36 PM, Guenter Roeck wrote:
...
>>> My understanding is that by adding regulator support you essentially
>>> committed to adding regulators (if necessary dummy ones) for this driver
>>> to all those platforms. This is quite similar to other drivers in the
>>> same situation. Once you start along that route, you'll have to go it
>>> all the way.
>>
>> By using regulator_get_optional(), the regulator should be optional,
>> hence you only have to add it to platforms that need it.
>>
> 
> Earlier comments suggest that this is not the intended use case for
> regulator_get_optional().

Isn't the issue only whether the optional aspect of the regulator is
implemented by:

a) regulator_get_optional() returning failure, then the driver having to
check for that and either using or not-using the regulator.

b) regulator_get_optional() returning a dummy regulator automatically
when none is specified in DT or the regulator lookup table, and hence
the driver can always call regulator_enable/disable on the returned value.
