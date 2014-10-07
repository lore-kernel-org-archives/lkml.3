Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaJGJTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:19:35 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:41571 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbaJGJTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:19:33 -0400
MIME-Version: 1.0
In-Reply-To: <1412610847-27671-3-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1412610847-27671-1-git-send-email-a.ryabinin@samsung.com> <1412610847-27671-3-git-send-email-a.ryabinin@samsung.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 7 Oct 2014 13:19:12 +0400
Message-ID: <CACT4Y+bcn3cc=RfmAwAVJBjtdeQ7z9nNuNvsUiD6RvKnc7E=ZA@mail.gmail.com>
Subject: Re: [PATCH v4 02/13] efi: libstub: disable KASAN for efistub
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

looks good to me

On Mon, Oct 6, 2014 at 7:53 PM, Andrey Ryabinin <a.ryabinin@samsung.com> wrote:
> KASan as many other options should be disabled for this stub
> to prevent build failures.
>
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  drivers/firmware/efi/libstub/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index b14bc2b..c5533c7 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -19,6 +19,7 @@ KBUILD_CFLAGS                 := $(cflags-y) \
>                                    $(call cc-option,-fno-stack-protector)
>
>  GCOV_PROFILE                   := n
> +KASAN_SANITIZE                 := n
>
>  lib-y                          := efi-stub-helper.o
>  lib-$(CONFIG_EFI_ARMSTUB)      += arm-stub.o fdt.o
> --
> 2.1.2
>
