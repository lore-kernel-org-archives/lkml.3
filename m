Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907Ab3D2Tlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:41:31 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:48399 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759427Ab3D2TlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:41:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130429162328.GA6963@kroah.com>
References: <20130429162328.GA6963@kroah.com>
Date: Mon, 29 Apr 2013 12:41:24 -0700
X-Google-Sender-Auth: Z9NONkrHqkd7WXSv4H2d97b5Hxw
Message-ID: <CA+55aFxi+PHvYwxLJfo=YG=93maOD0cQYVdjvG8kzEhpOZykpQ@mail.gmail.com>
Subject: Re: [GIT PATCH] USB patches for 3.10-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 9:23 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/ tags/usb-3.10-rc1

This has some odd things in it, but I made the mistake of pushing out
my merge before I noticed, so it's out there now regardless.

See here: commit 84ebc10294a3 ("USB: remove CONFIG_USB_SUSPEND
option") claims to remove the USB_SUSPEND config option, but doesn't
actually do so.

And no, it's not my merge that is in error, although there may be
merge errors in addition to the oddities I've found. Doing a

   git grep -w USB_SUSPEND 84ebc10294a3

shows that there remains things that have "depends on .. USB_SUSPEND"
even in the very commit that claims to remove the option. Later
commits then move them around (eg the whole drivers/usb/otg ->
drivers/usb/phy movement), but the USB_SUSPEND stays around.

Hmm? I'm assuming you applied a patch without noticing that in the
meantime other users of USB_SUSPEND had grow up?

                Linus
