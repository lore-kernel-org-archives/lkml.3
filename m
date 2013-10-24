Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3JXI5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 04:57:17 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:60614 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3JXI5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 04:57:12 -0400
MIME-Version: 1.0
In-Reply-To: <20131024084104.GA2861@leaf>
References: <20131024084104.GA2861@leaf>
Date: Thu, 24 Oct 2013 10:57:11 +0200
Message-ID: <CAFLxGvzqoJFHjXJ=WMR6Dyjg804=x0CkqHV2gXSfKUBgx2ktVA@mail.gmail.com>
Subject: Re: [PATCH] Documentation/ABI: Document the non-ABI status of Kconfig
 and symbols
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rob Landley <rob@landley.net>, Tao Ma <boyu.mt@taobao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 10:41 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> Discussion at Kernel Summit made it clear that the presence or absence
> of specific Kconfig symbols are not considered ABI, and that no
> userspace (or bootloader, etc) should rely on them.
>
> In addition, kernel-internal symbols are well established as non-ABI,
> per Documentation/stable_api_nonsense.txt.
>
> Document both of these in Documentation/ABI/README, in a new section for
> notable bits of non-ABI.
>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
>  Documentation/ABI/README | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/Documentation/ABI/README b/Documentation/ABI/README
> index 1006982..1fafc4b 100644
> --- a/Documentation/ABI/README
> +++ b/Documentation/ABI/README
> @@ -72,3 +72,16 @@ kernel tree without going through the obsolete state first.
>
>  It's up to the developer to place their interfaces in the category they
>  wish for it to start out in.
> +
> +
> +Notable bits of non-ABI, which should not under any circumstances be considered
> +stable:
> +
> +- Kconfig.  Userspace should not rely on the presence or absence of any
> +  particular Kconfig symbol, in /proc/config.gz, in the copy of .config
> +  commonly installed to /boot, or in any invocation of the kernel build
> +  process.
> +
> +- Kernel-internal symbols.  Do not rely on the presence, absence, location, or
> +  type of any kernel symbol, either in System.map files or the kernel binary
> +  itself.  See Documentation/stable_api_nonsense.txt.

And what about the kernel make "interface", is it considered also as non-ABI?

E.g.
Before ffee0de (x86: Default to ARCH=x86 to avoid overriding CONFIG_64BIT)
"make defconfig ARCH=x86" produced a i386 defconfig. Now it produces a
x86_64 defconfig.
I'm sure some build scripted failed badly.


-- 
Thanks,
//richard
