Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbaAHUWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:22:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaAHUWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:22:35 -0500
Date: Wed, 8 Jan 2014 12:23:05 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Frank =?iso-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: sysfs warnings since kernel 3.13-rc1:  "WARNING: ... at
 fs/sysfs/group.c:214 sysfs_remove_group"
Message-ID: <20140108202305.GA8417@kroah.com>
References: <52CC3D1A.9050109@googlemail.com>
 <20140107175925.GC3231@htj.dyndns.org>
 <52CDAEA2.2000801@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52CDAEA2.2000801@googlemail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 09:01:38PM +0100, Frank Schäfer wrote:
> Am 07.01.2014 18:59, schrieb Tejun Heo:
> > Hello,
> >
> > cc'ing Mauro and quoting whole body for him.
> >
> > So, ummm, the sysfs rule was that any group below a device should be
> > removed before the device itself is removed; however, nothing really
> > checked whether this actually was the case.  We didn't care whether
> > the order was reversed and if somebody forgot to remove the group
> > afterwards, we just leaked it.  After this commit, sysfs now whines if
> > the order is reversed, so the warning.
> >
> > While this should probably be fixed from the v4l side, I'm really
> > skeptical we're gaining anything by requiring users to explicitly
> > remove groups during device removal.  In most cases, this is a
> > completely unnecessary task.  Maybe we should just hunt down all
> > remove_group calls and remove all the unnecessary ones.
> >
> > Thanks.
> What about the USB mass storage devices ?
> Is it just a coincidence that this happens with two completely different
> types of USB devices ?

Yes it is, there's a big long thread on the linux-usb and scsi mailing
lists about this, and the fix should be final soon.

thanks,

greg k-h
