Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab3HNUDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:03:42 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:40529 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933017Ab3HNUDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:03:40 -0400
Message-ID: <520BE280.6010407@ahsoftware.de>
Date: Wed, 14 Aug 2013 22:03:12 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
CC: rydberg@euromail.se, Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] HID: Use existing parser for pre-scanning the report
 descriptors
References: <1376405889-12378-1-git-send-email-benjamin.tissoires@redhat.com> <1376405889-12378-2-git-send-email-benjamin.tissoires@redhat.com> <20130813191731.GA8391@polaris.bitmath.org> <520BA464.9060200@redhat.com>
In-Reply-To: <520BA464.9060200@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.08.2013 17:38, schrieb Benjamin Tissoires:

>>>   {
>>>   	if (usage == HID_DG_CONTACTID)
>>> -		hid->group = HID_GROUP_MULTITOUCH;
>>> +		parser->flags |= HID_FLAG_MULTITOUCH;
>>
>> Did you consider reusing the group flags, e.g., parser->groups |= (1
>> << HID_GROUP_MULTITOUCH)? This change could be made regardless of the
>> parser logic.
>
> If nobody is against changing the values of the different groups across
> kernel version (which should be harmless), then I fully agree, we can
> use the group item as a bit field (but we would be able to only have 16
> different device groups).

Hmm, that might become a problem. E.g. all the HID sensors might be used 
stand alone (without a sensor-hub, if someone modifies the drivers). But 
I agree that currently the flags are just confusing and would introduce 
them only if the number of groups reaches the limit.


>>> -	hid->group = HID_GROUP_GENERIC;
>>> +	parser = vzalloc(sizeof(struct hid_parser));
>>
>> Argh, I realize it is inevitable for this patch, but it still makes my
>> eyes bleed. The parser takes quite a bit of memory...
>
> Yep, my first attempt was to remove it, then I re-added it with a small
> tear...

So you actually create a new parser and the subject (that existing) of 
this patch is misleading.

Regards,

Alexander Holler
