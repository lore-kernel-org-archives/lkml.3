Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab3GVND2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:03:28 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:42701 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab3GVND0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:03:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130722124047.GL4165@ZenIV.linux.org.uk>
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
 <51E988FF.9010201@nod.at> <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
 <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com> <20130722124047.GL4165@ZenIV.linux.org.uk>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 22 Jul 2013 18:32:46 +0530
Message-ID: <CALkWK0=bAwDxbLEtHOThjY58BmWCrFYgZm9GaLfEnF5vpu1VJw@mail.gmail.com>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Richard Weinberger <richard@nod.at>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Mon, Jul 22, 2013 at 03:15:14PM +0530, Ramkumar Ramachandra wrote:
>> Ramkumar Ramachandra wrote:
>> > [1]: http://lists.freedesktop.org/archives/systemd-devel/2013-July/012152.html
>>
>> ... and the patches were rejected.  Lennart says that UML providing
>> /dev/tty* is wrong, and that UML should call them /dev/hvc* (or
>> something).  Can we do something about the situation?  Can we remove
>> /dev/tty*, and provide /dev/hvc*?  Will we be breaking existing users?
>
> Yes, you would be breaking existing users.  Starting with anybody with static
> /dev.  Or a debian userland, for that matter.  Any systemd-free setup,
> actually.

Systemd does not support a static /dev, so we're talking about
non-systemd systems.  Ofcourse I reject anything that breaks existing
users.

> Changing device number assignments is not to be done lightly, whether
> they should've been set that way back then or not.

I never proposed something as ridiculous as changing device number
assignments.  I'm trying to add a HVC_DRIVER to um Linux: I enabled it
in the Kconfig; any idea how to get devtmpfs to populate /dev with
hvc* device nodes now?

> As for Lennart's opinion...  *shrug*  He's free to do whatever he wants
> in systemd.  It does not translate into having any kind of control over
> the kernel.

If you care about users, you will stop worrying about different
people's "opinions", "control", and work towards a solution.  I want
great user-experience, period.  You can continue to argue endlessly
about the sanity of Lennart/systemd for all I care, but you cannot
deny the fact that systemd has _users_.  Users that you must support.

So, what should we do?
