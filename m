Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaGCTxI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 15:53:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:42893 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbaGCTxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 15:53:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,596,1400050800"; 
   d="scan'208";a="564935511"
From: Andi Kleen <andi@firstfloor.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: DNAME_INLINE_LEN versus CONFIG_GENERIC_LOCKBREAK
References: <8761je94wk.fsf@rasmusvillemoes.dk>
Date: Thu, 03 Jul 2014 12:53:01 -0700
In-Reply-To: <8761je94wk.fsf@rasmusvillemoes.dk> (Rasmus Villemoes's message
	of "Thu, 03 Jul 2014 11:18:35 +0200")
Message-ID: <87fviite1u.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

> In dcache.h, DNAME_INLINE_LEN is carefully chosen so that sizeof(struct
> dentry) is a (specific) multiple of 64 bytes. Obviously this breaks when
> certain debug options are chosen (DEBUG_LOCK_ALLOC and DEBUG_SPINLOCK),
> but also, AFAICT, on architectures with CONFIG_GENERIC_LOCKBREAK.
>
> I'm not sure it matters, but if it does, I'd suggest putting a
> BUILD_BUG_ON somewhere, protected by suitable #ifdefs, so that the code
> documents the assumptions that went into the particular choice of
> DNAME_INLINE_LEN (this would also help catch changes to some of the
> structures embedded in struct dentry which would violate those
> assumptions). 

The right fix would be to pad it correctly for these other variants
too.

Checking for magic numbers would be nasty though.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
