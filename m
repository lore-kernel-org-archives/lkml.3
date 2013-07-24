Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3GXQiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:38:55 -0400
Received: from tango.0pointer.de ([85.214.72.216]:50114 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3GXQiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:38:54 -0400
Date: Wed, 24 Jul 2013 18:38:52 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Richard Weinberger <richard@nod.at>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
Message-ID: <20130724163852.GV835@tango.0pointer.de>
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
 <51E988FF.9010201@nod.at>
 <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
 <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com>
 <51ED0BBF.7060502@nod.at>
 <CALkWK0mpH9XHL2PZK47Lb9frf9hFNQ8sjF2_0p7VJnY8XWhiGw@mail.gmail.com>
 <20130722223238.GC13191@tango.0pointer.de>
 <51EE1765.2000402@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EE1765.2000402@nod.at>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23.07.13 07:40, Richard Weinberger (richard@nod.at) wrote:

> >>>>> UML shouldn't be penalized for not implementing some terminal emulation,
> >>>>> but it should be penalized for doing so under the label of "VT support",
> >>>>> which it simply is not providing.
> >>>>>
> >>>>> They can call their ttys any way they want. If the call them
> >>>>> /dev/tty[1..64] however, then they need to implement the VC
> >>>>> interfaces. All of them.
> >>>
> >>> Lennart, can you please explain us why /dev/tty[1..64] is forced to
> >>> have virtual console support?
> > 
> > /dev/tty[1..64] is the userspace API to the kernel VT subsystem. If you
> > support it you need to match up all /dev/tty[1..64] with a
> > /dev/vcs[1..64] + /dev/vcsa[1..64]. You need to expose a tty that
> > understands TERM=linux and the ioctls listed on console_ioctl(4). You
> > need /dev/tty0 as something that behaves like a symlink to the fg
> > VT. You should also support files like /sys/class/tty/tty0/active with
> > its POLLHUP iface.
> 
> I sightly disagree with you.
> /dev/tty[1..64] is not directly bound to VT.
> You can have systems with CONFIG_VT=n and still have /dev/tty[1..64].
> Linux supports this perfectly.
> UML does not have VT because having virtual consoles makes no sense.
> (Same like on s390)

You are aware that turning off the tty subsystem in the kernel is
something different than turning off the virtual console? Note that the
whole stuff is really confusingly named, as /dev/tty1 is genericly named
"tty", even if it actually refers to a virtual console tty and nothing else.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
