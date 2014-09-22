Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbaIVVx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:53:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757AbaIVVx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:53:27 -0400
Message-ID: <5420991C.2000400@redhat.com>
Date: Mon, 22 Sep 2014 23:48:12 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andres Lagar-Cavilla <andreslc@google.com>, Gleb Natapov <gleb@kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
CC: Andres Lagar-Cavilla <andreslc@gooogle.com>
Subject: Re: [PATCH v3] kvm: Fix page ageing bugs
References: <1411410865-3603-1-git-send-email-andreslc@google.com> <1411417565-15748-1-git-send-email-andreslc@google.com>
In-Reply-To: <1411417565-15748-1-git-send-email-andreslc@google.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/09/2014 22:26, Andres Lagar-Cavilla ha scritto:
> +		__entry->gfn		= gfn;
> +		__entry->hva		= ((gfn - slot->base_gfn) >>

This must be <<.

> +					    PAGE_SHIFT) + slot->userspace_addr;

> +		/*
> +		 * No need for _notify because we're called within an
> +		 * mmu_notifier_invalidate_range_ {start|end} scope.
> +		 */

Why "called within"?  It is try_to_unmap_cluster itself that calls
mmu_notifier_invalidate_range_*, so "we're within an
mmu_notifier_invalidate_range_start/end scope" sounds better, and it's
also what you use in the commit message.

Paolo
