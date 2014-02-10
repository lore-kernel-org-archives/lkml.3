Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940AbaBJXql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:46:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59816 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaBJXqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:46:38 -0500
Date: Mon, 10 Feb 2014 15:46:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, gleb@redhat.com,
        pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH 01/14] asmlinkage, kvm: Make kvm_rebooting visible
Message-Id: <20140210154637.dd58edfcbae273034d34c4df@linux-foundation.org>
In-Reply-To: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
References: <1391845930-28580-1-git-send-email-ak@linux.intel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  8 Feb 2014 08:51:57 +0100 Andi Kleen <ak@linux.intel.com> wrote:

> kvm_rebooting is referenced from assembler code, thus
> needs to be visible.

So I read the gcc page and looked at the __visible definition but I
still don't really get it.  What goes wrong if the __visible isn't
present on these referenced-from-asm identifiers?

> Cc: gleb@redhat.com
> Cc: pbonzini@redhat.com

Grumble.  Email addresses go into commits with display names and <>. 
At least, 89.3% of them do.  Some sucker has to go through these and
fix them up.  I'd prefer it not be me ;)

>
> ...
>
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -102,7 +102,7 @@ static void kvm_release_pfn_dirty(pfn_t pfn);
>  static void mark_page_dirty_in_slot(struct kvm *kvm,
>  				    struct kvm_memory_slot *memslot, gfn_t gfn);
>  
> -bool kvm_rebooting;
> +__visible bool kvm_rebooting;
>  EXPORT_SYMBOL_GPL(kvm_rebooting);
>  
>  static bool largepages_enabled = true;
