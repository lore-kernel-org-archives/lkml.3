Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbaG2PWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:22:43 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:60605 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbaG2PWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:22:40 -0400
Date: Tue, 29 Jul 2014 19:22:36 +0400
From: Andrey Borzenkov <arvidjaar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Richard Weinberger <richard@nod.at>, mike.marciniszyn@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        OpenSUSE Kernel Team <opensuse-kernel@opensuse.org>
Subject: Re: [opensuse-kernel] Re: Kernel binrpm produces brokes grub2
 config
Message-ID: <20140729192236.2165e5b5@opensuse.site>
In-Reply-To: <53D7925A.8080200@suse.cz>
References: <53D774F9.3090305@nod.at>
	<53D7925A.8080200@suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Tue, 29 Jul 2014 14:23:54 +0200
Michal Marek <mmarek@suse.cz> пишет:

> On 2014-07-29 12:18, Richard Weinberger wrote:
> > Hi!
> > 
> > I'm not sure who to blame, but the below commit breaks the kernel binrpm target for me.
> > It produces a faulty grub2 config.
> > After installing such a kernel grub2 looks for vmlinuz-XY-rpm and initrd-XY-rpm.
> > These files are not existing and the machine does no longer boot.
> > Luckily an addition boot entry without the -rpm suffix exists, if remote access works
> > one can recover the machine.
> > 
> > My question is, why do we need these copy of vmlinuz anyway?
> > After calling installkernel on the -rpm variants you delete them again...
> 
> The typical /sbin/installkernel script does a cp "$2" "/boot/...", so
> you can't use the already installed files as its arguments.
> 
> 
> > This <insert swear word here> happens on openSUSE 13.1, maybe their installkernel script needs fixing.
> 
> I guess that the problem is that grub2-mkconfig sees the temporary
> /boot/vmlinuz-*-rpm file and creates a menu entry for it. I guess we
> should create the temporary kernel and initrd files somewhere else than
> in /boot.
> 

Or name it differently - e.g. rpm-vmlinuz-XY.

> Michal
> 

