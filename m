Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3LUOZw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 09:25:52 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:54086 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab3LUOZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 09:25:50 -0500
MIME-Version: 1.0
In-Reply-To: <20131221074900.GA6849@S2101-09.ap.freescale.net>
References: <1387546930-32513-1-git-send-email-festevam@gmail.com>
	<20131221074900.GA6849@S2101-09.ap.freescale.net>
Date: Sat, 21 Dec 2013 12:25:50 -0200
Message-ID: <CAOMZO5Dg-NJ+rvFM=8Pb8ChcUMu803zqCX-1XMJJ6TBqarczfw@mail.gmail.com>
Subject: Re: [PATCH 1/2] regulator: anatop-regulator: Remove unneeded check
From: Fabio Estevam <festevam@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Anson Huang <b20788@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 5:49 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Fri, Dec 20, 2013 at 11:42:09AM -0200, Fabio Estevam wrote:
>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> At the 'anatop_probe_end' error path, the variable 'ret' is known to be
>> non-zero, so there is no need to check it.
>>
>> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
>> ---
>>  drivers/regulator/anatop-regulator.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
>> index c734d09..0a3597b 100644
>> --- a/drivers/regulator/anatop-regulator.c
>> +++ b/drivers/regulator/anatop-regulator.c
>> @@ -211,8 +211,7 @@ static int anatop_regulator_probe(struct platform_device *pdev)
>>       platform_set_drvdata(pdev, rdev);
>>
>>  anatop_probe_end:
>> -     if (ret)
>> -             kfree(sreg->name);
>> +     kfree(sreg->name);
>
> NAK
>
> With the change, a successful probe will end up with calling this
> kfree() as well.

I see. Then we can do this instead, so that the successful probe and
the error path are clearer:

--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -210,9 +210,10 @@ static int anatop_regulator_probe(struct platform_device *p

        platform_set_drvdata(pdev, rdev);

+       return 0;
+
 anatop_probe_end:
-       if (ret)
-               kfree(sreg->name);
+       kfree(sreg->name);

        return ret;
 }


Regards,

Fabio Estevam
