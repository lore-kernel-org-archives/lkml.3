Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab3J1Xag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 19:30:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:32883 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757685Ab3J1Xae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 19:30:34 -0400
Message-ID: <526EF397.4080802@gmail.com>
Date: Mon, 28 Oct 2013 18:30:31 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, Rob Herring <rob.herring@calxeda.com>
Subject: Re: linux-next: build failure after merge of the dt-rh tree
References: <20131028193814.6d9416904eb8fac2f441c8af@canb.auug.org.au>
In-Reply-To: <20131028193814.6d9416904eb8fac2f441c8af@canb.auug.org.au>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 03:38 AM, Stephen Rothwell wrote:
> Hi Rob,
> 
> After merging the dt-rh tree, today's linux-next build (powerpc 
> ppc64_defconfig) failed like this:
> 
> arch/powerpc/platforms/powernv/rng.c: In function
> 'rng_init_per_cpu': arch/powerpc/platforms/powernv/rng.c:64:2:
> error: implicit declaration of function 'of_get_ibm_chip_id'
> [-Werror=implicit-function-declaration] chip_id =
> of_get_ibm_chip_id(dn); ^ arch/powerpc/platforms/powernv/rng.c: In
> function 'rng_create': arch/powerpc/platforms/powernv/rng.c:85:2:
> error: implicit declaration of function 'of_iomap'
> [-Werror=implicit-function-declaration] rng->regs= of_iomap(dn, 0);
>   ^
> arch/powerpc/platforms/powernv/rng.c:85:12: error: assignment makes pointer from integer without a cast [-Werror]
>   rng->regs = of_iomap(dn, 0);
>             ^
> 
> Caused by commit a4da0d50b2a0 ("powerpc: Implement
> arch_get_random_long/int() for powernv") from the powerpc tree
> interacting with commit b5b4bb3f6a11 ("of: only include prom.h on sparc")
> from the dt-rh tree.
> 
> I added this merge fix patch (which will need to be sent to Linus when
> these two trees get merged, or could be applied now to the powerpc tree):

Applying to the powerpc tree now seems like the better path.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 28 Oct 2013 19:34:41 +1100
> Subject: [PATCH] powerpc: add include of prom.h to fix powernv/rng.c build
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Rob Herring <rob.herring@calxeda.com>

Rob

