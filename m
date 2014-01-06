Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbaAFGD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:03:26 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59902 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaAFGDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:03:25 -0500
MIME-Version: 1.0
In-Reply-To: <20140105060920.GE18213@core.coreip.homeip.net>
References: <1388884659-693-1-git-send-email-ethan.kernel@gmail.com>
	<20140105060920.GE18213@core.coreip.homeip.net>
Date: Mon, 6 Jan 2014 14:03:24 +0800
Message-ID: <CABawtvMAzGR5sPg3dbiu8OpR2Jpo8FAbNXqde5rx9i0oULvyqw@mail.gmail.com>
Subject: Re: [PATCH] [media] cx18: introduce a helper function to void array overrun
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: hans.verkuil@cisco.com, m.chehab@samsung.com,
        Greg KH <gregkh@linuxfoundation.org>, mchehab@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 5, 2014 at 2:09 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Ethan,
>
> On Sun, Jan 05, 2014 at 09:17:39AM +0800, Ethan Zhao wrote:
>> cx18_i2c_register() is called in cx18_init_subdevs() with index
>> greater than length of hw_bus array, that will cause array overrun,
>> introduce a helper cx18_get_max_bus_num() to void it.
>
> s/void/avoid/

Oops, typo.
>
>>
>> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
>> ---
>>  drivers/media/pci/cx18/cx18-driver.c | 2 +-
>>  drivers/media/pci/cx18/cx18-i2c.c    | 5 +++++
>>  drivers/media/pci/cx18/cx18-i2c.h    | 1 +
>>  3 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
>> index 6386ced..dadcd4a 100644
>> --- a/drivers/media/pci/cx18/cx18-driver.c
>> +++ b/drivers/media/pci/cx18/cx18-driver.c
>> @@ -856,7 +856,7 @@ static void cx18_init_subdevs(struct cx18 *cx)
>>       u32 device;
>>       int i;
>>
>> -     for (i = 0, device = 1; i < 32; i++, device <<= 1) {
>> +     for (i = 0, device = 1; i < cx18_get_max_bus_num(); i++, device <<= 1) {
>>
>>               if (!(device & hw))
>>                       continue;
>> diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
>> index 4af8cd6..e0e8193 100644
>> --- a/drivers/media/pci/cx18/cx18-i2c.c
>> +++ b/drivers/media/pci/cx18/cx18-i2c.c
>> @@ -108,6 +108,11 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
>>              -1 : 0;
>>  }
>>
>> +int cx18_get_max_bus_num()
>
> This should be "int cx18_get_max_bus_num(void)" since we are using C and
> not C++.
agree, no parameter function, f(void) much clearer than any parameters
function f() in C.
>
>> +{
>> +     return sizeof(hw_bus);
>
> I'd rather see
>
>         return ARRAY_SIZE(hw_bus);

Yes, looks better ! will send v2, thanks.
>
> Thanks.
>
> --
> Dmitry
