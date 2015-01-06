Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbbAFO0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:26:21 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:43984 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbbAFO0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:26:19 -0500
MIME-Version: 1.0
In-Reply-To: <001701d02992$37f595f0$a7e0c1d0$@co.kr>
References: <006101cf4812$c3ac1680$4b044380$@afoi.co.kr>
	<alpine.LNX.2.00.1403251156260.17500@pobox.suse.cz>
	<003a01cf488c$ab9c4400$02d4cc00$@afoi.co.kr>
	<alpine.LNX.2.00.1405201643120.1615@pobox.suse.cz>
	<001701d02992$37f595f0$a7e0c1d0$@co.kr>
Date: Tue, 6 Jan 2015 09:26:18 -0500
Message-ID: <CAN+gG=FqO4SBzB=ughh9P7QNfFvEJ4i_jooACPhiRJHGVP2xHw@mail.gmail.com>
Subject: Re: [PATCH] Add VID/PID for HID-type Multi-Touch Module of AFO CO., LTD.
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: kyhw <kyhw@afoi.co.kr>
Cc: Jiri Kosina <jkosina@suse.cz>, Henrik Rydberg <rydberg@euromail.se>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 6, 2015 at 4:21 AM, kyhw <kyhw@afoi.co.kr> wrote:
> Thanks.
>
> you are right. That's not necessary.
> We already processed.
>
> The final purpose of my approach is that the correct working of the AFO
> multi-Touch module in All distribution of Linux.
> Therefore, the inclusion of the VID,PID(AFO Touch Module) to the
> hid-multitouch module is basically needed also for old version of the Linux
> distribution.

Well, I'd like to keep hid-multitouch as clean as possible regarding
the specific vendor devices. So, if your device is already auto
detected in a let's say 3.18 and works as expected, (i.e. if the
CLS_SERIAL is automatically picked up), then I will oppose to your
patch. For the reference, I killed all the vendor specific useless
definitions in 0fa9c61618.
Distributions should either update to a more recent kernel (I think
the auto detection of CLS_SERIAL was in 3.10 or even before), or they
should cook their own support, or backport. There is no need to have a
useless list of devices in the upstream kernel.

Cheers,
Benjamin

>
> Ki.
>
> -----Original Message-----
> From: Jiri Kosina [mailto:jkosina@suse.cz]
> Sent: Tuesday, May 20, 2014 11:44 PM
> To: YongHwan Ki
> Cc: rydberg@euromail.se; linux-input@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] Add VID/PID for HID-type Multi-Touch Module of AFO CO.,
> LTD.
>
> On Wed, 26 Mar 2014, YongHwan Ki wrote:
>
>> Sorry, I woud like to add the AFO defines in the Linux Kernel.
>> No afo defines exists in the current kernel tree.
>> I correctly changed the log for adding the afo defines.
>>
>> Kernel Version : linux-3.14.rc7
>> Signed-off-by: Yonghwan Ki <kyhw@afoi.co.kr>
>>
>> diff -uprN -X Documentation/dontdiff ./drivers/hid/hid-core.c
> ../linux-3.14-rc7m/drivers/hid/hid-core.c
>> --- ./drivers/hid/hid-core.c  2014-03-17 10:51:24.000000000 +0900
>> +++ ../linux-3.14-rc7m/drivers/hid/hid-core.c 2014-03-21
> 17:41:51.846939444 +0900
>> @@ -1881,6 +1881,8 @@ static const struct hid_device_id hid_ha
>>       { HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0005) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_ZEROPLUS, 0x0030) },
>>       { HID_USB_DEVICE(USB_VENDOR_ID_ZYDACRON,
>> USB_DEVICE_ID_ZYDACRON_REMOTE_CONTROL) },
>> +     { HID_USB_DEVICE(USB_VENDOR_ID_AFO, USB_DEVICE_ID_AFO_TCM) },
>> +     { HID_USB_DEVICE(USB_VENDOR_ID_AFO, USB_DEVICE_ID_AFO_THM) },
>
> Is this really necessary? Why doesn't HID_DG_CONTACTID matching work for the
> to automatically trigger HID_GROUP_MULTITOUCH-based binding?
>
> --
> Jiri Kosina
> SUSE Labs
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
