Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaBOV0n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 16:26:43 -0500
Received: from asavdk3.altibox.net ([109.247.116.14]:52818 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaBOV0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 16:26:42 -0500
Date: Sat, 15 Feb 2014 22:26:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        mmarek@suse.cz, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/19] x86, lto: Disable LTO for the x86 VDSO
Message-ID: <20140215212628.GB27575@ravnborg.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
 <1392412903-25733-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392412903-25733-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 10:21:25PM +0100, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The VDSO does not play well with LTO, so just disable LTO for it.
> Also pass a 32bit linker flag for the 32bit version.
> 
> Cc: x86@kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/vdso/Makefile | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
> index fd14be1..598f163 100644
> --- a/arch/x86/vdso/Makefile
> +++ b/arch/x86/vdso/Makefile
> @@ -2,6 +2,8 @@
>  # Building vDSO images for x86.
>  #
>  
> +KBUILD_CFLAGS += ${DISABLE_LTO}
> +
In kbuild files $() is usally preferred.

	Sam
