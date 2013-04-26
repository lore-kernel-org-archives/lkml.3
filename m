Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3DZMcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:32:22 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:40250 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3DZMcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:32:21 -0400
MIME-Version: 1.0
In-Reply-To: <517A6915.2020208@redhat.com>
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com>
 <20130426112539.GA3736@osiris> <517A6915.2020208@redhat.com>
From: Xi Wang <xi.wang@gmail.com>
Date: Fri, 26 Apr 2013 08:31:39 -0400
Message-ID: <CAKU6vybdnpoM-szTrJRDVM2sqNPvAe3Tszg+tCuziKSOEXjJ1w@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] seccomp filter JIT
To: Daniel Borkmann <dborkman@redhat.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>, Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Schichan <nschichan@freebox.fr>,
        Mircea Gherzan <mgherzan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 7:46 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
> I think BPF JIT for seccomp on ARM recently got applied to -mm tree
> if I'm not mistaken. It was from Nicolas Schichan (cc):
>
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/233416/

Thanks for the pointer.

For the ARM part, looks like Nicolas's patch requires to implement two
wrappers for each arch:

  void seccomp_jit_compile(struct seccomp_filter *fp);
  void seccomp_jit_free(struct seccomp_filter *fp);

The implementation of these wrappers is almost identical to:

  void bpf_jit_compile(struct sk_filter *fp);
  void bpf_jit_free(struct sk_filter *fp);

While this patch uses a unified interface for both packet & seccomp filters.

  bpf_func_t bpf_jit_compile(struct sock_filter *filter, unsigned int flen);
  void bpf_jit_free(bpf_func_t bpf_func);

Shouldn't be hard to merge though.

- xi
