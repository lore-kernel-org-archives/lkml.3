Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab3HJV2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 17:28:42 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:45742 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758830Ab3HJV2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 17:28:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAG-2HqUT3hbFPSEqYnJvBOgS6p4dKf=nhqZtzqS-on8FFe9ipA@mail.gmail.com>
References: <CALCETrXSnFPFVPkXHwz+FFA3=+pmz9V=cMHWwtN+jG1QJALWSQ@mail.gmail.com>
 <325b19bb936d7ebae11edad86aac8f0931e8abd9.1375719828.git.luto@amacapital.net>
 <5200B1BD.7030307@gmail.com> <CAG-2HqXEj06JbUOWee=NfuRXxL75uRf=55FZcXRLHroDzYUthQ@mail.gmail.com>
 <CAG-2HqVvoQK8ggErGGinO9i8Pbu-O-X=eYFW445ce24dpt7HyA@mail.gmail.com>
 <20130806163158.GA23093@kadzban.is-a-geek.net> <CAG-2HqU=yyxomNTg9-2+bxMKP=e5_pdVT7bhB_CHhFzB-ac_mQ@mail.gmail.com>
 <CALCETrU-CWuefE5XUpC=xFuCXaL56Cox95nL35Bm9jMi_B+6_A@mail.gmail.com>
 <5201FCA4.30804@gmail.com> <CAG-2HqUT3hbFPSEqYnJvBOgS6p4dKf=nhqZtzqS-on8FFe9ipA@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sat, 10 Aug 2013 23:28:18 +0200
Message-ID: <CAPXgP11LnVqTxsKUoLTLwtP-oxcekkNxmPG2X-R+2U9S4-dAgQ@mail.gmail.com>
Subject: Re: [PATCH] udev: fail firmware loading immediately if no search path
 is defined
To: Tom Gundersen <teg@jklm.no>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-hotplug@vger.kernel.org,
        Bryan Kadzban <bryan@kadzban.is-a-geek.net>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 11:00 PM, Tom Gundersen <teg@jklm.no> wrote:
> It would be simple enough to add an udev rule to just print 'ignoring
> firmware event' to the logs.

This and I guess:
  SUBSYSTEM=="firmware", ACTION=="add", ATTR{loading}="-1"
would also just cancel the request at the same time without any other
code needed.

The udev firmware support just a configure option, just like the
kernel has them. So distributions should enable it in udev and the
kernel if they need it.

We simply cannot coordinate the defaults of systemd and the kernel
because the rules of the kernel are different. The kernel does "keep
defaults like stuff has been in the past" and udev does "make default
what makes the most sense on current systems".

> We should really ignore the event though, and
> not cancel it. Not sure if this is something we want upstream (after all,
> there are plenty of situations where we don't warn if the recommendations in
> the README file are not followed), or if distros and whoever wants it should
> ship that themselves. I'll leave that for Kay to decide.

The proper fix is that userspace firmware should be disabled in the
kernel for new systems, and kept enabled only for old systems. Old
systems need to enable a new udev version to support firmware loading.

There are currently broken in-kernel mis-users of the firmware
interface that use the firmware interface but disable uevents, they
still pull-in the user interface of the firmware loader. If nobody
wants to fix them, the code for the common users of the firmware
loader should at least get rid of the userspace fallback to call out
to userspace. At that point the udev configure option would not matter
any more.

> Lastly, note that the plan is to drop all the firmware code from udev in the
> not too distant future, so it doesn't really maker much sense to add new
> functionality to that at this point.

Right, I think all is fine. It's something that people can control
with the kernel and udev configuration options. It's just that the
defaults of the kernel and udev don't match at the moment, because
they have different policies of setting default values.

Kay
