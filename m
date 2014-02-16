Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaBPNoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 08:44:22 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:57771 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaBPNoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 08:44:10 -0500
MIME-Version: 1.0
In-Reply-To: <20140215150345.GD2579@katana>
References: <1392300547-23365-1-git-send-email-ulf.hansson@linaro.org>
	<20140215150345.GD2579@katana>
Date: Sun, 16 Feb 2014 14:44:07 +0100
Message-ID: <CAPDyKFrt6QJVSypP5iD_oVxRUvNhzxGcbZ703zR1K8gwJ5uCeQ@mail.gmail.com>
Subject: Re: [PATCH V2 11/17] i2c: nomadik: Convert to devm functions
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Chris Ball <chris@printf.net>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 February 2014 16:03, Wolfram Sang <wsa@the-dreams.de> wrote:
> On Thu, Feb 13, 2014 at 03:09:02PM +0100, Ulf Hansson wrote:
>> Use devm_* functions to simplify code and error handling.
>>
>> Cc: Alessandro Rubini <rubini@unipv.it>
>> Cc: Linus Walleij <linus.walleij@linaro.org>
>> Cc: Wolfram Sang <wsa@the-dreams.de>
>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>> ---
>>
>> Changes in v2:
>>       Rebased on top of latest i2c-nomadik branch.
>
> Since this depends on Linus' patch already, I think it would be cleaner
> if I pick this kinda unrelated (but wanted) devm patch, and ack the
> PM stuff. If this for some reason makes things more complicated, I can
> also simply ack this one.

I think we will end up having merge conflicts, especially for the
changes in the probe function if we decide to split it.

Would a way forward be to let you carry all the patches through your
tree? I believe all but patch 17 can be safely merged. It is only this
one that depends on the changes in the amba bus, so we can put this
one on hold for a while.

Another option would be if you drop Linus' patch from you branch and
let him collect all the patches in a pull request instead?

I happy with whatever we thinks are easiest. :-)

>
>> -     dev->virtbase = ioremap(adev->res.start, resource_size(&adev->res));
>> +     dev->virtbase = devm_ioremap(&adev->dev, adev->res.start,
>> +                             resource_size(&adev->res));
>>       if (!dev->virtbase) {
>>               ret = -ENOMEM;
>
> IS_ERR()!

Will fix in a v2!

>

Thanks!

Kind regards
Ulf Hansson
