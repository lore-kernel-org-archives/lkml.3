Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaCaU7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:59:46 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49673 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaCaU7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:59:44 -0400
MIME-Version: 1.0
In-Reply-To: <CA+BWVUSS7VdiswgjXEMYHCed1xzz4ubCi89t7SF-1qG5=GzDUA@mail.gmail.com>
References: <1396286830-2795-1-git-send-email-benjamin.tissoires@redhat.com>
 <1396286830-2795-3-git-send-email-benjamin.tissoires@redhat.com> <CA+BWVUSS7VdiswgjXEMYHCed1xzz4ubCi89t7SF-1qG5=GzDUA@mail.gmail.com>
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Mon, 31 Mar 2014 15:59:23 -0500
Message-ID: <CA+BWVUSk1NEgghHqvbVPpEXZ4BwajPGw-uM84ceyZqdnQhJ15Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] HID: core: do not scan constant input report
To: linux-kernel@vger.kernel.org, linux-input <linux-input@vger.kernel.org>,
        derya.kiran@yahoo.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on Surface Pro 2 Type Cover 2 on kernel 3.15/multitouch rebased
on 3.14. The device is now handled by hid-generic and hid-sensor-hub
as expected.
There is a newer UEFI and touch cover firmware that I have not tried,
as you need windows update to get drivers for this device. I will try
and update my device to make sure we don't need any
quirks.

> On Mon, Mar 31, 2014 at 12:27 PM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> The Microsoft Surface Type/Touch Cover 2 is a fancy device which advertised
>> itself as a multitouch device but with constant input reports.
>> This way, hid_scan_report() gives the group MULTITOUCH to it, but
>> hid-multitouch can not handle it due to the constant collection ignored
>> by hid-input.
>>
>> To prevent such crap in the future, and while we do not fix this particular
>> device, make the scan_report coherent with hid-input.c, and ignore constant
>> input reports.
>>
>> CC: stable@vger.kernel.org # 3.12+
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>>  drivers/hid/hid-core.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>> index bb5c494..8a5384c 100644
>> --- a/drivers/hid/hid-core.c
>> +++ b/drivers/hid/hid-core.c
>> @@ -718,6 +718,9 @@ static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
>>         case HID_MAIN_ITEM_TAG_END_COLLECTION:
>>                 break;
>>         case HID_MAIN_ITEM_TAG_INPUT:
>> +               /* ignore constant inputs, they will be ignored by hid-input */
>> +               if (data & HID_MAIN_ITEM_CONSTANT)
>> +                       break;
>>                 for (i = 0; i < parser->local.usage_index; i++)
>>                         hid_scan_input_usage(parser, parser->local.usage[i]);
>>                 break;
>> --
>> 1.9.0
>>
