Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbaIEHkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:40:36 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:61739 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755943AbaIEHkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:40:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140902145435.GF16872@saruman.home>
References: <1409658558-12318-1-git-send-email-kiran.kumar@linaro.org>
	<20140902145435.GF16872@saruman.home>
Date: Fri, 5 Sep 2014 00:40:22 -0700
Message-ID: <CAAW3YpZJ0JrYL4OxJ18Vq1kVWVWN+XFRBkTbgDS5SFUQ6HUJqg@mail.gmail.com>
Subject: Re: [RFC v2 2/2] usb: phy: Temporarily hold wakeupsource on charger
 connect and disconnect events
From: Todd Poynor <toddpoynor@google.com>
To: balbi@ti.com
Cc: Kiran Kumar Raparthy <kiran.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Badhri Jagan Sridharan <badhri@google.com>,
        Ruchi Kandoi <kandoiruchi@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 7:54 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Sep 02, 2014 at 05:19:18PM +0530, Kiran Kumar Raparthy wrote:
...
>> diff --git a/drivers/usb/phy/otg-wakeupsource.c b/drivers/usb/phy/otg-wakeupsource.c
>> index fca2010..70fa05e 100644
>> --- a/drivers/usb/phy/otg-wakeupsource.c
>> +++ b/drivers/usb/phy/otg-wakeupsource.c
>> @@ -48,7 +48,7 @@ static void otgws_handle_event(struct usb_phy *otgws_xceiv, unsigned long event)
>>       case USB_EVENT_NONE:
>>       case USB_EVENT_ID:
>>       case USB_EVENT_CHARGER:
>> -             usb_drop_wsource(otgws_xceiv);
>> +             usb_temporary_hold_wsource(otgws_xceiv);
>
> looks like this won't work. You're holding the lock even on
> USB_EVEN_NONE. Why ?

It temporarily holds a timed wakeup source on USB disconnect events,
to allow the rest of the system time to react to the USB disconnection
(dropping host sessions, updating charger status, etc.) prior to
re-allowing suspend.


Todd
