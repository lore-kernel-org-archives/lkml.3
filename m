Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab3DXXwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 19:52:46 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:50713 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268Ab3DXXwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 19:52:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130424215103.GI15272@hansolo.jdub.homelinux.org>
References: <1256775981.281402.1364864751771.JavaMail.root@redhat.com>
 <CAGXu5jLU40Vzx+bNyPSArBt_yYNO9sPJ3yLj7z3Yq=pH22W1Gw@mail.gmail.com>
 <20130409005050.GE18176@hansolo.jdub.homelinux.org> <20130409154820.GE32476@hansolo.jdub.homelinux.org>
 <CAGXu5jLs1ghuCwcu7crOG1OHuiaP3hmzYY410br_puc9i82-2g@mail.gmail.com>
 <CAPXgP10Vd3Ucxn77WX7wzQoaUmy-JdOBWvYv4zpGSu9qcd=GoQ@mail.gmail.com>
 <20130424175835.GF15272@hansolo.jdub.homelinux.org> <CAGXu5jLaQ=Amui3i5+MyG_3HOVnK-1ZoaLqw=jFDwaQCzE+4qw@mail.gmail.com>
 <20130424212112.GH15272@hansolo.jdub.homelinux.org> <CAGXu5jJweZVLhz0pP6=Woud=aqAKgNmG-7T5WKYdmWR4gxcw9w@mail.gmail.com>
 <20130424215103.GI15272@hansolo.jdub.homelinux.org>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 25 Apr 2013 01:52:22 +0200
Message-ID: <CAPXgP11R3mp-QCMnmZrQ2p=CdAg8G6wvk+=Tf3GxT3iODzTP5g@mail.gmail.com>
Subject: Re: [PATCH v2] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
To: Josh Boyer <jwboyer@redhat.com>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Kujau <lists@nerdbynature.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kzak@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 11:51 PM, Josh Boyer <jwboyer@redhat.com> wrote:

>> In the daemon case, it's nice to be able to drop privileges after
>> setting up resources. The past was open /proc/kmsg with CAP_SYS_ADMIN,
>> then drop CAP_SYS_ADMIN and keep reading. Then later CAP_SYS_LOG was
>> introduced. So if a daemon switched from /proc/kmsg to /dev/kmsg they
>> wouldn't be able to drop the capability. But, it's much saner to carry
>> CAP_SYS_LOG than CAP_SYS_ADMIN on a long-running daemon.
>
> I have no idea on this front.  I'll let Kay speak to that.

The original code checks once at open() only, which would allow to do
do all that privilege dropping. It is how I would expect it to work,
instead of checking the permissions at every read().

> On my
> currently running Fedora 18 system, I actually have systemd-journald
> using /dev/kmsg

That's the recent structured logging stuff.

> and rsyslog using /proc/kmsg.

That's the old plain text syslog daemon stuff.

> Why I have both, I have no friggin idea.

Nobody removed the old syslog dameon by default from the distro. If
you don't want or need the plain text files in /var/log/ anymore, just
uninstall it and use journalctl(1) to see the system logs from then
on.

>> Is there an intention to use /dev/kmsg for the syslog management daemon?

Not that I know.

> Maybe?  I mean, systemd-journald seems to be using it for something.
> Kay?

I doubt that old syslog implementations will be ported to a new kernel
interface. They work just fine the way they are, and the structured
data that is additionally put out on the new interface, they cannot
really store away anyway in their plain text files, so they do not
gain anything really.

What we can probably expect though, is that in the future the default
systems will not install any old syslog daemon, which uses that
interface anymore.

Kay
