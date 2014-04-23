Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbaDWPHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:07:01 -0400
Received: from host171.canaca.com ([67.55.55.225]:44653 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaDWPG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:06:58 -0400
Message-ID: <4977a0bbe5c8625d93f771983991f30a.squirrel@mungewell.org>
In-Reply-To: <87r44ofw1x.fsf@rustcorp.com.au>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
    <1398137612-9714-4-git-send-email-rusty@rustcorp.com.au>
    <9d9a3af40f8a0da293e52610524674c8.squirrel@mungewell.org>
    <87r44ofw1x.fsf@rustcorp.com.au>
Date: Wed, 23 Apr 2014 11:06:54 -0400
Subject: Re: [PATCH 3/9] drivers/hid/hid-lg4ff.c: avoid world-writable sysfs
 files.
From: simon@mungewell.org
To: "Rusty Russell" <rusty@rustcorp.com.au>
Cc: =?iso-8859-1?Q?=22Michal_Mal=FD=22?= 
	<madcatxster@devoid-pointer.net>,
        linux-kernel@vger.kernel.org,
        "HID CORE LAYER" <linux-input@vger.kernel.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> simon@mungewell.org writes:
>>> In line with practice for module parameters, we're adding a build-time
>>> check that sysfs files aren't world-writable.
>>
>> So this is the equivalent of 'chmod 774 ...' rather than 'chmod
>> 777...'?
>
> Yep.  Though not sure why it was 777 rather than 666...
>
>> Yep I'm OK with that, however what it the recommended way to make sure
>> that the end user is able to send changes to this /sys portal? I asked
>> the
>> same question before regarding the led class /sys interface, but never
>> got
>> any suggestions.
>>
>> Signed-off-by: Simon Wood <simon@mungewell.org>
>
> If you need that, we'll need to make an exception.  That's one purpose
> of spamming everyone with these changs...


What's the right way of doing it?... I don't need to be 'special'. ;-)

The '/sys/.../range' control allows the user to limit the rotation of the
gaming wheel from a maximum of 900' down to match the 'car' they
sim-driving. Probably not many people use it, but it probably should be
assigned properly.

With gaming controllers the /dev/input/event* seem to get set
appropriately, but I'm not sure how this happens.

The same /should/ also happen for all the LED class controls, I don't want
to have to 'sudo' just to set a LED on/off. This is currently a problem
for (at least) hid-lg, hid-sony and hid-steelseries.
Simon

