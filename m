Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab3D3H1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 03:27:05 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:61953 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab3D3H1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 03:27:03 -0400
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Tue, 30 Apr 2013 09:26:42 +0200
Message-ID: <CAH9NwWe4HLLCjymFp0CLhHVLjTSJEXR0vwrLudQBBA04zTe5xA@mail.gmail.com>
Subject: HPET rtc emulation
To: LKML <linux-kernel@vger.kernel.org>, venki@google.com,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I am working with a platform that has a problem with the RTC alarm
interrupt - tested with rtctest from /Documentation/rtc.txt.
So I thought that I could use the HPET emulation. As far as I
understand in the HPET emulation mode no RTC irq will be used --> RTC
alarm interrupt is done via HPET.
Is this a correct assumption?

root@OT:/home/vis# hwclock
Tue 30 Apr 2013 09:24:28 AM CEST  -0.511012 seconds
root@OT:/home/vis# hwclock
Tue 30 Apr 2013 09:24:29 AM CEST  -0.511016 seconds
root@OT:/home/vis# hwclock
Tue 30 Apr 2013 09:24:30 AM CEST  -0.526659 seconds
root@OT:/home/vis# hwclock
Tue 30 Apr 2013 09:24:31 AM CEST  -0.620384 seconds
root@OT:/home/vis# hwclock
Tue 30 Apr 2013 09:24:32 AM CEST  -0.604838 seconds
root@OT:/home/vis# hwclock
Tue 30 Apr 2013 09:24:33 AM CEST  -0.651638 seconds
root@OT:/home/vis# hwclock
Tue 30 Apr 2013 09:24:34 AM CEST  -0.682915 seconds
root@OT:/home/vis# hwclock
Tue 30 Apr 2013 09:24:35 AM CEST  -0.026708 seconds
root@OT:/home/vis# hwclock
select() to /dev/rtc to wait for clock tick timed ou


Doing some quite simple tests indicates that HPET emulation does not emulate
RTC alarm interrupts or my HPET has some problems.

thanks
--
Christian Gmeiner, MSc
