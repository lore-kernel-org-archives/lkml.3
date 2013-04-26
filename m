Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3DZPUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:20:40 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46804 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab3DZPUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:20:39 -0400
Message-ID: <1366989636.8964.214.camel@edumazet-glaptop>
Subject: Re: [RFC PATCH net-next 1/6] filter: refactor BPF JIT for seccomp
 filters
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Eric Dumazet <edumazet@google.com>, Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Apr 2013 08:20:36 -0700
In-Reply-To: <1366962706-24204-2-git-send-email-xi.wang@gmail.com>
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com>
	 <1366962706-24204-2-git-send-email-xi.wang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 03:51 -0400, Xi Wang wrote:
> Currently, bpf_jit_compile() and bpf_jit_free() takes an sk_filter,
> which seccomp filters cannot reuse.
> 
> Change bpf_jit_compile() to take a pointer to BPF instructions and
> the length, and to return a JITted function.
> 
> Change bpf_jit_free() to take a JITted function.
> 
> Add JIT calls for seccomp filters.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> ---

When submitting a patch serie, full kernel must be fully compile-able
after each patch.

Thats mandatory to be able to perform git bisection in the future.

You cannot change the prototypes as you do in this patch, because it
breaks all the BPF JIT.

arch/x86/net/bpf_jit_comp.c:147:6: error: conflicting types for ‘bpf_jit_compile’
include/linux/filter.h:57:19: note: previous declaration of ‘bpf_jit_compile’ was here
arch/x86/net/bpf_jit_comp.c:749:6: error: conflicting types for ‘bpf_jit_free’
include/linux/filter.h:58:13: note: previous declaration of ‘bpf_jit_free’ was here
make[1]: *** [arch/x86/net/bpf_jit_comp.o] Error 1
make: *** [arch/x86/net/bpf_jit_comp.o] Error 2


