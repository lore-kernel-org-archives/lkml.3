Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbaBLTMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:12:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49242 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaBLTMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:12:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jason Cooper <jason@lakedaemon.net>, devicetree@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>, keescook@chromium.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
Date: Wed, 12 Feb 2014 20:12:23 +0100
Message-ID: <1882539.R1gpoLLYks@wuerfel>
User-Agent: KMail/4.11.3 (Linux/3.11.0-15-generic; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140212184521.GO27395@titan.lakedaemon.net>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org> <1571508.yGAAZ8TNH0@wuerfel> <20140212184521.GO27395@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:a70fCdzieOOdsKHJ6MxepRckZXfLT8VqWDtLpoIaJ2i
 hix2RJ+3GOn/x12fG8jnC7AzzBPNLnHaQZKjTbBojEVueIoyHl
 GpB/O7p6C66Ovc60txUDS8Q2hclQcNZAAiAZ7Zfr5UgmW4KHTZ
 zzpxz44Q3y5ZGZyOU7ofiT+UzSiPvwcqu1TcQWGPKqaPgX6sxV
 vojXrXzvDi7ASUGoNHdLq818zyvGqFlXKPz1rD90mEYwMCB7cv
 Au39dtlBJCj5y7lF4eBguNKCp4MF5TgsOAZ0PX/A37bVcmlndk
 9gLLYptOJP3G/SB88ykL5U2p20vRIUtb2vQxVi3oB9LjU/FmcK
 3tFf8Zoi1wVySQ5DB4YI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 February 2014 13:45:21 Jason Cooper wrote:
> On Wed, Feb 12, 2014 at 07:17:41PM +0100, Arnd Bergmann wrote:
> > On Wednesday 12 February 2014 12:45:54 Jason Cooper wrote:
> > > I brought this up at last weeks devicetree irc meeting.  My goal is to
> > > provide early randomness for kaslr on ARM.  Currently, my idea is modify
> > > the init script to save an additional random seed from /dev/urandom to
> > > /boot/random-seed.
> > > 
> > > The bootloader would then load this file into ram, and pass the
> > > address/size to the kernel either via dt, or commandline.  kaslr (run in
> > > the decompressor) would consume some of this randomness, and then
> > > random.c would consume the rest in a non-crediting initialization.
> > 
> > I like the idea, but wouldn't it be easier to pass actual random data
> > using DT, rather than the address/size?
> 
> I thought about that at first, but that requires either that the
> bootloader be upgraded to insert the data, or that userspace is
> modifying the dtb at least twice per boot.
> 
> I chose address/size to facilitate modifying existing/fielded devices.
> The user could modify the dtb once, and modify the bootloader
> environment to load X amount to Y address.  As a fallback, it could be
> expressed on the commandline for non-DT bootloaders.

Ah, so you are interested in boot loaders that can be scripted to do
what you had in mind but cannot be scripted to add or modify a DT
property. I hadn't considered that, but you are probably right that
this is at least 90% of the systems you'd find in the wild today.

Thinking this a bit further, I wonder if (at least upstream) u-boot
has a way to modify DT properties in a scripted way that would allow
the direct property. It sounds like a generally useful feature not
just for randomness, so if that doesn't already work, maybe someone
can implement it. In the simplest case, you'd only need to find the
address of an existing property in the dtb and load a file to
that location.

	Arnd
