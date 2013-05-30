Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3E3NVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:21:15 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:64650 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab3E3NVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:21:04 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75VcpdQqd+evBNhwMGHvXwCoVdaXYdBqQeSDGwt25dLkpGQ@mail.gmail.com>
References: <1369817109-4277-1-git-send-email-benjamin.tissoires@redhat.com>
	<CAHp75VcpdQqd+evBNhwMGHvXwCoVdaXYdBqQeSDGwt25dLkpGQ@mail.gmail.com>
Date: Thu, 30 May 2013 15:21:02 +0200
Message-ID: <CAN+gG=ESjWJDfHN4KmMAnLUko-wCa8r0VzQmFYqDme5Jg+FszA@mail.gmail.com>
Subject: Re: [PATCH] HID: multitouch: prevent memleak with the allocated name
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Wed, May 29, 2013 at 10:12 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Wed, May 29, 2013 at 11:45 AM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> mt_free_input_name() was never called during .remove():
>> hid_hw_stop() removes the hid_input items in hdev->inputs, and so the
>> list is therefore empty after the call. In the end, we never free the
>> special names that has been allocated during .probe().
>>
>> Restore the original name before freeing it to avoid acessing already
>> freed pointer.
>>
>
>> I just spotted this one yesterday... My guess is that this way is safe (without
>> a locking mechanism to prevent accessing hi->input->name), but I'm not 100% sure.
>
> Hi Jiri, Benjamin.
>
> What do you think about patch I just sent?

Thanks for looking at this. My very first concern is that none of the
HID part has been devm-ized (this is on my todo-if-I-have-some-time
list). The input susbsystem has been devm-ized quite recently, so this
should be possible now.
So, basically, I honestly don't know if using part of devm mallocs in
hid-multitouch is safe and if it will work as expected. Maybe Jiri
will have a better idea.

I have a few comments on your patch if Jiri wants to include it.

>
> P.S. Benjamin, I re-used your commit message, I think you have no objections.

No objections :)

Cheers,
Benjamin
