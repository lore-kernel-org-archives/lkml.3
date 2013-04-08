Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936078Ab3DHNtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 09:49:09 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:58056 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935886Ab3DHNtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 09:49:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130408122056.GG9243@opensource.wolfsonmicro.com>
References: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
	<1363157014-9615-5-git-send-email-ks.giri@samsung.com>
	<20130401125744.GG18636@opensource.wolfsonmicro.com>
	<CAKrE-Kd+YAFmteDdh3odtV+YU1=OjoMuQV9usF4NmUse+TXhTg@mail.gmail.com>
	<20130408101530.GC9243@opensource.wolfsonmicro.com>
	<CAKrE-KevVramLc1n_9kcfHVb=RKT_kexQ8iUP-5+BL3wxpMPbQ@mail.gmail.com>
	<20130408122056.GG9243@opensource.wolfsonmicro.com>
Date: Mon, 8 Apr 2013 19:19:05 +0530
Message-ID: <CAKrE-KcMy1qzzg1JXqBOvAJTdQM3rLU6dHoQRnyryLz4p0rpaA@mail.gmail.com>
Subject: Re: [PATCH V3 4/5] spi: s3c64xx: Added provision for dedicated cs pin
From: Girish KS <girishks2000@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: spi-devel-general@lists.sourceforge.net,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 5:50 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Apr 08, 2013 at 05:15:26PM +0530, Girish KS wrote:
>> On Mon, Apr 8, 2013 at 3:45 PM, Mark Brown
>
>> > Two options here, one is to just assume nobody will use GPIO 0 and the
>> > other is to set the number appopriately during probe so that only probe
>> > needs to worry about the issue.
>>
>> In the second option if the gpio number is set in the probe, then we
>> are overwriting the
>> actual gpio number assigned in the platform data.
>> If I move the cs_gpio from the platform data to controller private
>> data then the dependency
>> on other platforms can be removed, but still the check (true or false)
>> before setting the gpio
>> line will remain. If agreed upon this i can go ahead and post the patch
>
> I think logic in probe should be fine, it just felt really cumbersome
> having this on every single use but doing it once on probe ought to be
> OK.

I will move the populating cs_gpio logic to probe. But the enable_cs
and disable_cs will have the
check before calling the gpio_set_value api (because it takes cs-line
as a parameter),
