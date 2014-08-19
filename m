Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaHSRAM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:00:12 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:45135 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbaHSRAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:00:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140819093244.GJ1660@lahna.fi.intel.com>
References: <1408380657-6718-1-git-send-email-acourbot@nvidia.com>
 <1408380657-6718-2-git-send-email-acourbot@nvidia.com> <20140819093244.GJ1660@lahna.fi.intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 19 Aug 2014 09:59:49 -0700
Message-ID: <CAAVeFuJ55jikMaNYNqTUVJ==9u+mQr0OtC89PZajCDVLF7TUug@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: acpi: normalize use of gpiochip_get_desc()
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 2:32 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Mon, Aug 18, 2014 at 09:50:56AM -0700, Alexandre Courbot wrote:
>> GPIO descriptors are changing from unique and permanent tokens to
>> allocated resources. Therefore gpiochip_get_desc() cannot be used as a
>> way to obtain a global GPIO descriptor anymore.
>>
>> This patch updates the gpiolib ACPI support code to keep and use the
>> descriptor returned by a centralized call to gpiochip_get_desc().
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>  drivers/gpio/gpiolib-acpi.c | 22 ++++++++++++++--------
>>  1 file changed, 14 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
>> index d62eaaa75397..9596a1023579 100644
>> --- a/drivers/gpio/gpiolib-acpi.c
>> +++ b/drivers/gpio/gpiolib-acpi.c
>> @@ -25,10 +25,12 @@ struct acpi_gpio_event {
>>       acpi_handle handle;
>>       unsigned int pin;
>>       unsigned int irq;
>> +     gpio_desc *desc;
>
> This needs to be
>         struct gpio_desc *desc;
>
>>  };

Oops apologies for this, I should have least have compiled a tree with
this patch on... >_<;

>
> Tested on Asus T100TA and nothing seems to break, so:
>
> Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thanks! Will send a v2 for Linus to merge, if he agrees with these two patches.
Alex.
