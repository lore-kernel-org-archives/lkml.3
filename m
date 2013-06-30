Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab3F3Rqg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 13:46:36 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:43125 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab3F3Rqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 13:46:35 -0400
MIME-Version: 1.0
Reply-To: kerolasa@gmail.com
In-Reply-To: <CAPXgP13VjmMuHjBoWzGQjn5doamTgQk_xg=0Vobr8thHNHsPig@mail.gmail.com>
References: <1372511678-2726-1-git-send-email-kerolasa@iki.fi>
	<8761wxxafc.fsf@xmission.com>
	<CAG27Bk1SZ9txdKrH4DMKZtb=GuuxPZg_12Gi5E3i0hUYQd+WVg@mail.gmail.com>
	<CAPXgP13VjmMuHjBoWzGQjn5doamTgQk_xg=0Vobr8thHNHsPig@mail.gmail.com>
Date: Sun, 30 Jun 2013 18:46:34 +0100
X-Google-Sender-Auth: gaQIiIqr_eVfRp38rcmZjCe8Y9Q
Message-ID: <CAG27Bk33MbFsbxz7QxApw5i0eGJaPc2Mf2UgcL0rqLNcty4HCQ@mail.gmail.com>
Subject: Re: [PATCH] proc: make high precision system boot time available
From: Sami Kerola <kerolasa@iki.fi>
To: Kay Sievers <kay@vrfy.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Karel Zak <kzak@redhat.com>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 June 2013 16:10, Kay Sievers <kay@vrfy.org> wrote:
> On Sat, Jun 29, 2013 at 10:53 PM, Sami Kerola <kerolasa@iki.fi> wrote:
>
>> BTW having a way to measure effect of suspend/resume could lead to a
>> way to fix time time distortion.
>
>> Perhaps there is better alternative to fix user space programs.
>> Unfortunately I do not have either knowledge, or imagination, to come
>> up with any. Fix hints, ideas, and other proposal are most welcome.
>
> Stuff should just use:
>   clock_gettime(CLOCK_BOOTTIME, &ts);
>
> to get the time in better resolution, and with suspend time taken into account?
>
> As a general note, the kmsg/printk() time in the raw kernel log is the
> time of the CPU it runs on, especially during early init this time
> might not be in sync across CPUs and stuff jumps event in the very
> same stream on events from the kernel itself:
>   http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/kernel/sched/clock.c#n329

Thank you Kay,

The clock_gettime(CLOCK_BOOTTIME, &uptime); seems to be exactly what
dmesg needs. A patch to fix dmesg wigging will be sent to util-linux
maillist shortly. Perhaps the dmesg / journald time stamp difference
issue will be fixed someday, but that discussion does not belong to
linux-kernel mailist, so it is time to declare

end of thread.

--
Sami Kerola
http://www.iki.fi/kerolasa/
