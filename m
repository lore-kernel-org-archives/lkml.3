Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaIXI2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:28:10 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:42165 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaIXI2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:28:05 -0400
Message-ID: <5422808B.5070002@redhat.com>
Date: Wed, 24 Sep 2014 10:27:55 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Wanpeng Li <kernellwp@gmail.com>, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Andres Lagar-Cavilla <andreslc@google.com>
CC: Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4] kvm: Fix page ageing bugs
References: <1411410865-3603-1-git-send-email-andreslc@google.com> <1411422882-16245-1-git-send-email-andreslc@google.com> <20140924022729.GA2889@kernel> <54226CEB.9080504@redhat.com> <542270BA.4090708@gmail.com>
In-Reply-To: <542270BA.4090708@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/09/2014 09:20, Wanpeng Li ha scritto:
> 
> This trace point still dup duplicated message for the same gfn in the
> for loop.

Yes, but the gfn argument lets you take it out again.

Note that having the duplicated trace would make sense if you included
the accessed bit for each spte, instead of just the "young" variable.

Paolo
