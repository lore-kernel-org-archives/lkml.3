Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3KTBGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 20:06:35 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:14182 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3KTBGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 20:06:34 -0500
Message-ID: <1384909591.2588.32.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] fs: partitions: efi: Fix bound check
From: Davidlohr Bueso <davidlohr@hp.com>
To: amiettinen@nvidia.com
Cc: axboe@kernel.dk, akpm@linux-foundation.org, matt.fleming@intel.com,
        kzak@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 19 Nov 2013 17:06:31 -0800
In-Reply-To: <20131115.191422.1787913255098350249.apm@brigitte.kvy.fi>
References: <20131115.191422.1787913255098350249.apm@brigitte.kvy.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-15 at 19:14 +0200, Antti P Miettinen wrote:
> Use ARRAY_SIZE instead of sizeof to get proper max for label
> length.
> 
> Signed-off-by: Antti P Miettinen <amiettinen@nvidia.com>
> Reviewed-by: Hiroshi Doyu <hdoyu@nvidia.com>
> Tested-by: Hiroshi Doyu <hdoyu@nvidia.com>

I haven't tested the patch, but using ARRAY_SIZE for fields defined as
arrays does make more sense than sizeof.

Acked-by: Davidlohr Bueso <davidlohr@hp.com>

> ---
>  block/partitions/efi.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/block/partitions/efi.c b/block/partitions/efi.c
> index a8287b4..dc51f46 100644
> --- a/block/partitions/efi.c
> +++ b/block/partitions/efi.c
> @@ -96,6 +96,7 @@
>   * - Code works, detects all the partitions.
>   *
>   ************************************************************/
> +#include <linux/kernel.h>
>  #include <linux/crc32.h>
>  #include <linux/ctype.h>
>  #include <linux/math64.h>
> @@ -715,8 +716,8 @@ int efi_partition(struct parsed_partitions *state)
>  		efi_guid_unparse(&ptes[i].unique_partition_guid, info->uuid);
>  
>  		/* Naively convert UTF16-LE to 7 bits. */
> -		label_max = min(sizeof(info->volname) - 1,
> -				sizeof(ptes[i].partition_name));
> +		label_max = min(ARRAY_SIZE(info->volname) - 1,
> +				ARRAY_SIZE(ptes[i].partition_name));
>  		info->volname[label_max] = 0;
>  		while (label_count < label_max) {
>  			u8 c = ptes[i].partition_name[label_count] & 0xff;


