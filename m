Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbaAYUY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 15:24:58 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42937 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486AbaAYUY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 15:24:56 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1401251035570.7061-100000@netrider.rowland.org>
References: <20140125150559.GN16455@hansolo.jdub.homelinux.org>
	<Pine.LNX.4.44L0.1401251035570.7061-100000@netrider.rowland.org>
Date: Sat, 25 Jan 2014 15:24:55 -0500
X-Google-Sender-Auth: FwHeTjrqXp-Y3KofvO-_4eALqiE
Message-ID: <CA+5PVA7iFPHXz1Mn+Ri07Ajr1FYpm1ubVoq-twrFC1Rbu=p_HA@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: Quiet unable to find transceiver message
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        valentine.barshak@cogentembedded.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 10:37 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 25 Jan 2014, Josh Boyer wrote:
>
>> commit 1ae5799ef6317 ("usb: hcd: Initialize USB phy if needed") allows
>> the USB layer to initialize external PHYs if needed.  However, a PHY is
>> not needed in all cases.  The usb_get_phy_device function will print
>> an error message, "unable to find transceiver" but everything still
>> functions normally.
>>
>> Drop the severity of this message to pr_debug.
>>
>> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
>> ---
>>  drivers/usb/phy/phy.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
>> index e6f61e4..c7fe880 100644
>> --- a/drivers/usb/phy/phy.c
>> +++ b/drivers/usb/phy/phy.c
>> @@ -228,7 +228,7 @@ struct usb_phy *usb_get_phy_dev(struct device *dev, u8 index)
>>
>>       phy = __usb_find_phy_dev(dev, &phy_bind_list, index);
>>       if (IS_ERR(phy) || !try_module_get(phy->dev->driver->owner)) {
>> -             pr_err("unable to find transceiver\n");
>> +             pr_debug("unable to find transceiver\n");
>>               goto err0;
>>       }
>
> Wouldn't it make more sense to change this to dev_debug?  As it stands,
> the user has no idea which device is lacking a transceiver.

Quite possibly, yes.  I'm not overly familiar with the subsystem and
was just writing up what Felipe suggested.

> (The same is probably true for other log messages in this source file.)

I don't disagree, but I'd rather someone with more experience in the
USB subsystem do that kind of broader audit/change.  I'd be happy to
test.

josh
