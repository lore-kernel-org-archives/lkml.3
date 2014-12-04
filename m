Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaLDIQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 03:16:28 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:42394 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbaLDIQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 03:16:26 -0500
MIME-Version: 1.0
In-Reply-To: <201412020942.47091@pali>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
	<20141125230527.GC32102@vmdeb7>
	<201412020942.47091@pali>
Date: Thu, 4 Dec 2014 16:16:25 +0800
Message-ID: <CAJ=jqua+xpXyhkjiLrxZ9Cy9D-kwXXP=hB1az+kC+RUn1PN0Bw@mail.gmail.com>
Subject: Re: [PATCH 0/3] Dell Airplane Mode Switch driver
From: Alex Hung <alex.hung@canonical.com>
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Darren Hart <dvhart@infradead.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Darren and Pali,

It was great that we had a lot of discussion but it seems Dell BIOS
implementation varies from one series to another. Both work looks good
either one is fine with me.

But I think I can do a little more: I am collecting a number of
systems to try out these patches. This should help us determine which
one work better and probably we can integrate.

Currently I have found four systems (including two Latitude, an
Inspiron and a XPS with working method(ARBT) that Gabriele suggested).
I can get other, ex. a Vostro, if needed.

I will test dell-wireless.c with Gabriele's suggestion and Pali's
dell-rbtn.c (btw, will there be updates?). However, I will need a few
days to do the comparison.

Any suggested test cases?

Cheers,
Alex Hung


On Tue, Dec 2, 2014 at 4:42 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Wednesday 26 November 2014 00:05:28 Darren Hart wrote:
>> On Sun, Nov 23, 2014 at 04:09:18PM +0100, Pali Rohár wrote:
>> > This patch series add new acpi Dell Airplane Mode Switch
>> > driver (DELLABCE and DELRBTN acpi devices). It provides
>> > radio HW switch events (together with current state of
>> > radio devices) and export them via rfkill interface. These
>> > events are also used in dell-laptop driver instead i8042
>> > filter hook function (when acpi device is available).
>> >
>> > Pali Rohár (3):
>> >   platform: x86: dell-rbtn: Dell Airplane Mode Switch driver
>> >   platform: x86: dell-rbtn: Export notifier for other kernel
>> >   modules platform: x86: dell-laptop: Use dell-rbtn instead
>> >   i8042 filter when
>> >
>> >     possible
>> >
>> >  drivers/platform/x86/Kconfig       |   14 ++
>> >  drivers/platform/x86/Makefile      |    1 +
>> >  drivers/platform/x86/dell-laptop.c |   67 +++++++++-
>> >  drivers/platform/x86/dell-rbtn.c   |  260
>> >  ++++++++++++++++++++++++++++++++++++
>> >  drivers/platform/x86/dell-rbtn.h   |   35 +++++
>> >  5 files changed, 372 insertions(+), 5 deletions(-)
>> >  create mode 100644 drivers/platform/x86/dell-rbtn.c
>> >  create mode 100644 drivers/platform/x86/dell-rbtn.h
>>
>> Alex, it is my understanding that this solution from Pali is a
>> more complete solution to dealing with the variety of dell
>> wireless buttons and rfkill mechanisms in the world today.
>>
>> I currently have:
>> 7c4d961 dell-wireless: new driver for dell wireless button for
>> Windows 8 queued in for-next. If I have read your responses
>> on this correctly, are we all in agreement that I should drop
>> the above patch, and apply these?
>
> Darren, it it truth that some laptops does not send keypress
> event when Fn+wifi key is pressed (but only send ACPI event),
> then really Alex's patch for input device is needed. But it could
> be integrated into my driver. Also Alex wrote something about
> ACPI events for laptops which have wifi key instead HW switch. So
> before including this patch into tree, I would like to hear what
> is problem with my patch for laptops which have wifi key...
>
> --
> Pali Rohár
> pali.rohar@gmail.com



-- 
Cheers,
Alex Hung
