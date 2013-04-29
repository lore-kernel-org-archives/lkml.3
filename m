Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785Ab3D2VO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:14:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55565 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759532Ab3D2VO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:14:27 -0400
Date: Mon, 29 Apr 2013 17:14:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [GIT PATCH] USB patches for 3.10-rc1
In-Reply-To: <CA+55aFxi+PHvYwxLJfo=YG=93maOD0cQYVdjvG8kzEhpOZykpQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1304291706360.1152-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Apr 2013, Linus Torvalds wrote:

> On Mon, Apr 29, 2013 at 9:23 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.10-rc1
> 
> This has some odd things in it, but I made the mistake of pushing out
> my merge before I noticed, so it's out there now regardless.
> 
> See here: commit 84ebc10294a3 ("USB: remove CONFIG_USB_SUSPEND
> option") claims to remove the USB_SUSPEND config option, but doesn't
> actually do so.
> 
> And no, it's not my merge that is in error, although there may be
> merge errors in addition to the oddities I've found. Doing a
> 
>    git grep -w USB_SUSPEND 84ebc10294a3
> 
> shows that there remains things that have "depends on .. USB_SUSPEND"
> even in the very commit that claims to remove the option. Later
> commits then move them around (eg the whole drivers/usb/otg ->
> drivers/usb/phy movement), but the USB_SUSPEND stays around.

Strange.  I was quite sure at the time that I had removed all traces of
USB_SUSPEND, but clearly that was wrong.

Anyway, I'll send in a patch to remove the remaining usages.  Many of
them are in comments, but some are in Kconfig files where they will
really matter.

> Hmm? I'm assuming you applied a patch without noticing that in the
> meantime other users of USB_SUSPEND had grow up?

Or they survived in some other manner.  It's possible that I edited
these files but then failed to include them in the final patch.

What other things seemed odd about Greg's pull request?

Alan Stern

