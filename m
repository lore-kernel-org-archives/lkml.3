Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760538Ab3B0SB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:01:26 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41996 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab3B0SBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:01:25 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4Q8_J6W0oH7QH=vamtg0HRjimzk6N4M-9oSMRzyD=o-7A@mail.gmail.com>
References: <1361979498-24446-1-git-send-email-benjamin.tissoires@redhat.com>
	<CANq1E4Q8_J6W0oH7QH=vamtg0HRjimzk6N4M-9oSMRzyD=o-7A@mail.gmail.com>
Date: Wed, 27 Feb 2013 19:01:24 +0100
Message-ID: <CAN+gG=HbQ_vUUkJS++9Vtb4Q+iYMp8Lt_2dRv3OdeOUvfwMGEw@mail.gmail.com>
Subject: Re: [RFC 0/2] HID: Introduce .idle() to remove last usb dependence
 from hid-multitouch
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 6:48 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi Benjamin
>
> On Wed, Feb 27, 2013 at 4:38 PM, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
>> Hi guys,
>>
>> Well, this series of two patches aims at removing the dependence between usb
>> and hid-multitouch.
>> I put a RFC and not a patch as I'm not satisfied with the result:
>> - adding this callback for one use may not be accurate
>> - the parameters may not be good either (HID_REQ_SET_IDLE is the only valid
>>   value for now as noone seems to be using HID_REQ_GET_IDLE)
>> - the return value is clearly not very interesting.
>> - maybe we should just add HID_REQ_SET_IDLE to .request, but this will require
>>   a few changes in the parameters.
>>
>> The main purpose of this RFC was to share it with David this new ll callback, so
>> that we can have a global view of what is needed.
>
> I actually never read the specs for SET/GET_IDLE. The Bluetooth HID
> Profile deprecated these and I haven't seen a Bluetooth device that
> relies on it. Any reasons why I should implement them?

I don't want you to absolutely implement it. I just wanted to share it
with you because all the commands set/get report, set/get idle,
set/get protocol and set power are part of the "class specific
requests".
So I don't know if we should have distinct hid_hw_* calls for each of
them, or if we should implement a big hid_hw_request() function.

>
> Also, for things like UHID I think we can safely drop this request.

sure.

> Considering that, I think the patches can be applied as they are, so:
>   Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Thanks.

>
> The Bluetooth HID Profile actually implements some other SUSPEND
> calls,  but these are supposed to be handled by the Bluetooth stack
> independently of the HID driver. So if there is no other magic going
> on with SET_IDLE, I'd just leave it for usbhid.
>
> (does anyone know whether i2c-hid support these?)

It does, but it's also marked as deprecated. :) So I don't want to
implement it either until we found weird devices requesting it.

Cheers,
Benjamin
