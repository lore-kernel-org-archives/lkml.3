Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbaKMNvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 08:51:21 -0500
Received: from www.linutronix.de ([62.245.132.108]:47117 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959AbaKMNvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 08:51:20 -0500
Date: Thu, 13 Nov 2014 14:51:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave@sr71.net>
cc: hpa@zytor.com, mingo@redhat.com, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        linux-mips@linux-mips.org, qiaowei.ren@intel.com,
        dave.hansen@linux.intel.com
Subject: Re: [PATCH 08/11] x86, mpx: [new code] decode MPX instruction to
 get bound violation information
In-Reply-To: <20141112170509.AED2778F@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.11.1411131448530.3935@nanos>
References: <20141112170443.B4BD0899@viggo.jf.intel.com> <20141112170509.AED2778F@viggo.jf.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2014, Dave Hansen wrote:
> Changes from the old decoder:
>  * Use the generic decoder instead of custom functions.  Saved
>    ~70 lines of code overall.
>  * Remove insn->addr_bytes code (never used??)
>  * Make sure never to possibly overflow the regoff[] array, plus
>    check the register range correctly in 32 and 64-bit modes.
>  * Allow get_reg() to return an error and have mpx_get_addr_ref()
>    handle when it sees errors.
>  * Only call insn_get_*() near where we actually use the values
>    instead if trying to call them all at once.
>  * Handle short reads from copy_from_user() and check the actual
>    number of read bytes against what we expect from
>    insn_get_length().  If a read stops in the middle of an
>    instruction, we error out.
>  * Actually check the opcodes intead of ignoring them.
>  * Dynamically kzalloc() siginfo_t so we don't leak any stack
>    data.
>  * Detect and handle decoder failures instead of ignoring them.

Very nice work! It's easy to follow and the error handling of all
sorts is well thought out.

Thanks,

	tglx
