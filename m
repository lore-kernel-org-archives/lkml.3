Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaCCIei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:34:38 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:48324 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaCCIeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:34:36 -0500
Message-ID: <53143E91.4070900@redhat.com>
Date: Mon, 03 Mar 2014 09:34:25 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>,
        "'qemu-devel@nongnu.org'" <qemu-devel@nongnu.org>,
        "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
CC: "'hpa@zytor.com'" <hpa@zytor.com>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>,
        "'gleb@redhat.com'" <gleb@redhat.com>
Subject: Re: [PATCH] target-i386: bugfix of Intel MPX
References: <DE8DF0795D48FD4CA783C40EC82923350152FC71@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350152FC71@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/03/2014 06:24, Liu, Jinsong ha scritto:
> From 3a7783cd9a0556787809d3d5ecb5f2b85dd9fc02 Mon Sep 17 00:00:00 2001
> From: Liu Jinsong <jinsong.liu@intel.com>
> Date: Mon, 3 Mar 2014 18:56:39 +0800
> Subject: [PATCH] target-i386: bugfix of Intel MPX
>
> The correct size of cpuid 0x0d sub-leaf 4 is 0x40, not 0x10.
> This is confirmed by Anvin H Peter and Mallick Asit K.
>
> Signed-off-by: Liu Jinsong <jinsong.liu@intel.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Asit K Mallick <asit.k.mallick@intel.com>
> ---
>  target-i386/cpu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/target-i386/cpu.c b/target-i386/cpu.c
> index 0e8812a..9f69d7e 100644
> --- a/target-i386/cpu.c
> +++ b/target-i386/cpu.c
> @@ -339,7 +339,7 @@ static const ExtSaveArea ext_save_areas[] = {
>      [3] = { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
>              .offset = 0x3c0, .size = 0x40  },
>      [4] = { .feature = FEAT_7_0_EBX, .bits = CPUID_7_0_EBX_MPX,
> -            .offset = 0x400, .size = 0x10  },
> +            .offset = 0x400, .size = 0x40  },
>  };
>
>  const char *get_register_name_32(unsigned int reg)
>

Thanks, applying to uq/master.

Paolo
