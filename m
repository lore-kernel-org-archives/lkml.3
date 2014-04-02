Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbaDBJlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 05:41:25 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:53493 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758042AbaDBJlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 05:41:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140402091334.GV6991@mwanda>
References: <1671118.MbmRfxWPeo@daeseok-laptop.cloud.net>
	<20140402091334.GV6991@mwanda>
Date: Wed, 2 Apr 2014 18:41:20 +0900
Message-ID: <CAHb8M2AN5Hx4Mn9uTnge2MQzyT7BD1XxM2edZyPdeCt-V91J5g@mail.gmail.com>
Subject: Re: [PATCH] staging: lirc: fix NULL pointer dereference
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: m.chehab@samsung.com, devel <devel@driverdev.osuosl.org>,
        Andreea Bernat <bernat.ada@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, jarod@wilsonet.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Martina Trompouki <mtrompou@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You are right. remove whole thing and send it again.

Thanks.
Daeseok Youn

2014-04-02 18:13 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Wed, Apr 02, 2014 at 05:18:39PM +0900, Daeseok Youn wrote:
>>
>> coccicheck says:
>>  drivers/staging/media/lirc/lirc_igorplugusb.c:226:15-21:
>> ERROR: ir is NULL but dereferenced.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/staging/media/lirc/lirc_igorplugusb.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/staging/media/lirc/lirc_igorplugusb.c b/drivers/staging/media/lirc/lirc_igorplugusb.c
>> index f508a13..0ef393b 100644
>> --- a/drivers/staging/media/lirc/lirc_igorplugusb.c
>> +++ b/drivers/staging/media/lirc/lirc_igorplugusb.c
>> @@ -223,8 +223,8 @@ static int unregister_from_lirc(struct igorplug *ir)
>>       int devnum;
>>
>>       if (!ir) {
>> -             dev_err(&ir->usbdev->dev,
>> -                     "%s: called with NULL device struct!\n", __func__);
>> +             printk(DRIVER_NAME "%s: called with NULL device struct!\n",
>> +                    __func__);
>
>
> It should be pr_err() or something.  But actually "ir" can't be NULL so
> just delete the whole condition.
>
>
>>               return -EINVAL;
>>       }
>
> regards,
> dan carpenter
>
