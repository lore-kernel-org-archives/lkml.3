Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab3CFEUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 23:20:55 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54219 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3CFEUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 23:20:53 -0500
Message-ID: <5136C423.3070400@wwwdotorg.org>
Date: Tue, 05 Mar 2013 21:20:51 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>
CC: Andrew Chew <achew@nvidia.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v3] pwm_bl: Add support for backlight enable regulator
References: <1362527485-8611-1-git-send-email-achew@nvidia.com> <5136A781.2050303@nvidia.com>
In-Reply-To: <5136A781.2050303@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 07:18 PM, Alex Courbot wrote:
> On 03/06/2013 08:51 AM, Andrew Chew wrote:
>> The backlight enable regulator is specified in the device tree node for
>> backlight.

>> diff --git a/include/linux/pwm_backlight.h

>>   struct platform_pwm_backlight_data {
>>       int pwm_id;
>> +    struct regulator *en_supply;
> 
> You should not have this here. Platform data is supposed to provide the
> necessary information for the driver to resolve the resource - not the
> resource itself.
...
> There is one catch though: in case you don't want to use a regulator,
> and thus have none defined, regulator_get() will return -EPROBE_DEFER,
> so you cannot distinguish between "no regulator needed" and "supplier
> not ready yet" and your driver will always *require* a regulator. So at
> the end of the day you might still need a "use_enable_regulator" in the
> platform data to explicitly ask for probe() to look for it. This
> variable would also be set by parse_dt() if the "enable-supply" property
> exists.

A driver that requires a regulator always requires that regulator. If a
particular board doesn't have SW control over the power source, you're
supposed to provide a dummy (fixed) regulator so that the driver doesn't
care about the difference.
