Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107Ab3HORhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 13:37:03 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:64122 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3HORg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 13:36:59 -0400
MIME-Version: 1.0
In-Reply-To: <520BE280.6010407@ahsoftware.de>
References: <1376405889-12378-1-git-send-email-benjamin.tissoires@redhat.com>
	<1376405889-12378-2-git-send-email-benjamin.tissoires@redhat.com>
	<20130813191731.GA8391@polaris.bitmath.org>
	<520BA464.9060200@redhat.com>
	<520BE280.6010407@ahsoftware.de>
Date: Thu, 15 Aug 2013 19:36:57 +0200
Message-ID: <CAN+gG=FEHefW-4XrCTkDY2_Jfj+uWZ=g_uc-2BsgFdW2My=VvA@mail.gmail.com>
Subject: Re: [PATCH 1/3] HID: Use existing parser for pre-scanning the report descriptors
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 10:03 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 14.08.2013 17:38, schrieb Benjamin Tissoires:
>
>
>>>>   {
>>>>         if (usage == HID_DG_CONTACTID)
>>>> -               hid->group = HID_GROUP_MULTITOUCH;
>>>> +               parser->flags |= HID_FLAG_MULTITOUCH;
>>>
>>>
>>> Did you consider reusing the group flags, e.g., parser->groups |= (1
>>> << HID_GROUP_MULTITOUCH)? This change could be made regardless of the
>>> parser logic.
>>
>>
>> If nobody is against changing the values of the different groups across
>> kernel version (which should be harmless), then I fully agree, we can
>> use the group item as a bit field (but we would be able to only have 16
>> different device groups).
>
>
> Hmm, that might become a problem. E.g. all the HID sensors might be used
> stand alone (without a sensor-hub, if someone modifies the drivers). But I
> agree that currently the flags are just confusing and would introduce them
> only if the number of groups reaches the limit.
>
>
>
>>>> -       hid->group = HID_GROUP_GENERIC;
>>>> +       parser = vzalloc(sizeof(struct hid_parser));
>>>
>>>
>>> Argh, I realize it is inevitable for this patch, but it still makes my
>>> eyes bleed. The parser takes quite a bit of memory...
>>
>>
>> Yep, my first attempt was to remove it, then I re-added it with a small
>> tear...
>
>
> So you actually create a new parser and the subject (that existing) of this
> patch is misleading.

Hi Alexander,

I think you misread what Henrik and I were discussing about:
Henrik complained about using the heap for something which is just
used in this function, and using the stack would have been better.
However, the size of the parser is too big that the compiler complains
when we declare it on the stack.

So this line is just a copy/paste from the function hid_open_report(),
and thus, you can agree that I did not create a new parser.

Cheers,
Benjamin
