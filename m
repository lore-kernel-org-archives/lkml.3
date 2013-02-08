Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947345Ab3BHXMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:12:09 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58277 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947176Ab3BHXMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:12:08 -0500
Message-ID: <51158643.1020204@linaro.org>
Date: Fri, 08 Feb 2013 15:12:03 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time, Fix setting of hardware clock in NTP code
References: <CANcMJZAzT-fCXY2P0ZRjdMoXq+dNd3rrq3eNY18pgob-hS6L9g@mail.gmail.com> <1360364393-17595-1-git-send-email-prarit@redhat.com>
In-Reply-To: <1360364393-17595-1-git-send-email-prarit@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2013 02:59 PM, Prarit Bhargava wrote:
> At init time, if the system time is "warped" forward in warp_clock()
> it will differ from the hardware clock by sys_tz.tz_minuteswest.  This time
> difference is not taken into account when ntp updates the hardware clock,
> and this causes the system time to jump forward by this offset every reboot.
>
> The kernel must take this offset into account when writing the system time
> to the hardware clock in the ntp code.  This patch adds
> persistent_clock_is_local which indicates that an offset has been applied
> in warp_clock() and accounts for the "warp" before writing the hardware
> clock.
>
> x86 does not have this problem as rtc writes are software limited to a
> +/-15 minute window relative to the current rtc time.  Other arches, such
> as powerpc, however do a full synchronization of the system time to the
> rtc and will see this problem.

Ok, I've got this queued in my tree. What sort of testing did you do 
with it?

I want to make sure we don't run into any bad interactions with the 
existing 15min cap on x86.

thanks
-john

