Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbbAHPN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:13:27 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:59322 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932302AbbAHPNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:13:24 -0500
Message-ID: <1420729994.6338.52.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC][PATCH 6/9] gen_initramfs_list.sh: include xattrs
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: initramfs <initramfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>,
        Rob Landley <rob@landley.net>
Date: Thu, 08 Jan 2015 10:13:14 -0500
In-Reply-To: <CA+5PVA77x2W9LyHMq1jSW3HKqNgFPz-gPVOH0QtEmmMBwzOx_Q@mail.gmail.com>
References: <1420663980-20842-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1420663980-20842-7-git-send-email-zohar@linux.vnet.ibm.com>
	 <CA+5PVA77x2W9LyHMq1jSW3HKqNgFPz-gPVOH0QtEmmMBwzOx_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010815-0005-0000-0000-0000034CC33A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-08 at 09:01 -0500, Josh Boyer wrote: 
> On Wed, Jan 7, 2015 at 3:52 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > This patch modifies the gen_initramfs_list.sh script to include xattrs
> > in the initramfs.
> >
> > Dracut creates the initramfs using the cpio tool on the system, not
> > the kernel's gen_init_cpio script. The following commands, for example,
> > would create an initramfs containing xattrs.
> >
> > dracut -H -f /boot/initramfs-3.XX.0+.img 3.XX.0+ -M --keep \
> >         --noprelink --nostrip
> > gen_initramfs_list.sh /var/tmp/initramfs.XXXXXX/ > \
> >         /var/tmp/initramfs_list.XXXXXX
> >
> > [Sign files here, if not already signed, using evmctl.]
> >
> > gen_init_cpio -x /var/tmp/initramfs_list.XXXXXX >  \
> >         /boot/initramfs-3.XX.0+test.img
> 
> That's pretty awkward.  I think it highlights the major downside of
> this approach in that from a standard distro point of view this
> functionality isn't likely to be used.  Do you foresee this feature as
> something that should be widely used, or something that would be used
> more in custom, locked-down machines?

Before distros can start enabling these features, software packages need
to come with file signatures.  Fin Gunter posted (and shortly will
re-post) patches to include file signatures in RPM patches.

Including file signatures in RPM packages (and similarly in other
software package formats) is the direction we, the linux community, IMHO
should be moving.  How long this will take is entirely up to the
distros.

> I can understand not wanting to redefine the newc format in userspace
> cpio, but if you want this to be easier to use then perhaps working
> with dracut upstream to make it support this out of the box would be a
> good idea.

Anyone using dracut/systemd is currently not using tmpfs, as specifying
"root=" on the boot command line reverts to using ramfs.  Rob Landley
suggested userspace apps use "ROOT=" instead.
(http://sourceforge.net/p/linux-ima/mailman/message/33189705/)

This patch set was posted as an RFC.  Assuming this solution for
including xattrs in the rootfs is acceptable, I'll post the
dracut/systemd changes.

Mimi

