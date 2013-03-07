Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab3CGOaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:30:52 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:64335 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab3CGOau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:30:50 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1303071526040.28677@pobox.suse.cz>
References: <1361979498-24446-1-git-send-email-benjamin.tissoires@redhat.com>
	<1361979498-24446-2-git-send-email-benjamin.tissoires@redhat.com>
	<alpine.LNX.2.00.1303071526040.28677@pobox.suse.cz>
Date: Thu, 7 Mar 2013 15:30:48 +0100
Message-ID: <CAN+gG=EzYiUujj6XB96KF4c1OEQE65KeNeaufGOzykVgvG4Qjg@mail.gmail.com>
Subject: Re: [RFC 1/2] HID: Extend the interface with idle requests
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        David Herrmann <dh.herrmann@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 3:26 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Wed, 27 Feb 2013, Benjamin Tissoires wrote:
>
>> Some drivers send the idle command directly to underlying device,
>> creating an unwanted dependency on the underlying transport layer.
>> This patch adds hid_hw_idle() to the interface, thereby removing
>> usbhid from the lion share of the drivers.
>>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  drivers/hid/usbhid/hid-core.c | 15 +++++++++++++++
>>  include/linux/hid.h           | 19 +++++++++++++++++++
>>  2 files changed, 34 insertions(+)
>>
>> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
>> index 420466b..effcd3d 100644
>> --- a/drivers/hid/usbhid/hid-core.c
>> +++ b/drivers/hid/usbhid/hid-core.c
>> @@ -1253,6 +1253,20 @@ static void usbhid_request(struct hid_device *hid, struct hid_report *rep, int r
>>       }
>>  }
>>
>> +static int usbhid_idle(struct hid_device *hid, int report, int idle,
>> +             int reqtype)
>
> Where does the need for passing the report argument come from please?

Well, I haven't checked in the USB spec, but hid_set_idle() in
usbhid/hid-core.c does require the reportID, so I add it to the
request.
I just gave a quick look at the HID/I2C spec, and it also requires the
report ID. The set_idle request is report specific.

Benjamin

>
> --
> Jiri Kosina
> SUSE Labs
