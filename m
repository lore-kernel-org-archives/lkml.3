Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaG3JBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 05:01:07 -0400
Received: from sym2.noone.org ([178.63.92.236]:60920 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbaG3JBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 05:01:04 -0400
Date: Wed, 30 Jul 2014 11:01:02 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Ley Foon Tan <lftan@altera.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, lftan.linux@gmail.com,
        cltang@codesourcery.com
Subject: Re: [PATCH v2 05/29] nios2: Memory management
Message-ID: <20140730090101.GD10301@distanz.ch>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
 <1405413956-2772-6-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405413956-2772-6-git-send-email-lftan@altera.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-15 at 10:45:32 +0200, Ley Foon Tan <lftan@altera.com> wrote:
> This patch contains the initialisation of the memory blocks, MMU
> attributes and the memory map.
> 
> Signed-off-by: Ley Foon Tan <lftan@altera.com>
> ---
>  arch/nios2/include/asm/mmu.h     |  18 +++
>  arch/nios2/include/asm/page.h    | 113 +++++++++++++++++++
>  arch/nios2/include/asm/uaccess.h | 233 +++++++++++++++++++++++++++++++++++++++
>  arch/nios2/mm/init.c             | 142 ++++++++++++++++++++++++
>  arch/nios2/mm/uaccess.c          | 162 +++++++++++++++++++++++++++
>  5 files changed, 668 insertions(+)
>  create mode 100644 arch/nios2/include/asm/mmu.h
>  create mode 100644 arch/nios2/include/asm/page.h
>  create mode 100644 arch/nios2/include/asm/uaccess.h
>  create mode 100644 arch/nios2/mm/init.c
>  create mode 100644 arch/nios2/mm/uaccess.c

[...]

> diff --git a/arch/nios2/include/asm/page.h b/arch/nios2/include/asm/page.h
> new file mode 100644
> index 0000000..b89c1d6
> --- /dev/null
> +++ b/arch/nios2/include/asm/page.h
> @@ -0,0 +1,113 @@
> +/*
> + * Copyright (C) 2011 Tobias Klauser <tklauser@distanz.ch>
> + * Copyright (C) 2004 Microtronix Datacom Ltd.
> + *
> + * MMU support based on asm/page.h from mips which is:
> + *
> + * Copyright (C) 1994 - 1999, 2000, 03 Ralf Baechle
> + * Copyright (C) 1999, 2000 Silicon Graphics, Inc.
> + *
> + * NOMMU support based on asm/page.h from m68knommu.

You might want to remove this line to avoid confusion, since NOMMU is
not supported anymore in this submission of the NIOS II port.

> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + */
