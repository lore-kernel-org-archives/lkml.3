Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab3KZEei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 23:34:38 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48825 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3KZEef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 23:34:35 -0500
Message-ID: <5294255E.7040105@gmail.com>
Date: Tue, 26 Nov 2013 12:36:46 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rkuo <rkuo@codeaurora.org>
CC: linux-hexagon@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] arch: hexagon: include: asm: add prefix "vm_" for
 all enum members in "hexagon_vm.h"
References: <528AEFB7.4060301@gmail.com> <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com> <5292B8A0.7020409@gmail.com>
In-Reply-To: <5292B8A0.7020409@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 10:40 AM, Chen Gang wrote:
> Append "vm_" to all enum members (which are too common to make conflict
> with another sub-systems). The related error with allmodconfig:
> 
>     CC [M]  drivers/md/raid1.o
>   drivers/md/raid1.c:1440:13: error: 'status' redeclared as different kind of symbol
>   arch/hexagon/include/asm/hexagon_vm.h:76:2: note: previous definition of 'status' was here
> 

Oh, sorry, The new prefix "vm_" is still conflict with others. One case
is below (bottom of this mail)

I will use "hvmc_" for VM_CACHE_OPS and "hvmi_" for VM_INT_OPS instead
of. If get no rejections within 1 day, I will send patch v2 for it.

And also I will merge the related 2 patches together (although they are
for 2 issues).

> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  arch/hexagon/include/asm/hexagon_vm.h |   70 ++++++++++++++++----------------
>  1 files changed, 35 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/hexagon/include/asm/hexagon_vm.h b/arch/hexagon/include/asm/hexagon_vm.h
> index 67bb6d6..e1e0470 100644
> --- a/arch/hexagon/include/asm/hexagon_vm.h
> +++ b/arch/hexagon/include/asm/hexagon_vm.h
> @@ -55,27 +55,27 @@
>  #ifndef __ASSEMBLY__
>  
>  enum VM_CACHE_OPS {
> -	ickill,
> -	dckill,
> -	l2kill,
> -	dccleaninva,
> -	icinva,
> -	idsync,
> -	fetch_cfg
> +	vm_ickill,
> +	vm_dckill,
> +	vm_l2kill,
> +	vm_dccleaninva,
> +	vm_icinva,
> +	vm_idsync,
> +	vm_fetch_cfg
>  };
>  
>  enum VM_INT_OPS {
> -	nop,
> -	globen,
> -	globdis,
> -	locen,
> -	locdis,
> -	affinity,
> -	get,
> -	peek,
> -	status,
> -	post,
> -	clear
> +	vm_nop,
> +	vm_globen,
> +	vm_globdis,
> +	vm_locen,
> +	vm_locdis,
> +	vm_affinity,
> +	vm_get,

The new prefix "vm_" for "get" is still conflict with others:

    CC [M]  drivers/virtio/virtio_mmio.o
  drivers/virtio/virtio_mmio.c:170:13: error: 'vm_get' redeclared as different kind of symbol
  arch/hexagon/include/asm/hexagon_vm.h:74:2: note: previous definition of 'vm_get' was here


Thanks.
-- 
Chen Gang
