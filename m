Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab3KVPyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:54:11 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:41190 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3KVPyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:54:08 -0500
MIME-Version: 1.0
X-Originating-IP: [128.131.48.204]
In-Reply-To: <528DCCBD.80009@euromail.se>
References: <1384988052-31898-1-git-send-email-linux@schoeller.se>
	<528DCCBD.80009@euromail.se>
Date: Fri, 22 Nov 2013 16:54:07 +0100
X-Google-Sender-Auth: 68NIaRDF2BadsxucBkeCLYOH0q8
Message-ID: <CAB2HYNV+Y0SK0haxvdY6FessRc5jSRUSpkY-t1RvyqW2wrSwoQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] Input: Fixed ABS_MT_TOUCH_MINOR scale factor in
 BCM5974 multitouch driver
From: =?UTF-8?Q?Friedrich_Sch=C3=B6ller?= <linux@schoeller.se>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Henrik,

>> On wellspring3 devices ABS_MT_TOUCH_MINOR was sometimes reported bigger than
>> ABS_MT_TOUCH_MAJOR. This is fixed by rescaling ABS_MT_TOUCH_MINOR by a factor of
>> 0.85 instead of 2. Excessive tapping on the trackpad shows this to be the right
>> value. Circular touches should now lead to values for ABS_MT_TOUCH_MAJOR and
>> ABS_MT_TOUCH_MINOR that are similar, with ABS_MT_TOUCH_MINOR never greater than
>> ABS_MT_TOUCH_MAJOR.
>> ---
>>  drivers/input/mouse/bcm5974.c | 20 +++++++++++++++++---
>>  1 file changed, 17 insertions(+), 3 deletions(-)
>
> The major/minor scales are following the aspect ratio of the device, and as such
> it could happen that minor > major. Most userland drivers do not use the finger
> width limits, which are estimates, but only the device axes limit, which are
> accurate.

I know you wrote it, but this seems to me to contradict the
documentation on the multitouch protocol:
"In addition to the MAJOR parameters, the oval shape of the touch and finger
regions can be described by adding the MINOR parameters, such that MAJOR
and MINOR are the major and minor axis of an ellipse."

Why do the limits on the device axes, which are oriented horizontally
and vertically, have any influence on the major and minor parameters
which can be oriented arbitrarily?

Or let me phrase it more pragmatically: How can a userland application
figure out the factor of 0.425 (from 0.85 / 2) by which it has to
multiply ABS_MT_TOUCH_MINOR?

As a side note: The WIDTH_MAJOR and WIDTH_MINOR parameters are already
well behaved in the sense that WIDTH_MINOR is always smaller.

> Also, we cannot have floats in the kernel.

Okay a fraction would do the trick.

Thanks,
Friedrich
