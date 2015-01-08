Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601AbbAHOBF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:01:05 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34375 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbbAHOBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:01:02 -0500
MIME-Version: 1.0
In-Reply-To: <1420663980-20842-7-git-send-email-zohar@linux.vnet.ibm.com>
References: <1420663980-20842-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1420663980-20842-7-git-send-email-zohar@linux.vnet.ibm.com>
Date: Thu, 8 Jan 2015 09:01:01 -0500
X-Google-Sender-Auth: 5MsbGB7smhPkqEFSeFfqICHLTFk
Message-ID: <CA+5PVA77x2W9LyHMq1jSW3HKqNgFPz-gPVOH0QtEmmMBwzOx_Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 6/9] gen_initramfs_list.sh: include xattrs
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: initramfs <initramfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 3:52 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> This patch modifies the gen_initramfs_list.sh script to include xattrs
> in the initramfs.
>
> Dracut creates the initramfs using the cpio tool on the system, not
> the kernel's gen_init_cpio script. The following commands, for example,
> would create an initramfs containing xattrs.
>
> dracut -H -f /boot/initramfs-3.XX.0+.img 3.XX.0+ -M --keep \
>         --noprelink --nostrip
> gen_initramfs_list.sh /var/tmp/initramfs.XXXXXX/ > \
>         /var/tmp/initramfs_list.XXXXXX
>
> [Sign files here, if not already signed, using evmctl.]
>
> gen_init_cpio -x /var/tmp/initramfs_list.XXXXXX >  \
>         /boot/initramfs-3.XX.0+test.img

That's pretty awkward.  I think it highlights the major downside of
this approach in that from a standard distro point of view this
functionality isn't likely to be used.  Do you foresee this feature as
something that should be widely used, or something that would be used
more in custom, locked-down machines?

I can understand not wanting to redefine the newc format in userspace
cpio, but if you want this to be easier to use then perhaps working
with dracut upstream to make it support this out of the box would be a
good idea.

josh
