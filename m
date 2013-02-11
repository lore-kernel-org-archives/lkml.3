Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab3BKV7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 16:59:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691Ab3BKV7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 16:59:35 -0500
Date: Mon, 11 Feb 2013 16:59:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] initramfs with digital signature protection
Message-ID: <20130211215929.GB24936@redhat.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
 <cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
 <20130207170542.GF6462@redhat.com>
 <CALLzPKYCjihDy32=ZQbwVN0jEitVCWKadFCxjN=vw2GnBUFmyA@mail.gmail.com>
 <CALLzPKZpzDY0b_GvYgiKWeu1KFeLqyfKaKzBbiw8ze6ssE2N6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKZpzDY0b_GvYgiKWeu1KFeLqyfKaKzBbiw8ze6ssE2N6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 03:27:30PM +0200, Kasatkin, Dmitry wrote:
> >>
> >> Dmitry,
> >>
> >> How do we make sure that this is the first call to user mode helpers. I
> >> see that we first unpacked unsigned initramfs. Then after a while we
> >> unpacked signed initramfs on /root and did a chroot. But now there is
> >> a window before chroot, where kernel might call into /sbin/hotplug or
> >> /sbin/modprobe from unsigned initramfs?
> >>
> >> Specifically, I put some printk and I am seeing calls to /sbin/hotplug
> >> before we even unpacked signed initramfs.
> >
> 
> I did some experiments and made this  patch which prevents launching
> of user mode helpers before pre-init from signed image is executed.
> 
> I do not know if this is the right way to do it, but at least it works for me.
> The whole idea of these patches is to allow simple usage of signed image,
> without the need to modify kernel parameters (0 block) and boot loaders....
> 
> --------------------------------------------------------------------------------------------------
> commit a99eaa06ab142906da67800423425b7c5def0a3e
> Author: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> Date:   Fri Feb 8 15:05:22 2013 +0200
> 
>     initramfs_sig: prevent usermode helpers before signed image is executed
> 
>     This patch prevents execution of user mode helper before /pre-init
>     is executed.
> 
>     Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

Yep. This seems to have blocked the calls going out to user space and
returns with -EBUSY

Thanks
Vivek
