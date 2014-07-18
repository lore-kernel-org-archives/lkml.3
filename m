Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946008AbaGRTzF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:55:05 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:63875 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbaGRTzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:55:03 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1407181509210.979-100000@iolanthe.rowland.org>
References: <1405704880-10036-1-git-send-email-xerofoify@gmail.com>
	<Pine.LNX.4.44L0.1407181509210.979-100000@iolanthe.rowland.org>
Date: Fri, 18 Jul 2014 15:55:02 -0400
Message-ID: <CAPDOMViyAun+rV7ERY_FLM6vP_80FuUqOx4OOfp_GiAA7N6+sg@mail.gmail.com>
Subject: Re: [PATCH] usb-core: Remove Fix mes in file hcd.c
From: Nick Krause <xerofoify@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>, mail@beyermatthias.de,
        hdegoede@redhat.com, dan.j.williams@intel.com,
        valentine.barshak@cogentembedded.com,
        Ming Lei <ming.lei@canonical.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 3:09 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 18 Jul 2014, Nicholas Krause wrote:
>
>> I am removing two fix mes in this file as after dicussing then it  seems
>> there is no reason to check against Null for usb_device as it can never
>> be NULL and this is check is therefore not needed.
>>
>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>> ---
>>  drivers/usb/core/hcd.c | 4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
>> index bec31e2..487abcf 100644
>> --- a/drivers/usb/core/hcd.c
>> +++ b/drivers/usb/core/hcd.c
>> @@ -855,8 +855,6 @@ static ssize_t authorized_default_show(struct device *dev,
>>       struct usb_bus *usb_bus = rh_usb_dev->bus;
>>       struct usb_hcd *usb_hcd;
>>
>> -     if (usb_bus == NULL)    /* FIXME: not sure if this case is possible */
>> -             return -ENODEV;
>>       usb_hcd = bus_to_hcd(usb_bus);
>>       return snprintf(buf, PAGE_SIZE, "%u\n", usb_hcd->authorized_default);
>>  }
>> @@ -871,8 +869,6 @@ static ssize_t authorized_default_store(struct device *dev,
>>       struct usb_bus *usb_bus = rh_usb_dev->bus;
>>       struct usb_hcd *usb_hcd;
>>
>> -     if (usb_bus == NULL)    /* FIXME: not sure if this case is possible */
>> -             return -ENODEV;
>>       usb_hcd = bus_to_hcd(usb_bus);
>>       result = sscanf(buf, "%u\n", &val);
>>       if (result == 1) {
>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>
Great to hear this is going through :).
Nick
