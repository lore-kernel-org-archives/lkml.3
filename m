Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab3HFQkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:40:45 -0400
Received: from nlpi176.sbcis.sbc.com ([207.115.36.48]:36059 "EHLO
	nlpi176.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab3HFQk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:40:29 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Aug 2013 12:40:29 EDT
Date: Tue, 6 Aug 2013 09:31:58 -0700
From: Bryan Kadzban <bryan@kadzban.is-a-geek.net>
To: Tom Gundersen <teg@jklm.no>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        systemd-devel@lists.freedesktop.org, linux-hotplug@vger.kernel.org,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Intel Linux Wireless <ilw@linux.intel.com>, Kay Sievers <kay@vrfy.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [systemd-devel] [PATCH] Change CONFIG_FW_LOADER_USER_HELPER to default n and don't select it
Message-ID: <20130806163158.GA23093@kadzban.is-a-geek.net>
References: <CALCETrXSnFPFVPkXHwz+FFA3=+pmz9V=cMHWwtN+jG1QJALWSQ@mail.gmail.com> <325b19bb936d7ebae11edad86aac8f0931e8abd9.1375719828.git.luto@amacapital.net> <5200B1BD.7030307@gmail.com> <CAG-2HqXEj06JbUOWee=NfuRXxL75uRf=55FZcXRLHroDzYUthQ@mail.gmail.com> <CAG-2HqVvoQK8ggErGGinO9i8Pbu-O-X=eYFW445ce24dpt7HyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG-2HqVvoQK8ggErGGinO9i8Pbu-O-X=eYFW445ce24dpt7HyA@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 11:17:17AM +0200, Tom Gundersen wrote:
> On Tue, Aug 6, 2013 at 11:11 AM, Tom Gundersen <teg@jklm.no> wrote:
> > On Tue, Aug 6, 2013 at 10:20 AM, Maarten Lankhorst
> > <m.b.lankhorst@gmail.com> wrote:
> >> Op 05-08-13 18:29, Andy Lutomirski schreef:
> >>> The systemd commit below can delay firmware loading by multiple
> >>> minutes if CONFIG_FW_LOADER_USER_HELPER=y.  Unfortunately no one
> >>> noticed that the systemd-udev change would break new kernels as well
> >>> as old kernels.
> >>>
> >>> Since the kernel apparently can't count on reasonable userspace
> >>> support, turn this thing off by default.
> >>>
> >>> commit a3bd8447be4ea2ce230eb8ae0e815c04d85fa15a
> >>> Author: Tom Gundersen <teg@jklm.no>
> >>> Date:   Mon Mar 18 15:12:18 2013 +0100
> >>>
> >>>     udev: make firmware loading optional and disable by default
> >>>
> >>>     Distros that whish to support old kernels should set
> >>>       --with-firmware-dirs="/usr/lib/firmware/updates:/usr/lib/firmware"
> >>>     to retain the old behaviour.
> >>>
> >> methinks this patch should be reverted then,
> >
> > Well, all the code is still there, so it can be enabled if anyone wants it.
> >
> >> or a stub should be added to udev to always fail firmware loading so timeouts don't occur.
> >
> > I think the only use (if any) of a userspace firmware loader would be
> > for anyone who wants a custom one (i.e., not udev), so we shouldn't
> > just fail the loading from udev unconditionally.
> >
> > How about we just improve the udev documentation a bit, similar to
> > Andy's kernel patch?
> 
> Sorry, I should first have checked. We already document this in the README:
> 
> >        Userspace firmware loading is deprecated, will go away, and
> >        sometimes causes problems:
> >          CONFIG_FW_LOADER_USER_HELPER=n

...And this patch is making the kernel default to the correct behavior,
instead of the now-broken-by-udev behavior.

I'm not sure I see the issue with it?  :-)

(Add me to the list of people that think udev is broken too, fwiw.  But
let's at least not leave *both* sides in a broken-by-default state.)

