Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaKCUlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:41:46 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:53054 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbaKCUlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:41:42 -0500
MIME-Version: 1.0
In-Reply-To: <20141103203230.GV6890@mwanda>
References: <1415044253-18734-1-git-send-email-benjamin.tissoires@redhat.com>
	<20141103203230.GV6890@mwanda>
Date: Mon, 3 Nov 2014 15:41:40 -0500
Message-ID: <CAN+gG=EUPxERcaPjqnDYNJUeQeWxHtJdRiAmyeb4b2g0W_yHqg@mail.gmail.com>
Subject: Re: [PATCH 1/2] HID: logitech-hidpp: fix negated returns
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 3:32 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Mon, Nov 03, 2014 at 02:50:52PM -0500, Benjamin Tissoires wrote:
>> @@ -524,8 +541,11 @@ static int hidpp_touchpad_get_raw_info(struct hidpp_device *hidpp,
>>       ret = hidpp_send_fap_command_sync(hidpp, feature_index,
>>               CMD_TOUCHPAD_GET_RAW_INFO, NULL, 0, &response);
>>
>> -     if (ret)
>> -             return -ret;
>> +     if (ret > 0) {
>> +             hid_err(hidpp->hid_dev, "%s: received protocol error 0x%02x\n",
>> +                     __func__, ret);
>> +             return -EPROTO;
>> +     }
>
> We should handle -ENOMEM and -EINVAL here as well.  Something like:
>
>         if (ret > 0) {
>                 hid_err(hidpp->hid_dev, "%s: received protocol error 0x%02x\n",
>                         __func__, ret);
>                 ret = -EPROTO;
>         }
>         if (ret)
>                 return ret;

Ouch. my bad...
No, I don't have any excuses for that.

Thanks for the review.

Cheers,
Benjamin
