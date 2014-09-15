Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbaIOTUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:20:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41352 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619AbaIOTUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:20:47 -0400
Message-ID: <54173C0F.2060307@infradead.org>
Date: Mon, 15 Sep 2014 12:20:47 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Peter Foley <pefoley2@pefoley.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] [PATCH] Documentation: update vDSO makefile to build
 portable examples
References: <1410216900-22390-1-git-send-email-pefoley2@pefoley.com> <1410216900-22390-2-git-send-email-pefoley2@pefoley.com>
In-Reply-To: <1410216900-22390-2-git-send-email-pefoley2@pefoley.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/14 15:55, Peter Foley wrote:
> Signed-off-by: Peter Foley <pefoley2@pefoley.com>

Applied.  Thanks.

> ---
>  Documentation/vDSO/Makefile | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/vDSO/Makefile b/Documentation/vDSO/Makefile
> index 6cbd612..d87bb29 100644
> --- a/Documentation/vDSO/Makefile
> +++ b/Documentation/vDSO/Makefile
> @@ -1,9 +1,12 @@
>  # List of programs to build
> -hostprogs-$(CONFIG_X86) := vdso_test
> +hostprogs-y := vdso_test
> +hostprogs-$(CONFIG_X86) := vdso_standalone_test_x86
> +vdso_standalone_test_x86-objs := vdso_standalone_test_x86.o parse_vdso.o
>  vdso_test-objs := parse_vdso.o vdso_test.o
>  
>  # Tell kbuild to always build the programs
> -##always := $(hostprogs-y)
> +always := $(hostprogs-y)
>  
>  HOSTCFLAGS := -I$(objtree)/usr/include -std=gnu99
> -HOSTLDFLAGS = -nostdlib -fno-asynchronous-unwind-tables
> +HOSTCFLAGS_vdso_standalone_test_x86.o := -fno-asynchronous-unwind-tables -fno-stack-protector
> +HOSTLOADLIBES_vdso_standalone_test_x86 := -nostdlib
> 


-- 
~Randy
