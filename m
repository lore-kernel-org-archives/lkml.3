Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaKDAiw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:38:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaKDAiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:38:50 -0500
Date: Mon, 3 Nov 2014 16:38:49 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Ming Lei <ming.lei@canonical.com>,
        Sam Protsenko <semen.protsenko@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH v2 0/3] Enable user helper interface for efi capsule
 update
Message-ID: <20141104003849.GA15147@kroah.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <5457D883.4050201@amacapital.net>
 <20141103212706.GE7379@kroah.com>
 <CALCETrUNCuFvwkzbU4dWB0GH4mJKKV1e6jCNrSLVJe+n_et3kQ@mail.gmail.com>
 <20141103230234.GA9427@kroah.com>
 <CALCETrUtxqLaziC_f6iTEgKNhmTgJR6bOLJ=e=O22X_RsBc9sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUtxqLaziC_f6iTEgKNhmTgJR6bOLJ=e=O22X_RsBc9sw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 03:08:08PM -0800, Andy Lutomirski wrote:
> On Mon, Nov 3, 2014 at 3:02 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Mon, Nov 03, 2014 at 01:32:46PM -0800, Andy Lutomirski wrote:
> >> On Mon, Nov 3, 2014 at 1:27 PM, Greg Kroah-Hartman
> >> <gregkh@linuxfoundation.org> wrote:
> >> > On Mon, Nov 03, 2014 at 11:33:23AM -0800, Andy Lutomirski wrote:
> >> >> On 11/02/2014 07:07 PM, Kweh Hock Leong wrote:
> >> >> > From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >> >> >
> >> >> > Hi Guys,
> >> >> >
> >> >> > This patchset is created on top of "efi: Capsule update support" patch:
> >> >> > http://permalink.gmane.org/gmane.linux.kernel.efi/4837
> >> >> >
> >> >> > It leverages the request_firmware_nowait() to expose the user helper interface for user to upload the capsule binary and calling the
> >> >> > efi_capsule_update() API to pass the binary to EFI firmware.
> >> >>
> >> >> I don't get it.  Why is the firmware interface at all reasonable for
> >> >> uploading capsules?
> >> >
> >> > Tradition dictates that BIOS updates go through the firmware interface,
> >> > that way you don't have to write a new userspace tool, which is a good
> >> > thing.
> >> >
> >> >> The firmware interface makes sense for nonvolatile firmware where
> >> >> hotplugging something or otherwise loading a driver needs a blob.
> >> >
> >> > Or BIOS data.  We've been doing it this way for a long time now.
> >>
> >> On what system?  Dell?
> >
> > Yes.
> >
> >> IMO this sucks from a UI point of view.  When I install wifi firmware,
> >> I expect to stick it somewhere and have the driver find it, because
> >> the driver knows exactly when it needs the firmware.  When I update my
> >> BIOS, I want to click a button or type a command and update my bios.
> >
> > I agree, it should be "triggered" by something, not just automagically
> > loaded whenever the kernel randomly looks for it.
> >
> >> >> But uploading an EFI capsule is an *action*, not something that should
> >> >> happen transparently.  If there's an EFI firmware update available and
> >> >> the user wants to install it, then the userspace tool should install it,
> >> >> and it shouldn't hang around in /lib/firmware.  In fact, you shouldn't
> >> >> even need /lib to be on writable media to use this.
> >> >
> >> > What does /lib have to do with this?
> >>
> >> Where else does the file come from, given that udev no longer supports
> >> userspace firmware loading?  Is there really some pre-existing tool
> >> that pokes it into the sysfs firmware class thing?
> >
> > Well, you can specify other locations than /lib/firmware/ for firmware
> > updates, but yes, you are right, it should be in /lib somewhere.  But
> > /lib doesn't need to be writable, it's a read-only file.
> >
> 
> I assume that whoever downloaded the firmware update will want to
> install it, right?  I don't really expect distros to ship EFI capsules
> in packages that install to /lib/firmware.  Won't there be userspace
> code that either installs a capsule from some URL or uses some future
> magical find-my-firmware service?

Good point, I don't know.

Who ever wrote this code should know this, can someone please provide a
use-case for how this is all supposed to work?

thanks,

greg k-h
