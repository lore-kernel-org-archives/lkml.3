Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947399Ab3BHXo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:44:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947361Ab3BHXo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:44:56 -0500
Message-ID: <51158DF2.3090702@redhat.com>
Date: Fri, 08 Feb 2013 18:44:50 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time, Fix setting of hardware clock in NTP code
References: <CANcMJZAzT-fCXY2P0ZRjdMoXq+dNd3rrq3eNY18pgob-hS6L9g@mail.gmail.com> <1360364393-17595-1-git-send-email-prarit@redhat.com> <51158643.1020204@linaro.org>
In-Reply-To: <51158643.1020204@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/08/2013 06:12 PM, John Stultz wrote:
> On 02/08/2013 02:59 PM, Prarit Bhargava wrote:

> 
> Ok, I've got this queued in my tree. What sort of testing did you do with it?
> 
> I want to make sure we don't run into any bad interactions with the existing
> 15min cap on x86.

John,

I did the following:

I used powerpc pseries systems and tested this using both positive and negative
values of sys_tz.minuteswest, with both UTC and LOCAL in /etc/adjtime.  I dumped
values of 'hwclock -D' and date and confirmed that I no longer see time
increasing by sys_tz.minuteswest each reboot.

I also tested x86 32-bit and 64-bit as a sanity check and verified that the
current behaviour on those arches is the same; ie) I don't see *any* impact to
the x86 rtc.  I dumped values of 'hwclock -D' and date, and again confirmed that
I see no differences in values.  I did that with both UTC and LOCAL.

I also tested a powerpc box and set the hwclock (via BIOS) back to Dec 6 2012 to
see what would happen when I enabled ntp.  The system booted, set the system
time to Dec 6 2012, and then properly ended up with both system time AND hwclock
as Feb 8 2013 after systemd init .... (The *exact* time-of-day was correct as
well.  I just can't remember the time I did it ;) )

And I did the same thing (adjusting the BIOS date back) on x86. I only see the
hours and minutes change, as we expect.  The year, month, day are unaffected
with both UTC and LOCAL.

tl;dr  Yup.  Tested as much as I could think of doing before submitting.  Tested
on a both x86, powerpc.  Fixed the bug on powerpc.  No change in behavior seen
with x86.

If you want me to do some other test I certainly can give it a shot.

P.
