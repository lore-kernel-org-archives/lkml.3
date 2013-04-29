Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab3D2VS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:18:58 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:49139 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758773Ab3D2VS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:18:56 -0400
MIME-Version: 1.0
In-Reply-To: <8yafvy92gfs.fsf@huya.qualcomm.com>
References: <20130429162115.GA6893@kroah.com>
	<CA+55aFwU-bXZ7wn2dOcLNfPMcjDv3Jvqx_LTt7B+-tj4WcP8Mg@mail.gmail.com>
	<CA+55aFzLtBwsvVrnT2DrUOU+eYrQ5eiKeamRb4Y5+-TVgbuM5Q@mail.gmail.com>
	<201304292154.15920.arnd@arndb.de>
	<CA+55aFzefpRz2Y8oW9q0ArrR=XW0POBhy8NSNJ3DrCh9EowLqg@mail.gmail.com>
	<8yafvy92gfs.fsf@huya.qualcomm.com>
Date: Mon, 29 Apr 2013 14:18:55 -0700
X-Google-Sender-Auth: 9SiyNtzOgPCuLWej8w0dJGNioL4
Message-ID: <CA+55aFxaMP+=uMLLvnLHz_E0GStrDf_zO3XhVCDGHbk=tV6CqA@mail.gmail.com>
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Brown <davidb@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 2:08 PM, David Brown <davidb@codeaurora.org> wrote:
>
> So, what is this saner place?  The hardware is theoretically shared
> between ARM and Hexagon, but I don't know the hexagon plans to support
> it, I've added them to the CC.

So I actually wouldn't have complained about it in drivers/misc/ssbi/
or something like that. I don't think that's necessarily the best
place for it, and maybe somebody can come up with better places. But
even just in drivers/misc, at least you've moved it away to the point
that it doesn't potentially compete with the pathname auto-completion
of the fifty million other drivers we have under drivers/.

Or maybe "drivers/platform/something-or-other" if there are possible
other things that get shared together with this thing? I don't care
that deeply, as long as it's just off in a little corner of the
universe, rather than smack-dab in the middle.

              Linus
