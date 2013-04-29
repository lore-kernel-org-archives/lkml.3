Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab3D2MSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:18:16 -0400
Received: from ns.iliad.fr ([212.27.33.1]:50783 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab3D2MSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:18:15 -0400
Message-ID: <517E6505.6030005@freebox.fr>
Date: Mon, 29 Apr 2013 14:18:13 +0200
From: Nicolas Schichan <nschichan@freebox.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xi Wang <xi.wang@gmail.com>
CC: Daniel Borkmann <dborkman@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>, Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mircea Gherzan <mgherzan@gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] seccomp filter JIT
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com> <20130426112539.GA3736@osiris> <517A6915.2020208@redhat.com> <CAKU6vybdnpoM-szTrJRDVM2sqNPvAe3Tszg+tCuziKSOEXjJ1w@mail.gmail.com>
In-Reply-To: <CAKU6vybdnpoM-szTrJRDVM2sqNPvAe3Tszg+tCuziKSOEXjJ1w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2013 02:31 PM, Xi Wang wrote:
> Thanks for the pointer.
>
> For the ARM part, looks like Nicolas's patch requires to implement two
> wrappers for each arch:
>
>    void seccomp_jit_compile(struct seccomp_filter *fp);
>    void seccomp_jit_free(struct seccomp_filter *fp);
>
> The implementation of these wrappers is almost identical to:
>
>    void bpf_jit_compile(struct sk_filter *fp);
>    void bpf_jit_free(struct sk_filter *fp);
>
> While this patch uses a unified interface for both packet & seccomp filters.
>
>    bpf_func_t bpf_jit_compile(struct sock_filter *filter, unsigned int flen);
>    void bpf_jit_free(bpf_func_t bpf_func);
>
> Shouldn't be hard to merge though.

Hi,

I went for the solution I submitted because I wanted to avoid changes to the 
current bpf_jit_compile prototypes for all currently supported architectures 
(for most of which, I can only compile-test).

My solution also allows the seccomp jit code to be disabled while still 
allowing jit on socket filters (via a Kconfig option). This might be useful to 
some people.

Regards,

-- 
Nicolas Schichan
Freebox SAS
