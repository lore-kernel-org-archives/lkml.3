Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab3BWAx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 19:53:58 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41806 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab3BWAx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 19:53:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Dave Jones <davej@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        tianyu.lan@intel.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
Date: Sat, 23 Feb 2013 02:00:34 +0100
Message-ID: <1705229.vSbifsr2b3@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130222215158.GA4723@balto.lan>
References: <20130222085954.GA4352@redhat.com> <20130222215158.GA4723@balto.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 22, 2013 10:51:58 PM Fabio Baltieri wrote:
> On Fri, Feb 22, 2013 at 03:59:54AM -0500, Dave Jones wrote:
> > On Thu, Feb 21, 2013 at 10:40:10AM -0800, Greg KH wrote:
> > 
> >  > USB patches for 3.9-rc1
> >  > 
> >  > Here's the big USB merge for 3.9-rc1
> >  > 
> >  > Nothing major, lots of gadget fixes, and of course, xhci stuff.
> > 
> > I get no USB devices recognised when I insert them any more, which
> > I think is pretty major.  I suspect it has something to do with this ?
> > 
> >  > Lan Tianyu (12):
> >  >       usb: add runtime pm support for usb port device
> >  >       usb: add usb port auto power off mechanism
> > 
> > It looks like every port on my laptop is powered down, as I can't
> > even charge devices with it.
> 
> Hi Dave,
> 
> I have the same problem (and almost the same laptop, Thinkpad T430
> here), all external USB ports without power - even the always-on one
> :-).
> 
> The bug seems to be ACPI related, I bisected it down to this patch:
> 
> f95988d ACPI / scan: Treat power resources in a special way
> 
> In the dmesg I have some error like these:
> 
> ACPI: Power Resource [PUBS] (on)
> ...
> pci 0000:00:14.0: System wakeup disabled by ACPI
> 
> for the USB controllers in the broken kernel, there are some in your
> dmesg too.  I'll try to come up with a fix for current mainline, but all
> the acpi stuff is quite obscure to me and the patch does not revert
> cleanly, maybe Rafael (in CC) has some idea!

May I see the bisection log, BTW?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
