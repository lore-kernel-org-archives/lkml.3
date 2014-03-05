Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbaCEVJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:09:40 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:38139 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbaCEVJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:09:38 -0500
MIME-Version: 1.0
In-Reply-To: <ba12abe9-5f40-4351-8dc0-76008931fc0d@email.android.com>
References: <1393633237-26496-1-git-send-email-benjamin.tissoires@redhat.com>
	<1393633237-26496-3-git-send-email-benjamin.tissoires@redhat.com>
	<alpine.LNX.2.00.1403041445080.30402@pobox.suse.cz>
	<20140304141838.GD24154@mail.corp.redhat.com>
	<ba12abe9-5f40-4351-8dc0-76008931fc0d@email.android.com>
Date: Wed, 5 Mar 2014 16:09:36 -0500
Message-ID: <CAN+gG=FOzo90DbMqp-Dh-OF4oCuBzXC-nwODPkNk62CV_usDxQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] HID: cp2112: remove the last hid_output_raw_report() call
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: David Barksdale <dbarksdale@uplogix.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2014 at 1:11 PM, David Barksdale <dbarksdale@uplogix.com> wrote:
> Sorry for the delay, hid_hw_output_report() is the correct function.

No worries and thanks for the tests.

This saves me some time!

Sending the v2 right away.

Cheers,
Benjamin

>
>
> On March 4, 2014 8:18:38 AM CST, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>>
>> On Mar 04 2014 or thereabouts, Jiri Kosina wrote:
>>>
>>>  On Fri, 28 Feb 2014, Benjamin Tissoires wrote:
>>>
>>>>
>>>>  I don't have access to the device, so I copied/pasted the code
>>>>  from hidraw.
>>>>
>>>>  Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>>>>  ---
>>>>   drivers/hid/hid-cp2112.c | 16 +++++++++++++++-
>>>>   1 file changed, 15 insertions(+), 1 deletion(-)
>>>>
>>>>  diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
>>>>  index 860db694..c4f87bd 100644
>>>>  --- a/drivers/hid/hid-cp2112.c
>>>>  +++ b/drivers/hid/hid-cp2112.c
>>>>  @@ -290,7 +290,21 @@ static int cp2112_hid_output(struct hid_device
>>>> *hdev, u8 *data, size_t count,
>>>>    if (!buf)
>>>>     return -ENOMEM;
>>>>
>>>>  - ret = hdev->hid_output_raw_report(hdev, buf, count, report_type);
>>>>  + /* Fixme: test which function is actually called for output reports
>>>> */
>>>
>>>
>>>  I don't completely understand this Fixme (oh, and please spell it as
>>>  'FIXME:' so that we are consistent with all the other instances), could
>>>  you please elaborate?
>>
>>
>> Well, sorry:
>> As I said, this part is a copy/paste of what is in hidraw. However, this
>> just reflect that we don't know how the device actually behave, which is
>> not very elegant. I have currently no clues of which function will be
>> actually called for output reports: hid_hw_output_report() or
>> hid_hw_raw_request(). Once we got the confirmation of which function is
>> called, we could make the path more straightforward.
>>
>> I bought one of these (it may help debugging some Synaptics devices),
>> and I'll receive it by the end of the week. So by next week, we should
>> get the actual code path and remove this FIXME.
>>
>> I need to send a v2 of hid-sony in any cases, so I guess you should not
>> pull these 4 patches right away. If you prefer having this in linux-next,
>> the sooner, I can also send the v2 right away, and we will fix this
>> cp2112 driver next week.
>>
>> Cheers,
>> Benjamin
>>
>>>
>>>  Thanks,
>>>
>>>  --
>>>  Jiri Kosina
>>>  SUSE Labs
>
>
> --
> Sent from my Android device with K-9 Mail. Please excuse my brevity.
