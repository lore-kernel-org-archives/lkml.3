Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759599Ab3KMRJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:09:15 -0500
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:54242 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435Ab3KMRJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:09:11 -0500
Message-ID: <1384362541.3392.40.camel@linaro1.home>
Subject: Re: [PATCH v2 07/13] ARM: move generic thumb instruction parsing
 code to new files for use by other features
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 13 Nov 2013 17:09:01 +0000
In-Reply-To: <1381871068-27660-8-git-send-email-dave.long@linaro.org>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>
	 <1381871068-27660-8-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 17:04 -0400, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> Move the thumb version of the kprobes instruction parsing code into more generic

This patch is moving the 'ARM' instructions, not 'thumb' instructions,
so both description and title needs fixing for that.

Actually, after looking at patch 08/13, that one seems to erroneously
include the thumb reorg, I'm guessing that was meant to be in this patch
instead, or in a standalone patch?

> files from where it can be used by uprobes and possibly other subsystems. The
> symbol names will be made more generic in a subsequent part of this patchset.
> 
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---
>  arch/arm/include/asm/probes.h    |   2 +
>  arch/arm/kernel/Makefile         |   4 +-
>  arch/arm/kernel/kprobes-arm.c    | 723 +-------------------------------------
>  arch/arm/kernel/kprobes-common.c | 422 +---------------------
>  arch/arm/kernel/kprobes-test.c   |   1 +
>  arch/arm/kernel/kprobes-thumb.c  |   1 +
>  arch/arm/kernel/kprobes.c        |   1 +
>  arch/arm/kernel/kprobes.h        | 372 --------------------
>  arch/arm/kernel/probes-arm.c     | 730 +++++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/probes-arm.h     |  38 ++
>  arch/arm/kernel/probes.c         | 441 +++++++++++++++++++++++
>  arch/arm/kernel/probes.h         | 395 +++++++++++++++++++++
>  12 files changed, 1622 insertions(+), 1508 deletions(-)
>  create mode 100644 arch/arm/kernel/probes-arm.c
>  create mode 100644 arch/arm/kernel/probes-arm.h
>  create mode 100644 arch/arm/kernel/probes.c
>  create mode 100644 arch/arm/kernel/probes.h

A git tip: if you use the -C argument with git format-patch (and
send-email I assume) then it will detect files which are copies of
others and produce a much smaller patch, as well as a more informative
file summary. I believe that this is OK for submissions posted to
mailing lists, I know that I've seen people regularly reminded to use -M
(which detects file renames).

[...]

> --- a/arch/arm/kernel/kprobes-arm.c
> +++ b/arch/arm/kernel/kprobes-arm.c
> @@ -63,10 +63,8 @@
>  #include <linux/module.h>
>  
>  #include "kprobes.h"
> -
> -#define sign_extend(x, signbit) ((x) | (0 - ((x) & (1 << (signbit)))))
> -
> -#define branch_displacement(insn) sign_extend(((insn) & 0xffffff) << 2, 25)
> +#include "probes.h"

Rather than include "probes.h" after "kprobes.h" here, (and in the other
7 places in this patch, and other patches) I think it would make more
sense to have kprobes.h include probes.h as kprobes code is always going
to depend on the new generic probe functions. 

I've trimmed the rest of this large patch as I have no other comments
except the above.

-- 
Tixy






