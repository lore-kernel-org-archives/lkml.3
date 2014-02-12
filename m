Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaBMBXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 20:23:55 -0500
Received: from ozlabs.org ([203.10.76.45]:57647 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbaBMBXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 20:23:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, x86@kernel.org,
        Joe Mario <jmario@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 05/17] lto: Handle LTO common symbols in module loader
In-Reply-To: <1391846481-31491-5-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-1-git-send-email-ak@linux.intel.com> <1391846481-31491-5-git-send-email-ak@linux.intel.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 12 Feb 2014 11:34:12 +1030
Message-ID: <87zjlxf8fn.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@linux.intel.com> writes:
> From: Joe Mario <jmario@redhat.com>
>
> Here is the workaround I made for having the kernel not reject modules
> built with -flto.  The clean solution would be to get the compiler to not
> emit the symbol.  Or if it has to emit the symbol, then emit it as
> initialized data but put it into a comdat/linkonce section.
>
> Minor tweaks by AK over Joe's patch.

Patch is fine, but what's with the comment?

>  		switch (sym[i].st_shndx) {
>  		case SHN_COMMON:
> +			/* Ignore common symbols */
> +			if (!strncmp(name, "__gnu_lto", 9))
> +				break;
> +

You mean, "/* Ignore symbols from -flto */"?

Other than that, I'm happy for this to go via some other tree:

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.
