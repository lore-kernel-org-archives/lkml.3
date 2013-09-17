Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab3IQOYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 10:24:00 -0400
Received: from smtp.newsguy.com ([74.209.136.69]:50352 "EHLO smtp.newsguy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab3IQOX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 10:23:57 -0400
Message-ID: <523865DE.3030406@newsguy.com>
Date: Tue, 17 Sep 2013 07:23:26 -0700
From: Mike Dunn <mikedunn@newsguy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: thierry.reding@gmail.com, Richard Purdie <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pwm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Robert Jarzmik <robert.jarzmik@free.fr>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] pwm-backlight: allow for non-increasing brightness levels
References: <1379010952-8928-1-git-send-email-mikedunn@newsguy.com> <20130917093622.GB30088@pengutronix.de>
In-Reply-To: <20130917093622.GB30088@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 02:36 AM, Sascha Hauer wrote:
> Hi Mike,
> 
> On Thu, Sep 12, 2013 at 11:35:52AM -0700, Mike Dunn wrote:
>> Currently the driver assumes that the values specified in the brightness-levels
>> device tree property increase as they are parsed from left to right.  But boards
>> that invert the signal between the PWM output and the backlight will need to
>> specify decreasing brightness-levels.  This patch removes the assumption that
>> the last element of the array is the max value, and instead searches the array
>> for the max value and uses that as the normalizing value when determining the
>> duty cycle.
> 
> Note there's also support for inverted PWMs in the PWM framework
> provided your hardware supports this.


Yes, and in fact my first solution was to implement simulated polarity inversion
in the pwm driver, but that was shot down because polarity inversion is not
actually supported by the pwm hardware.  My inverter is external in the path
between the pwm output and the backlight.  Not sure of the reason for its presence.

Thanks,
Mike

