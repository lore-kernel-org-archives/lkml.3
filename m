Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbaJXReU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:34:20 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:56852 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756580AbaJXReS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:34:18 -0400
From: Ravindra Kumar <ravindrakumar@vmware.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Steve French <smfrench@gmail.com>
CC: "balbi@ti.com" <balbi@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Alok Kataria <akataria@vmware.com>
Subject: RE: current mainline doesn't boot on VWware platform
Thread-Topic: current mainline doesn't boot on VWware platform
Thread-Index: AQHP76W1JzKRPeg+00yQ1GILAboUdZw/gPoA
Date: Fri, 24 Oct 2014 17:34:15 +0000
Message-ID: <779999aedd3844bd9ad60abf0941721c@EX13-MBX-026.vmware.com>
References: <CAH2r5mvBOJHLbRXHMt50E97_1E2Q8F_=PH9=u6N3yuuqSQVmDg@mail.gmail.com>
 <20141017234445.GA28891@saruman>
 <CAH2r5mtsh9KsVYJJWebJffvdQxOVTzM4cNM30q8hYOG=Bwj8eA@mail.gmail.com>
 <CAH2r5msu+=8Ae_OCP92oRT1UnybBBYLKpx-YbVUe8hhifxouaA@mail.gmail.com>
 <CAH2r5mtORD1K-L49cNJaAFb1=ZRvS7JjQ5fba+SLedHaSYdnBg@mail.gmail.com>
 <20141024161354.GB19933@dtor-ws>
In-Reply-To: <20141024161354.GB19933@dtor-ws>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.113.160.246]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, could it be same as https://bugs.freedesktop.org/show_bug.cgi?id=80645 again?

-----Original Message-----
From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com] 
Sent: Friday, October 24, 2014 9:14 AM
To: Steve French
Cc: balbi@ti.com; LKML; Ravindra Kumar; Thomas Hellstrom; Alok Kataria
Subject: Re: current mainline doesn't boot on VWware platform

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

Let's add a few VMware people. I am pretty sure they'd be interested in why it does not work.

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
> > client glx vendor string: Mesa Project and SGI OpenGL vendor string: 
> > VMware, Inc.
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
> >> I don't have the Ubuntu config for their mainline kernel test 
> >> builds any more (deleted the kernel since it didn't work) but they 
> >> post their .config diffs at
> >> https://urldefense.proofpoint.com/v1/url?u=http://kernel.ubuntu.com
> >> /~kernel-ppa/mainline/daily/current/&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%
> >> 3D%0A&r=oGRqRJb%2BhkJPg50%2BV8ZXHpwGAxAMbFoFF8Oa3SfNFqg%3D%0A&m=KT3
> >> nd2WvOtmE3TxnuxeU7ySPrD7G91YtKCITDaK7aC0%3D%0A&s=84cc4ce1780ae7d054
> >> e8d381139ece045075711529a3f3a8a1b7080c86d56324
> >>
> >> I could not get to a console so assumed it died in kernel as x was 
> >> coming up.  I will have to reinstall current mainline to see if I 
> >> can hook up a serial console (I had maximum kernel boot verbose in 
> >> the grub.cfg but nothing interesting before the black screen)
> >>
> >> On Fri, Oct 17, 2014 at 6:44 PM, Felipe Balbi <balbi@ti.com> wrote:
> >>> Hi,
> >>>
> >>> On Fri, Oct 17, 2014 at 05:44:02PM -0500, Steve French wrote:
> >>>> Anyone know a workaround for the problem booting current mainline?
> >>>> 3.17 works fine for me, but recent mainline since 3.17 goes to a 
> >>>> black screen near the end of boot as X is about to start.
> >>>>
> >>>> I also tried the Ubuntu build of the day (which also is based on 
> >>>> current mainline but with the Ubuntu config just in case it was 
> >>>> some driver issue) which fails the same way.
> >>>
> >>> you need to provide more information, here are a few queries which 
> >>> might
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
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  
> https://urldefense.proofpoint.com/v1/url?u=http://vger.kernel.org/majo
> rdomo-info.html&k=oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=oGRqRJb%2BhkJPg5
> 0%2BV8ZXHpwGAxAMbFoFF8Oa3SfNFqg%3D%0A&m=KT3nd2WvOtmE3TxnuxeU7ySPrD7G91
> YtKCITDaK7aC0%3D%0A&s=f6dee438ce2574b1716d6a58b14eb1caba3359030b6078f4
> 4b03085dcee6e646 Please read the FAQ at  
> https://urldefense.proofpoint.com/v1/url?u=http://www.tux.org/lkml/&k=
> oIvRg1%2BdGAgOoM1BIlLLqw%3D%3D%0A&r=oGRqRJb%2BhkJPg50%2BV8ZXHpwGAxAMbF
> oFF8Oa3SfNFqg%3D%0A&m=KT3nd2WvOtmE3TxnuxeU7ySPrD7G91YtKCITDaK7aC0%3D%0
> A&s=5dd0796c72e00951cd35629a25ba29a57334984e4e164fd69c9052abe8380319

--
Dmitry
