Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbaIVVys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:54:48 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:45316 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbaIVVyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:54:46 -0400
MIME-Version: 1.0
In-Reply-To: <5420991C.2000400@redhat.com>
References: <1411410865-3603-1-git-send-email-andreslc@google.com>
	<1411417565-15748-1-git-send-email-andreslc@google.com>
	<5420991C.2000400@redhat.com>
Date: Mon, 22 Sep 2014 14:54:45 -0700
Message-ID: <CAJu=L59=QGpWWW=ghPkFyhParXB4jMepQROiQ+5ZBh235Dmepg@mail.gmail.com>
Subject: Re: [PATCH v3] kvm: Fix page ageing bugs
From: Andres Lagar-Cavilla <andreslc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andres Lagar-Cavilla <andreslc@gooogle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 2:48 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 22/09/2014 22:26, Andres Lagar-Cavilla ha scritto:
>> +             __entry->gfn            = gfn;
>> +             __entry->hva            = ((gfn - slot->base_gfn) >>
>
> This must be <<.

Correct, thanks.

>
>> +                                         PAGE_SHIFT) + slot->userspace_addr;
>
>> +             /*
>> +              * No need for _notify because we're called within an
>> +              * mmu_notifier_invalidate_range_ {start|end} scope.
>> +              */
>
> Why "called within"?  It is try_to_unmap_cluster itself that calls
> mmu_notifier_invalidate_range_*, so "we're within an
> mmu_notifier_invalidate_range_start/end scope" sounds better, and it's
> also what you use in the commit message.

Also correct. V4...
Andres

>
> Paolo



-- 
Andres Lagar-Cavilla | Google Kernel Team | andreslc@google.com
