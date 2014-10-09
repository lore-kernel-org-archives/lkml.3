Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaJIBvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 21:51:09 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:43602 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaJIBu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 21:50:58 -0400
MIME-Version: 1.0
In-Reply-To: <20141008113735.GQ23154@mwanda>
References: <20141008111356.GA22023@devel>
	<20141008113735.GQ23154@mwanda>
Date: Thu, 9 Oct 2014 10:50:57 +0900
Message-ID: <CAHb8M2DQQ6hfDDxqcOSX-h6RD3Jp8nqM5bycFOh3sAzX4tiHYA@mail.gmail.com>
Subject: Re: [PATCH 3/3] staging: dgap: introduce dgap_stop()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>,
        devel <devel@driverdev.osuosl.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dan

2014-10-08 20:37 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> All three of these patches are good and a nice improvement.  This one is
> a good bugfix.  I have some notes for later, though below.
>
> On Wed, Oct 08, 2014 at 08:13:56PM +0900, Daeseok Youn wrote:
>> diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
>> index 7c79fe6..00f34b5 100644
>> --- a/drivers/staging/dgap/dgap.c
>> +++ b/drivers/staging/dgap/dgap.c
>> @@ -71,6 +71,7 @@ MODULE_DESCRIPTION("Driver for the Digi International EPCA PCI based product lin
>>  MODULE_SUPPORTED_DEVICE("dgap");
>>
>>  static int dgap_start(void);
>> +static void dgap_stop(void);
>
> These kinds of forward declarations are annoying.  The whole file needs
> to be re-arranged so that we don't have to deal with them.
OK. I will try to re-arrange and remove forward declarations.

>
>> @@ -561,6 +563,21 @@ failed_class:
>>       return rc;
>>  }
>>
>> +static void dgap_stop(void)
>> +{
>> +     ulong lock_flags;
OK. I will send this patch again after changing ulong to "unsigned long".
>
> This is non-standard.  Traditionally it would be:
>
>         unsigned long flags;
>
> regards,
> dan carpenter

Thanks

regards,
Daeseok Youn
>
