Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3GCIOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 04:14:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52904 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab3GCIOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 04:14:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] include/asm-generic/io.h: add dummy fuctions to support 'COMPILE_TEST' in 'asm-generic'.
Date: Wed, 3 Jul 2013 10:14:12 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Weinberger <richard@nod.at>, Jeff Dike <jdike@addtoit.com>,
        David Sharp <dhsharp@google.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        "uml-devel" <user-mode-linux-devel@lists.sourceforge.net>,
        "uml-user" <user-mode-linux-user@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linux-Arch" <linux-arch@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <trivial@kernel.org>
References: <51CA8AB8.7080504@asianux.com> <CAMuHMdW58CZ0m-10ibs2Vyh8exqP1nSH+-ZOr5J58tx=uorM+Q@mail.gmail.com> <51D375AA.5060300@asianux.com>
In-Reply-To: <51D375AA.5060300@asianux.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <201307031014.12583.arnd@arndb.de>
X-Provags-ID: V02:K0:03R+OL4QUaGF9/RoL3A8ra3LFU59n83ulyHdsDuX2/q
 0SzSQCuFXwj8HydZX1YByDoUby9TMjoDjPRE6uq3Ov4PXs0x6m
 8JFGWEjy2uRC+IKuv/xBFyWatgkwZNigJ6ZNA+6paT1qvEJgl9
 vbiCqq2h3UqqHAxos2hCWxpot6qBXXdJgHB4HCtdQNFkBeBqey
 kgRaj3BgKsqrm+P7oX1kCFzItCVd6T8sFo6jDVgIMs5SVekel1
 T1lRK2CjIjFY8+Cc8fWVVVtlZXnWc4yFGf/DDUKjPm8YhmR/+d
 t/9Z4oR1UGg84WN8yd2usqmhUHrPC9uK0eB3sr9CLIpI0CfFTs
 Uvs5q+Q4IuejoLchWVNs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 July 2013, Chen Gang wrote:
> On 07/02/2013 06:57 PM, Geert Uytterhoeven wrote:
> > On Tue, Jul 2, 2013 at 10:00 AM, Chen Gang <gang.chen@asianux.com> wrote:
> >> > On 07/02/2013 03:19 PM, Geert Uytterhoeven wrote:
> >>> >> On Tue, Jul 2, 2013 at 4:13 AM, Chen Gang <gang.chen@asianux.com> wrote:
> > I mean that COMPILE_TEST should exist in Kconfig files only.
> > It's only meant to have more compile coverage, not to "fix" (through #ifdef)
> > more code to make it compile.
> 
> If so, can we allow the module to 'COMPILE_TEST' under one platform
> which not support the related HW ?
> 
>   e.g. "...Despite they cannot be loaded there (or even when they load
> they cannot be used due to missing HW support)...".

There is a reason why ioremap and the associated functions make no
sense on UML, and it remains important to not provide them here
so we can find drivers that accidentally use them and are missing
a dependency on HAS_IOMEM.
 
> 'asm-generic' need provide generic layer to users (both architecture
> guys and module guys).

No. It's a set of examples for the architectures to look at and
include if they want to.

> So for 'default', it can depend on some conditions (e.g. HW support);
> but for 'generic', it need try to be independent from any conditions.
> 
> And it is also necessary for 'generic' to provide the configuration
> checking features, but this checking must be no negative effect (or
> consistent) with its 'generic' services.
> 
> So it is necessary to check 'NOMMU', 'CONFIG_HAS_IOMEM' ..., but it
> also necessary to consider about 'COMPILE_TEST' to be consistent with
> its 'generic' services.

The important distinction is between drivers we want to enable in
COMPILE_TEST because they are written in a portable way but are just
useless if you don't have the hardware, and other drivers that rely
on an interface and that should not be built when that interface
is not available.

	Arnd
