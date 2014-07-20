Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaGTTXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 15:23:21 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:43104 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbaGTTXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 15:23:19 -0400
Date: Sun, 20 Jul 2014 21:23:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] Kbuild: Add a option to enable dwarf4
Message-ID: <20140720192315.GA4679@ravnborg.org>
References: <1405466172-17055-1-git-send-email-andi@firstfloor.org>
 <1405466172-17055-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405466172-17055-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 01:16:12AM +0200, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> I found that a lot of unresolvable variables when using gdb on the kernel
> become resolvable when dwarf4 is enabled. So add a Kconfig flag to enable it.
> 
> It definitely increases the debug information size, but on the other
> hand this isn't so bad when debug fusion is used.

Would it not make sense to try to enable degug info like this:
First try -gdwarf-4
If this fails try -gdwarf-3
If this fails try -gdwarf-2
And if this also fails fallback to -g

We could then us a Kconfig option to enable the highest debug level - where 4 for now is the highest.
On the other hand if most people have revent utils then they all have -gdwarf-4 supported
and then it is no big deal.

	Sam

> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Makefile          | 3 +++
>  lib/Kconfig.debug | 9 +++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 953659e..9c4080b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -690,6 +690,9 @@ KBUILD_CFLAGS	+= -g
>  KBUILD_AFLAGS	+= -Wa,-gdwarf-2
>  endif
>  endif
> +ifdef CONFIG_DEBUG_INFO_DWARF4
> +KBUILD_CFLAGS	+= -gdwarf-4
> +endif
Should we sue $(call cc-option ...) here as not all gcc's supports this today?

	Sam
