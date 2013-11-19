Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3KSLIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 06:08:23 -0500
Received: from alvesta.synopsys.com ([198.182.60.77]:60225 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3KSLIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 06:08:20 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: David Daney <david.daney@cavium.com>, Michal Marek <mmarek@suse.cz>,
        Francois Bedard <Francois.Bedard@synopsys.com>
Subject: Re: [PATCH] ARC: extable: Enable sorting at build time
Thread-Topic: [PATCH] ARC: extable: Enable sorting at build time
Thread-Index: AQHO4c5X1HJl6ervyUaskT5jY/KJ8w==
Date: Tue, 19 Nov 2013 11:08:08 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075156936@IN01WEMBXA.internal.synopsys.com>
References: <1384497942-26810-1-git-send-email-vgupta@synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.15.84.232]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping ? people OK if I take this via arc tree (after baking it in linux-next for
some time).

-Vineet

On 11/15/2013 12:15 PM, Vineet Gupta wrote:
> Avoids wasting cycles at boot specially on slower simulators
>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Cc: David Daney <david.daney@cavium.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Francois Bedard <fbedard@synopsys.com>
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arc/Kconfig      | 1 +
>  scripts/sortextable.c | 5 +++++
>  2 files changed, 6 insertions(+)
>
> diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
> index 91dbb2757afd..080580216301 100644
> --- a/arch/arc/Kconfig
> +++ b/arch/arc/Kconfig
> @@ -8,6 +8,7 @@
>  
>  config ARC
>  	def_bool y
> +	select BUILDTIME_EXTABLE_SORT
>  	select CLONE_BACKWARDS
>  	# ARC Busybox based initramfs absolutely relies on DEVTMPFS for /dev
>  	select DEVTMPFS if !INITRAMFS_SOURCE=""
> diff --git a/scripts/sortextable.c b/scripts/sortextable.c
> index 7c2310c5b996..e3fb1c36ed0f 100644
> --- a/scripts/sortextable.c
> +++ b/scripts/sortextable.c
> @@ -31,6 +31,10 @@
>  #include <tools/be_byteshift.h>
>  #include <tools/le_byteshift.h>
>  
> +#ifndef EM_ARCOMPACT
> +#define EM_ARCOMPACT	93
> +#endif
> +
>  #ifndef EM_AARCH64
>  #define EM_AARCH64	183
>  #endif
> @@ -244,6 +248,7 @@ do_file(char const *const fname)
>  	case EM_S390:
>  		custom_sort = sort_relative_table;
>  		break;
> +	case EM_ARCOMPACT:
>  	case EM_ARM:
>  	case EM_AARCH64:
>  	case EM_MIPS:

