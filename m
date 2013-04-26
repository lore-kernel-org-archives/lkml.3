Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3DZPaO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:30:14 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:36741 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3DZPaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:30:12 -0400
MIME-Version: 1.0
In-Reply-To: <1366989094.8964.212.camel@edumazet-glaptop>
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com>
 <1366962706-24204-3-git-send-email-xi.wang@gmail.com> <1366985926.8964.190.camel@edumazet-glaptop>
 <CAKU6vyZfYR-2408G0_Fkp-PS5x5rMH+s4_OOWqqi7Nt+UfiUPg@mail.gmail.com> <1366989094.8964.212.camel@edumazet-glaptop>
From: Xi Wang <xi.wang@gmail.com>
Date: Fri, 26 Apr 2013 11:29:27 -0400
Message-ID: <CAKU6vybrYK9oimKSEGhoLeNzhtk=7r3zouRgzDFqGwJHd=psGQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 2/6] x86: bpf_jit_comp: support
 BPF_S_ANC_SECCOMP_LD_W instruction
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Eric Dumazet <edumazet@google.com>, Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 11:11 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 2) Calling a function potentially destroys some registers.
>    %rdi,%r8,%r9 for instance, so we are going to crash very easily.
>
> I dont know, I feel a bit uncomfortable having to explain this to
> someone sending security related patches...

My old code did save these registers.  But, do we really need that for
seccomp?  For example, %rdi (skb) is always NULL and never used by
seccomp filters.  Did I miss anything?

- xi
