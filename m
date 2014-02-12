Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaBLSOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:14:03 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:39462 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbaBLSOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:14:00 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:3587:b577:ce10:fe39]
In-Reply-To: <20140212174554.GM27395@titan.lakedaemon.net>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org>
	<201402121251.06280.arnd@arndb.de>
	<20140212174554.GM27395@titan.lakedaemon.net>
Date: Wed, 12 Feb 2014 10:13:59 -0800
Message-ID: <CAOesGMgNkdxW4znmns10-DPc4+OTWJLyx2fcJGTgdND6pp0zUQ@mail.gmail.com>
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
From: Olof Johansson <olof@lixom.net>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 9:45 AM, Jason Cooper <jason@lakedaemon.net> wrote:

> I brought this up at last weeks devicetree irc meeting.  My goal is to
> provide early randomness for kaslr on ARM.  Currently, my idea is modify
> the init script to save an additional random seed from /dev/urandom to
> /boot/random-seed.
>
> The bootloader would then load this file into ram, and pass the
> address/size to the kernel either via dt, or commandline.  kaslr (run in
> the decompressor) would consume some of this randomness, and then
> random.c would consume the rest in a non-crediting initialization.
>
> While not ideal, it works in absence of an HRNG, and is no worse than
> the current situation of storing the seed in /var/lib/misc/random-seed.
> It also doesn't require modification of the bootloaders.  Just an
> updated kernel, and update the bootloader environment to load the
> seed.

Hmm. There are some drawbacks with this -- it assumes you can "just
update the bootloader environment" which in general isn't easy to do.
Also, you can't assume that /boot is writable or exists on all
embedded systems.

In general, taking both runtime and system-dependend data and using
that to see entropy is a good idea. For example, device trees that
contain serial numbers and mac addresses for the individual system. I
think x86 feeds the DMI table in for similar purposes.

If that can be amended on some systems with a runtime seed (from
/boot), that's good but we can't rely on it.


-Olof
