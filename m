Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaCGIUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:20:05 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52153 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaCGIUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:20:04 -0500
MIME-Version: 1.0
In-Reply-To: <20140307081441.GD4774@mwanda>
References: <2118769.zIlmIgrC0S@daeseok-laptop.cloud.net>
	<20140307081441.GD4774@mwanda>
Date: Fri, 7 Mar 2014 17:20:03 +0900
Message-ID: <CAHb8M2CRC=OwNpDkNwrP77owv4u_X5M6fD00AfeKnnN+aMT5QA@mail.gmail.com>
Subject: Re: [PATCH] staging: frontier: fix memory leak in usb_alphatrack_probe()
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, d <d@teklibre.com>,
        paul.gortmaker@windriver.com,
        "sara.bird.iar" <sara.bird.iar@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK. I will remove that comment and send again.

Thanks.
Daeseok Youn.

2014-03-07 17:14 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Fri, Mar 07, 2014 at 05:02:25PM +0900, Daeseok Youn wrote:
>>
>> oldi_buffer and write_buffer need to free when usb_alphatrack_delete()
>> is called.
>>
>> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
>> ---
>>  drivers/staging/frontier/alphatrack.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
>> index edd5cef..4d630da 100644
>> --- a/drivers/staging/frontier/alphatrack.c
>> +++ b/drivers/staging/frontier/alphatrack.c
>> @@ -208,6 +208,8 @@ static void usb_alphatrack_delete(struct usb_alphatrack *dev)
>>       kfree(dev->ring_buffer);
>>       kfree(dev->interrupt_in_buffer);
>>       kfree(dev->interrupt_out_buffer);
>> +     kfree(dev->oldi_buffer);
>> +     kfree(dev->write_buffer);
>>       kfree(dev);             /* fixme oldi_buffer */
>                                    ^^^^^^^^^^^^^^^^^
> Remove this comment now?
>
> regards,
> dan carpenter
>
