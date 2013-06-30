Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3F3PK5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 11:10:57 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:44175 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3F3PK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 11:10:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAG27Bk1SZ9txdKrH4DMKZtb=GuuxPZg_12Gi5E3i0hUYQd+WVg@mail.gmail.com>
References: <1372511678-2726-1-git-send-email-kerolasa@iki.fi>
 <8761wxxafc.fsf@xmission.com> <CAG27Bk1SZ9txdKrH4DMKZtb=GuuxPZg_12Gi5E3i0hUYQd+WVg@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sun, 30 Jun 2013 17:10:34 +0200
Message-ID: <CAPXgP13VjmMuHjBoWzGQjn5doamTgQk_xg=0Vobr8thHNHsPig@mail.gmail.com>
Subject: Re: [PATCH] proc: make high precision system boot time available
To: kerolasa@gmail.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Karel Zak <kzak@redhat.com>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 10:53 PM, Sami Kerola <kerolasa@iki.fi> wrote:

> BTW having a way to measure effect of suspend/resume could lead to a
> way to fix time time distortion.

> Perhaps there is better alternative to fix user space programs.
> Unfortunately I do not have either knowledge, or imagination, to come
> up with any. Fix hints, ideas, and other proposal are most welcome.

Stuff should just use:
  clock_gettime(CLOCK_BOOTTIME, &ts);

to get the time in better resolution, and with suspend time taken into account?

As a general note, the kmsg/printk() time in the raw kernel log is the
time of the CPU it runs on, especially during early init this time
might not be in sync across CPUs and stuff jumps event in the very
same stream on events from the kernel itself:
  http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/kernel/sched/clock.c#n329

Kay
