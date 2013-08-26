Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab3HZIu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 04:50:57 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:42233 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab3HZIuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 04:50:54 -0400
MIME-Version: 1.0
In-Reply-To: <35306580.ZCUI1aZasW@vostro.rjw.lan>
References: <CADRPPNSD+uj_t5+qbNW29y7SuJkB_vMck-DGFJFV4A0AmPC6pQ@mail.gmail.com>
	<17024788.0xFN8jEV59@vostro.rjw.lan>
	<02318724-F4F7-4D53-9926-872E9417F672@freescale.com>
	<35306580.ZCUI1aZasW@vostro.rjw.lan>
Date: Mon, 26 Aug 2013 16:50:53 +0800
X-Google-Sender-Auth: YHNUVOD3ynZt-2wnOJsbQitQ-lo
Message-ID: <CADRPPNRyJW8N0NCpi0C0dpx5QudLu5V_BeT+XW=mjaa4HnU6Lg@mail.gmail.com>
Subject: Re: System suspend states and device driver suspend() callback
From: Li Yang <leoli@freescale.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Li Yang-R58472 <r58472@freescale.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 7:53 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Friday, August 16, 2013 05:13:42 PM Li Yang-R58472 wrote:
>>
>> 在 2013-8-16，下午7:22，"Rafael J. Wysocki" <rjw@sisk.pl> 写道：
>>
>> > On Friday, August 16, 2013 04:06:26 PM Li Yang wrote:
>> >> Hi Guys,
>> >>
>> >> Is there a standard way for the device drivers to know if the system
>> >> is going to “standby” mode or “mem” mode when the suspend() callbacks
>> >> are called?
>> >
>> > No, there's none.
>> >
>> > What do you need that for?
>>
>> Some chips like ours are putting the on-chip devices into different low
>> power states when entering different system low power states.  When we enter
>> system standby, on-chip devices are clock gated.  While entering suspend to
>> ram, on-chip devices are power gated.  We want to driver to act differently
>> too when entering different suspend states.
>
> Can you possibly use platform suspend operations to implement that (in analogy
> with ACPI suspend operations)?

I agree it's best to get the state that the device will be in during
suspend from the platform code.  Will it be better to have a standard
interface to pass this information?  Given the fact that a single
device can be used by different platforms even different architecture
nowadays.  How about exposing some new callbacks from the
platform_suspend_ops for the driver to use?

Regards,
Leo
