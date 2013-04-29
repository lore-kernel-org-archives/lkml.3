Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab3D2VcC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:32:02 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:64473 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3D2VcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:32:00 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1304291706360.1152-100000@iolanthe.rowland.org>
References: <CA+55aFxi+PHvYwxLJfo=YG=93maOD0cQYVdjvG8kzEhpOZykpQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1304291706360.1152-100000@iolanthe.rowland.org>
Date: Mon, 29 Apr 2013 14:31:59 -0700
X-Google-Sender-Auth: EL2AoCs8P33Vg0UnFKgYPqBXz4Q
Message-ID: <CA+55aFzOf3tE=Mbrrwt_aOn6GdUv26VnJ=wsmY2sYC90-aUfLQ@mail.gmail.com>
Subject: Re: [GIT PATCH] USB patches for 3.10-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 2:14 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> What other things seemed odd about Greg's pull request?

The only other thing I noticed was the new CONFIG_USB_PHY quesiton,
which is not something that I think is sensible to ask from a user,
and the help text doesn't really help anything either.

I think the question may make sense, but the wording does not.

*EVERYBODY* wants a USB PHY. You can't have USB without a physical
layer unless it's a purely virtual device. There's one in a EHCI
controller too. It's like a network chip - without a PHY there's no
point. Why ask about whether you want to support a phy or not? The
question makes no sense.

So I don't think the question should be "do you want a USB PHY". The
question should be "Do you want a driver for some of the specialized
external USB controllers" or something like that. Because as it is
now, anybody who actually reads the question is likely to answer "y",
I think, even if he just wants one of the *normal* USB chips that
don't split out the PHY.

Hmm? Or does PHY have some magic other meaning in USB circles? In
which case the wording should still be totally redone to not be so
confusing and misleading.

                     Linus
