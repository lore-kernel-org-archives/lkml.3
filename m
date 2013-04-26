Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3DZOus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:50:48 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:64929 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab3DZOur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:50:47 -0400
MIME-Version: 1.0
In-Reply-To: <1366985926.8964.190.camel@edumazet-glaptop>
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com>
 <1366962706-24204-3-git-send-email-xi.wang@gmail.com> <1366985926.8964.190.camel@edumazet-glaptop>
From: Xi Wang <xi.wang@gmail.com>
Date: Fri, 26 Apr 2013 10:50:06 -0400
Message-ID: <CAKU6vyZfYR-2408G0_Fkp-PS5x5rMH+s4_OOWqqi7Nt+UfiUPg@mail.gmail.com>
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

On Fri, Apr 26, 2013 at 10:18 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Fri, 2013-04-26 at 03:51 -0400, Xi Wang wrote:
>
>> +#ifdef CONFIG_SECCOMP_FILTER
>> +                     case BPF_S_ANC_SECCOMP_LD_W:
>> +                             if (K == offsetof(struct seccomp_data, arch)) {
>> +                                     int arch = syscall_get_arch(current, NULL);
>> +
>> +                                     EMIT1_off32(0xb8, arch); /* mov arch,%eax */
>> +                                     break;
>> +                             }
>> +                             func = (u8 *)seccomp_bpf_load;
>> +                             t_offset = func - (image + addrs[i]);
>> +                             EMIT1_off32(0xbf, K); /* mov imm32,%edi */
>> +                             EMIT1_off32(0xe8, t_offset); /* call seccomp_bpf_load */
>> +                             break;
>> +#endif
>
> This seems seriously wrong to me.

Can you elaborate?

> This cannot have been tested at all.

Thanks to QEMU for hiding bugs then. :)

- xi
