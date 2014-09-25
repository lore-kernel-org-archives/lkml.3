Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaIYP3v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:29:51 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:43881 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaIYP3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:29:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140925150757.GH32124@localhost>
References: <1411656197-26517-1-git-send-email-octavian.purdila@intel.com>
	<1411656197-26517-4-git-send-email-octavian.purdila@intel.com>
	<20140925150757.GH32124@localhost>
Date: Thu, 25 Sep 2014 18:29:48 +0300
Message-ID: <CAE1zotLcBNe7M_303qcHa8DQg9B17m516hUN5-CoZ2qweawXuQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mfd: viperboard: remove unused platform_device
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 6:07 PM, Johan Hovold <johan@kernel.org> wrote:
> On Thu, Sep 25, 2014 at 05:43:17PM +0300, Octavian Purdila wrote:
>
> Where's the commit message body?
>
>> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
>> ---
>>  drivers/mfd/viperboard.c       | 1 -
>>  include/linux/mfd/viperboard.h | 1 -
>>  2 files changed, 2 deletions(-)
>>
>> diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
>> index 57fac1d..1e7c316 100644
>> --- a/drivers/mfd/viperboard.c
>> +++ b/drivers/mfd/viperboard.c
>> @@ -74,7 +74,6 @@ static int vprbrd_probe(struct usb_interface *interface,
>>
>>       /* save our data pointer in this interface device */
>>       usb_set_intfdata(interface, vb);
>> -     dev_set_drvdata(&vb->pdev.dev, vb);
>
> This looks ok, as the subdrivers are accessing the driver data via the
> usb-interface (their parent) device.
>
> You verified that too, right?

Yes, I checked that the pdev field of struct vpbrd is not used in the
rest of the drivers.

>
>>
>>       /* get version information, major first, minor then */
>>       pipe = usb_rcvctrlpipe(vb->usb_dev, 0);
>> diff --git a/include/linux/mfd/viperboard.h b/include/linux/mfd/viperboard.h
>> index af928d0..afc14ed 100644
>> --- a/include/linux/mfd/viperboard.h
>> +++ b/include/linux/mfd/viperboard.h
>> @@ -104,7 +104,6 @@ struct vprbrd {
>>       struct usb_device *usb_dev; /* the usb device for this device */
>>       struct mutex lock;
>>       u8 *buf;
>> -     struct platform_device pdev;
>>  };
>>
>>  #endif /* __MFD_VIPERBOARD_H__ */
>
> Still feels like the kind of clean up that should have a Tested-by.
>

Unfortunately I do not have access to hardware to test.
