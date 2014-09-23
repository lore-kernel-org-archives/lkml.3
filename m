Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350AbaIWRKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:10:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115AbaIWRKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:10:38 -0400
Message-ID: <5421A851.70403@redhat.com>
Date: Tue, 23 Sep 2014 19:05:21 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andres Lagar-Cavilla <andreslc@google.com>
CC: Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andres Lagar-Cavilla <andreslc@gooogle.com>
Subject: Re: [PATCH v4] kvm: Fix page ageing bugs
References: <1411410865-3603-1-git-send-email-andreslc@google.com>	<1411422882-16245-1-git-send-email-andreslc@google.com>	<542125F1.3080607@redhat.com> <CAJu=L58L4XrACYieQuM412TJuJoD+QYBb=qOcN1MtwdVAPzn2Q@mail.gmail.com>
In-Reply-To: <CAJu=L58L4XrACYieQuM412TJuJoD+QYBb=qOcN1MtwdVAPzn2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/09/2014 19:04, Andres Lagar-Cavilla ha scritto:
> I'm not sure. The addition is not always by PAGE_SIZE, since it
> depends on the current level we are iterating at in the outer
> kvm_handle_hva_range(). IOW, could be PMD_SIZE or even PUD_SIZE, and
> is_large_pte() enough to tell?
> 
> This is probably worth a general fix, I can see all the callbacks
> benefiting from knowing the gfn (passed down by
> kvm_handle_hva_range()) without any additional computation, and adding
> that to a tracing call if they don't already.
> 
> Even passing the level down to the callback would help by cutting down
> to one arithmetic op (subtract rmapp from slot rmap base pointer for
> that level)

You're right.  Let's apply this patch and work on that as a follow-up.

Paolo
