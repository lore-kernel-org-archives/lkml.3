Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaBCTUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:20:01 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:58845 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaBCTT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:19:59 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4RWXXXYMSHFnrMubvqjJDu4tE3ikKsrhNfEUXdNASdcgA@mail.gmail.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4RWXXXYMSHFnrMubvqjJDu4tE3ikKsrhNfEUXdNASdcgA@mail.gmail.com>
Date: Mon, 3 Feb 2014 14:19:57 -0500
Message-ID: <CAN+gG=FtkmTKNTwM3Jbb4Cfw0g5kgz2aaGN-mWU0FfHmTnW1BQ@mail.gmail.com>
Subject: Re: [PATCH 00/11] HID: spring cleaning
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Frank Praznik <frank.praznik@oh.rr.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 11:48 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Sun, Feb 2, 2014 at 5:50 AM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> Hi guys,
>>
>> This is an attempt to complete the branch for-3.15/ll-driver-new-callbacks:
>> - try to implement as much as possible ll_driver callbacks (some are still
>>   missing, but I did not had the time to complete it)
>> - add inliners hid_hw_* for all the ll_driver callbacks
>> - remove transport dependant callbacks in struct hid_device
>> - remove the so called "obsolete" hidinput_input_event handler which was used
>>   in 2/4 transport drivers
>>
>> Bonus point: 14 files changed, 213 insertions(+), 272 deletions(-)
>> Yay!
>>
>> I made sure I kept the PS3 controller working and the LEDs (on logitech-dj and
>> on bluetooth keyboard) working. The rest do not mostly need further testing,
>> the code path did not changed. But still, a review (and some tests) would be a
>> good idea :)
>
> Thanks a lot! Looks all good except for the uhid and i2c changes. But
> I have commented on those.

Thanks David for the review. Very appreciated.

Jiri, I think the simpler way to handle this is that I send out a v2
of the patches with the reviewed-by David:
I will drop 1, 2 and 11 and rework a little on 4 (hid-logitech-dj).

Then, I'll send out the second series where I will remove
hid_output_raw_report, implement a generic .request() on top of
.raw_request(), and I have some more cleanup to come (less aggressive
this time I think).

Cheers,
Benjamin

>
> Cheers
> David
>
>> Cheers,
>> Benjamin
>>
>> PS: obviously, this goes on top on the branch for-3.15/ll-driver-new-callbacks
>>
>> Benjamin Tissoires (11):
>>   HID: uHID: implement .raw_request
>>   HID: i2c-hid: implement ll_driver transport-layer callbacks
>>   HID: add inliners for ll_driver transport-layer callbacks
>>   HID: logitech-dj: remove hidinput_input_event
>>   HID: HIDp: remove hidp_hidinput_event
>>   HID: remove hidinput_input_event handler
>>   HID: HIDp: remove duplicated coded
>>   HID: usbhid: remove duplicated code
>>   HID: remove hid_get_raw_report in struct hid_device
>>   HID: introduce helper to access hid_output_raw_report()
>>   HID: move hid_output_raw_report to hid_ll_driver
>>
>>  drivers/hid/hid-input.c        |  12 ++---
>>  drivers/hid/hid-lg.c           |   6 ++-
>>  drivers/hid/hid-logitech-dj.c  | 101 +++++++++++++---------------------
>>  drivers/hid/hid-magicmouse.c   |   2 +-
>>  drivers/hid/hid-sony.c         |  19 +++++--
>>  drivers/hid/hid-thingm.c       |   4 +-
>>  drivers/hid/hid-wacom.c        |  16 +++---
>>  drivers/hid/hid-wiimote-core.c |   4 +-
>>  drivers/hid/hidraw.c           |  11 ++--
>>  drivers/hid/i2c-hid/i2c-hid.c  |  27 +++++++++-
>>  drivers/hid/uhid.c             |  20 ++++++-
>>  drivers/hid/usbhid/hid-core.c  |  67 +++++------------------
>>  include/linux/hid.h            |  77 ++++++++++++++++++++++----
>>  net/bluetooth/hidp/core.c      | 119 +++++------------------------------------
>>  14 files changed, 213 insertions(+), 272 deletions(-)
>>
>> --
>> 1.8.3.1
>>
