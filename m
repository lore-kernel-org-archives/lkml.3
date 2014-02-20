Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaBUCbC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 21:31:02 -0500
Received: from ozlabs.org ([203.10.76.45]:58914 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaBUCa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 21:30:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jmario@redhat.com, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com, linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jmario@redhat.com, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Subject: Re: [tip:x86/asmlinkage] lto: Handle LTO common symbols in module loader
In-Reply-To: <tip-80375980f1608f43b47abc2671456b23ec68c434@git.kernel.org>
References: <1391846481-31491-5-git-send-email-ak@linux.intel.com> <tip-80375980f1608f43b47abc2671456b23ec68c434@git.kernel.org>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 21 Feb 2014 09:41:37 +1030
Message-ID: <87ios99y6u.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Joe Mario <tipbot@zytor.com> writes:
> Commit-ID:  80375980f1608f43b47abc2671456b23ec68c434
> Gitweb:     http://git.kernel.org/tip/80375980f1608f43b47abc2671456b23ec68c434
> Author:     Joe Mario <jmario@redhat.com>
> AuthorDate: Sat, 8 Feb 2014 09:01:09 +0100
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Thu, 13 Feb 2014 20:24:50 -0800
>
> lto: Handle LTO common symbols in module loader
>
> Here is the workaround I made for having the kernel not reject modules
> built with -flto.  The clean solution would be to get the compiler to not
> emit the symbol.  Or if it has to emit the symbol, then emit it as
> initialized data but put it into a comdat/linkonce section.

Gah, as I said, fix the damn comment!

>  		case SHN_COMMON:
> +			/* Ignore common symbols */
> +			if (!strncmp(name, "__gnu_lto", 9))
> +				break;
> +
>  			/* We compiled with -fno-common.  These are not

/* Ignore common symbols */ is so bad, it's not even wrong.

Cheers,
Rusty.
