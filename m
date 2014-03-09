Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaCIDlB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 22:41:01 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:47182 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbaCIDk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 22:40:59 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4QRc+cwAJYFJg2F8WpSOrx2xXuPeiZYF6np_2C5CoqRqA@mail.gmail.com>
References: <1394054334-20438-1-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4QRc+cwAJYFJg2F8WpSOrx2xXuPeiZYF6np_2C5CoqRqA@mail.gmail.com>
Date: Sat, 8 Mar 2014 22:40:57 -0500
Message-ID: <CAN+gG=GUieLNqn7Gp2y958J48bRQ+BCQx2Lf-noa6eoqNGxeDA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] HID: ll transport cleanup: final round
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        David Barksdale <dbarksdale@uplogix.com>, Antonio Ospite <ao2@ao2.it>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2014 at 4:52 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> On Wed, Mar 5, 2014 at 10:18 PM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> Alright, this is the re-spin of the last round of transport cleanup.
>>
>> Some minor but important modifications are here, but nothing very enthousiastic.
>>
>> Thanks for the reviews and the tests so far.
>
> Apart from some minor comments on #1 and #2, this is:

Hmm, neither my mailboxes nor patchwork gives me your comments on #2...

By looking at the code, (assuming you mean the same comment that you
made on #1), this is not so obvious.
What we can do is add an arg to cp2112_hid_output() with the report
number (and pass it to hid_hw_raw_request() ). However, this function
is also used by cp2112_xfer(), and there is chances that I introduce a
bug if I am not careful enough.
I'd rather split cp2112_hid_output() in two, one for output reports,
and one for features (with the reportID as an arg). I'll send this one
after this series because I would like to do some more tests.

>
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
>

Thanks a lot!

Cheers,
Benjamin

> Thanks
> David
>
>> Cheers,
>> Benjamin
>>
>> Benjamin Tissoires (4):
>>   HID: cp2112: remove various hid_out_raw_report calls
>>   HID: cp2112: remove the last hid_output_raw_report() call
>>   HID: sony: do not rely on hid_output_raw_report
>>   HID: remove hid_output_raw_report transport implementations
>>
>>  drivers/hid/hid-cp2112.c      | 19 +++++++++-----
>>  drivers/hid/hid-sony.c        | 60 ++++++++++---------------------------------
>>  drivers/hid/hidraw.c          |  3 ++-
>>  drivers/hid/i2c-hid/i2c-hid.c | 14 ----------
>>  drivers/hid/uhid.c            |  1 -
>>  drivers/hid/usbhid/hid-core.c | 19 +++++---------
>>  include/linux/hid.h           | 21 ++-------------
>>  net/bluetooth/hidp/core.c     | 14 ----------
>>  8 files changed, 36 insertions(+), 115 deletions(-)
>>
>> --
>> 1.8.5.3
