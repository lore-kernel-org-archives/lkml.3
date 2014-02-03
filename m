Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbaBCVpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:45:19 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:49013 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaBCVpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:45:17 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402030939520.25794@ayla.of.borg>
References: <52EEF452.4060205@renesas.com>
	<alpine.DEB.2.02.1402030939520.25794@ayla.of.borg>
Date: Mon, 3 Feb 2014 15:45:16 -0600
Message-ID: <CAL_JsqK7F7a5PSoE1aZTna35wP1SXs4BbpWxsSyuT5b2Cd8cQA@mail.gmail.com>
Subject: Re: [PATCH] spi: rspi: fix build error when CONFIG_OF is not set
From: Rob Herring <robherring2@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 2:47 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>         Hi Shimoda-san,
>
> On Mon, 3 Feb 2014, Shimoda, Yoshihiro wrote:
>> This patch fixes an issue that the following build error happens when
>> the CONFIG_OF is not set:
>>
>> drivers/spi/spi-rspi.c: In function 'rspi_probe':
>> drivers/spi/spi-rspi.c:1203:26: error: 'rspi_of_match' undeclared (first use in this function)
>>
>> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>> ---
>>  This patch is based on the latest origin/topic/rspi branch in the spi.git.
>>
>>  drivers/spi/spi-rspi.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
>> index 34ad4bc..e5cfc3d 100644
>> --- a/drivers/spi/spi-rspi.c
>> +++ b/drivers/spi/spi-rspi.c
>> @@ -1164,6 +1164,7 @@ static int rspi_parse_dt(struct device *dev, struct spi_master *master)
>>       return 0;
>>  }
>>  #else
>> +#define rspi_of_match        NULL
>>  static inline int rspi_parse_dt(struct device *dev, struct spi_master *master)
>>  {
>>       return -EINVAL;
>> --
>> 1.7.1
>
> Thanks, obviously I missed that of_match_device() still uses the ID table
> parameter if CONFIG_OF=n :-(
>
> Below I have two alternative solutions:
>   1. Uses rspi_of_match() to nullify the ID table pointer, like is done in
>      the platform_driver structure,
>   2. Fixes it at the OF subsystem level, by nullifying the ID table pointer
>      inside of_match_device().
>
> If 2 is accepted, drivers don't have to care about this anymore.
>
> What do you think?

I'll apply the 2nd one.

Rob
