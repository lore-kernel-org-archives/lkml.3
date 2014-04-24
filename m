Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaDXEcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 00:32:04 -0400
Received: from ozlabs.org ([103.22.144.67]:59502 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaDXEcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 00:32:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: simon@mungewell.org
Cc: Michal =?utf-8?Q?Mal=C3=BD?= <madcatxster@devoid-pointer.net>,
        linux-kernel@vger.kernel.org,
        HID CORE LAYER <linux-input@vger.kernel.org>,
        "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 3/9] drivers/hid/hid-lg4ff.c: avoid world-writable sysfs files.
In-Reply-To: <4977a0bbe5c8625d93f771983991f30a.squirrel@mungewell.org>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au> <1398137612-9714-4-git-send-email-rusty@rustcorp.com.au> <9d9a3af40f8a0da293e52610524674c8.squirrel@mungewell.org> <87r44ofw1x.fsf@rustcorp.com.au> <4977a0bbe5c8625d93f771983991f30a.squirrel@mungewell.org>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 24 Apr 2014 12:55:24 +0930
Message-ID: <87eh0nfly3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simon@mungewell.org writes:
>> simon@mungewell.org writes:
>>> Yep I'm OK with that, however what it the recommended way to make sure
>>> that the end user is able to send changes to this /sys portal? I asked
>>> the
>>> same question before regarding the led class /sys interface, but never
>>> got
>>> any suggestions.
>>>
>>> Signed-off-by: Simon Wood <simon@mungewell.org>
>>
>> If you need that, we'll need to make an exception.  That's one purpose
>> of spamming everyone with these changs...
>
>
> What's the right way of doing it?... I don't need to be 'special'. ;-)
>
> The '/sys/.../range' control allows the user to limit the rotation of the
> gaming wheel from a maximum of 900' down to match the 'car' they
> sim-driving. Probably not many people use it, but it probably should be
> assigned properly.
>
> With gaming controllers the /dev/input/event* seem to get set
> appropriately, but I'm not sure how this happens.
>
> The same /should/ also happen for all the LED class controls, I don't want
> to have to 'sudo' just to set a LED on/off. This is currently a problem
> for (at least) hid-lg, hid-sony and hid-steelseries.
> Simon

I think this is a udev duty.  Someone needs to chmod/chown/chgrp the
files if you want to allow a particular group/user access (I just
checked, that works fot sysfs files).

I have no idea about HID, so I don't know how you'd figure out who that
user/group is...

Cheers,
Rusty.
