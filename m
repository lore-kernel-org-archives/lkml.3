Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab3D2Szh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:55:37 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:60277 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255Ab3D2Szf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:55:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130429183851.GA8106@kroah.com>
References: <20130429162115.GA6893@kroah.com>
	<CA+55aFz7bESS-T2_5vndVEzbk7ocmfEanBO+sviTSNekOLKRcg@mail.gmail.com>
	<20130429183851.GA8106@kroah.com>
Date: Mon, 29 Apr 2013 11:55:34 -0700
X-Google-Sender-Auth: 9MesoHlYbpO_BwJXLYTHipxXObs
Message-ID: <CA+55aFwU-bXZ7wn2dOcLNfPMcjDv3Jvqx_LTt7B+-tj4WcP8Mg@mail.gmail.com>
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Brown <davidb@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 11:38 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> It's a "bus" type, that has individual drivers connecting to it.

No it isn't, and no it doesn't.

It's a "bus" exactly the same way the PS2 driver is a "bus", and it
has individual devices connecting to it exactly the same way we have
keyboards and mice connecting to the PS2 driver.

Except at least the PS2 driver is documented somewhere, and has been
done by multiple different vendors. Afaik, ssbi is a single
implementation by qualcomm or something.

Yes, we could have "drivers/ps2" too. Except we don't. It's actually
hidden down in drivers/input/serio/.

Now, maybe I'm wrong, and maybe SSBI is some next-gen super-bus that
just hides all the information about itself from me better than most
hardware tends to. And hey, maybe it will eventually grow to replace
something like i2c entirely. Maybe David can explain why it's such a
big deal. But right now it smells like somethign that should not be at
the top level.

                Linus
