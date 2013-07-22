Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3GVLtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 07:49:14 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:34634 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3GVLtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 07:49:12 -0400
MIME-Version: 1.0
In-Reply-To: <CALkWK0mpH9XHL2PZK47Lb9frf9hFNQ8sjF2_0p7VJnY8XWhiGw@mail.gmail.com>
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
 <51E988FF.9010201@nod.at> <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
 <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com>
 <51ED0BBF.7060502@nod.at> <CALkWK0mpH9XHL2PZK47Lb9frf9hFNQ8sjF2_0p7VJnY8XWhiGw@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 22 Jul 2013 17:18:32 +0530
Message-ID: <CALkWK0k_twGS_DYetD6c4GO0ORU0yqyiENamz=NuZ0D6Ap1b6w@mail.gmail.com>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
To: Richard Weinberger <richard@nod.at>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Richard Weinberger wrote:
>> Lennart, can you please explain us why /dev/tty[1..64] is forced to
>> have virtual console support?

The crux of Lennart's argument seems to be that several applications
depend on it, and that applications have to bend over backwards when
those expectations are broken [1].  He has also pointed out that
hypervisor applications implement /dev/hvc0, /dev/xvc0, and /dev/hvsi0
by convention (which serve the same purpose), and that systemd
supports them.  I'm not going to argue about hard rules, because it's
clearly possible to enable CONFIG_TTY and disable CONFIG_VT in the tty
driver (the Kconfig allows this), as um Linux has done.

Since um Linux behaves more like a "container" application, is it
feasible to replace the /dev/tty* with /dev/hvc* in a
backward-compatible manner?  I think it is, although I may be missing
something: we just have to deprecate "tty" in the command-line options
to actually point to /dev/hvc*, and enable HVC_DRIVER/HVC_CONSOLE,
right?  It should be fairly straightforward to deprecate drivers/tty.c
in favor of a newer drivers/hvc.c, I think.

Let me know if I've said something stupid, so I can stop writing the patches.

Thanks.

[1]: http://lists.freedesktop.org/archives/systemd-devel/2013-July/012212.html
