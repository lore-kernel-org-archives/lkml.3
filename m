Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbaKCV1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 16:27:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaKCV1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 16:27:07 -0500
Date: Mon, 3 Nov 2014 13:27:06 -0800
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
Message-ID: <20141103212706.GE7379@kroah.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <5457D883.4050201@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5457D883.4050201@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 11:33:23AM -0800, Andy Lutomirski wrote:
> On 11/02/2014 07:07 PM, Kweh Hock Leong wrote:
> > From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Hi Guys,
> > 
> > This patchset is created on top of "efi: Capsule update support" patch:
> > http://permalink.gmane.org/gmane.linux.kernel.efi/4837
> > 
> > It leverages the request_firmware_nowait() to expose the user helper interface for user to upload the capsule binary and calling the
> > efi_capsule_update() API to pass the binary to EFI firmware.
> 
> I don't get it.  Why is the firmware interface at all reasonable for
> uploading capsules?

Tradition dictates that BIOS updates go through the firmware interface,
that way you don't have to write a new userspace tool, which is a good
thing.

> The firmware interface makes sense for nonvolatile firmware where
> hotplugging something or otherwise loading a driver needs a blob.

Or BIOS data.  We've been doing it this way for a long time now.

> But uploading an EFI capsule is an *action*, not something that should
> happen transparently.  If there's an EFI firmware update available and
> the user wants to install it, then the userspace tool should install it,
> and it shouldn't hang around in /lib/firmware.  In fact, you shouldn't
> even need /lib to be on writable media to use this.

What does /lib have to do with this?

> And you most certainly don't want the EFI capsule hanging around so that
> it might be accidentally installed again if the hard disk is moved.
> 
> ISTM there should be some file in sysfs to which you can write a
> capsule, or perhaps a chardev and an ioctl.

No, just use the firmware interface please.

thanks,

greg k-h
