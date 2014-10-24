Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbaJXQOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:14:03 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52857 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaJXQOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:14:01 -0400
Date: Fri, 24 Oct 2014 09:13:54 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: balbi@ti.com, LKML <linux-kernel@vger.kernel.org>,
        ravindrakumar@vmware.com, Thomas Hellstrom <thellstrom@vmware.com>,
        akataria@vmware.com
Subject: Re: current mainline doesn't boot on VWware platform
Message-ID: <20141024161354.GB19933@dtor-ws>
References: <CAH2r5mvBOJHLbRXHMt50E97_1E2Q8F_=PH9=u6N3yuuqSQVmDg@mail.gmail.com>
 <20141017234445.GA28891@saruman>
 <CAH2r5mtsh9KsVYJJWebJffvdQxOVTzM4cNM30q8hYOG=Bwj8eA@mail.gmail.com>
 <CAH2r5msu+=8Ae_OCP92oRT1UnybBBYLKpx-YbVUe8hhifxouaA@mail.gmail.com>
 <CAH2r5mtORD1K-L49cNJaAFb1=ZRvS7JjQ5fba+SLedHaSYdnBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mtORD1K-L49cNJaAFb1=ZRvS7JjQ5fba+SLedHaSYdnBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Sat, Oct 18, 2014 at 09:02:15PM -0500, Steve French wrote:
> Interesting to see that Fedora has similar problems with current
> kernel (I pulled mainline again a few hours ago).
> 
> Fedora 20 x86_64 in vmware boots to logon prompt but no mouse, no
> keyboard, system hung.  Ctl-alt-f1 doesn't do anything.  Even with
> verbose on kernel boot line, the extra debug messages have all been
> cleared by the time the hang occurs so nothing useful displayed.
> 
> To be as safe as possible I used their default .config
> /boot/config-3.16.6-200.fc20.x86_64 to do a clean build of mainline.
> Once again, 3.16 and 3.17 work but not current mainline.

Let's add a few VMware people. I am pretty sure they'd be interested in
why it does not work.

Guys, could you please route as appropriate.

Thanks.

> 
> On Sat, Oct 18, 2014 at 4:52 PM, Steve French <smfrench@gmail.com> wrote:
> > Same thing happened after pulling newly updated mainline kernel
> > changes a few minutes ago.
> >
> > Black screen on boot just when you would expect x to be starting.
> > Hung. Ctl-alt-F1 doesn't do anything.
> >
> > arch is x86_64.
> >
> > 3.17.1 works.  When I get time I will see if I can figure out more
> > useful info but this looks like a pretty boring setup:
> >
> > sfrench@ubuntu:~$ glxinfo | grep -i "vendor"
> > server glx vendor string: SGI
> > client glx vendor string: Mesa Project and SGI
> > OpenGL vendor string: VMware, Inc.
> > sfrench@ubuntu:~$ grep LoadModule /var/log/Xorg.0.log
> > [    18.271] (II) LoadModule: "glx"
> > [    18.288] (II) LoadModule: "vmware"
> > [    18.352] (II) LoadModule: "modesetting"
> > [    18.355] (II) LoadModule: "fbdev"
> > [    18.360] (II) LoadModule: "vesa"
> > [    18.369] (II) LoadModule: "fbdevhw"
> > [    18.372] (II) LoadModule: "fb"
> > [    18.379] (II) LoadModule: "dri2"
> > [    18.479] (II) LoadModule: "evdev"
> > [    18.484] (II) LoadModule: "vmmouse"
> >
> > On Fri, Oct 17, 2014 at 6:52 PM, Steve French <smfrench@gmail.com> wrote:
> >> This is vmware guest
> >>
> >> sfrench@ubuntu:~/xfstests$ cat /proc/cpuinfo
> >> processor    : 0
> >> vendor_id    : GenuineIntel
> >> cpu family    : 6
> >> model        : 70
> >> model name    : Intel(R) Core(TM) i7-4750HQ CPU @ 2.00GHz
> >>
> >> (and using 64 bit kernel build) ...
> >>
> >> I don't have the Ubuntu config for their mainline kernel test builds
> >> any more (deleted the kernel since it didn't work) but they post their
> >> .config diffs at
> >> http://kernel.ubuntu.com/~kernel-ppa/mainline/daily/current/
> >>
> >> I could not get to a console so assumed it died in kernel as x was
> >> coming up.  I will have to reinstall current mainline to see if I can
> >> hook up a serial console (I had maximum kernel boot verbose in the
> >> grub.cfg but nothing interesting before the black screen)
> >>
> >> On Fri, Oct 17, 2014 at 6:44 PM, Felipe Balbi <balbi@ti.com> wrote:
> >>> Hi,
> >>>
> >>> On Fri, Oct 17, 2014 at 05:44:02PM -0500, Steve French wrote:
> >>>> Anyone know a workaround for the problem booting current mainline?
> >>>> 3.17 works fine for me, but recent mainline since 3.17 goes to a black
> >>>> screen near the end of boot as X is about to start.
> >>>>
> >>>> I also tried the Ubuntu build of the day (which also is based on
> >>>> current mainline but with the Ubuntu config just in case it was some
> >>>> driver issue) which fails the same way.
> >>>
> >>> you need to provide more information, here are a few queries which might
> >>> help:
> >>>
> >>> 1. which architecture ?
> >>> 2. Can you get a serial console to get some dmesg output ?
> >>> 3. after screen is black, can you ctrl + alt + F1 and get a console ?
> >>> 4. where's you .config ?
> >>>
> >>> --
> >>> balbi
> >>
> >>
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Dmitry
