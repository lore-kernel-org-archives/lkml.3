Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab3DZPQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:16:30 -0400
Received: from mx0.aculab.com ([213.249.233.131]:40060 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751341Ab3DZPQ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:16:28 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC PATCH net-next 2/6] x86: bpf_jit_comp: support BPF_S_ANC_SECCOMP_LD_W instruction
Date: Fri, 26 Apr 2013 16:15:02 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7208@saturn3.aculab.com>
In-Reply-To: <CAKU6vyZfYR-2408G0_Fkp-PS5x5rMH+s4_OOWqqi7Nt+UfiUPg@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH net-next 2/6] x86: bpf_jit_comp: support BPF_S_ANC_SECCOMP_LD_W instruction
Thread-Index: Ac5CjV0EuVf9XzeRRrSQ6H6HDMtn6AAAyVPg
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com> <1366962706-24204-3-git-send-email-xi.wang@gmail.com> <1366985926.8964.190.camel@edumazet-glaptop> <CAKU6vyZfYR-2408G0_Fkp-PS5x5rMH+s4_OOWqqi7Nt+UfiUPg@mail.gmail.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Xi Wang" <xi.wang@gmail.com>, "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: "Daniel Borkmann" <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>,
        "Eric Dumazet" <edumazet@google.com>, "Will Drewry" <wad@chromium.org>,
        "Andrew Morton" <akpm@linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +#ifdef CONFIG_SECCOMP_FILTER
> >> +                     case BPF_S_ANC_SECCOMP_LD_W:
> >> +                             if (K == offsetof(struct seccomp_data, arch)) {
> >> +                                     int arch = syscall_get_arch(current, NULL);
> >> +
> >> +                                     EMIT1_off32(0xb8, arch); /* mov arch,%eax */
> >> +                                     break;
> >> +                             }
> >> +                             func = (u8 *)seccomp_bpf_load;
> >> +                             t_offset = func - (image + addrs[i]);
> >> +                             EMIT1_off32(0xbf, K); /* mov imm32,%edi */
> >> +                             EMIT1_off32(0xe8, t_offset); /* call seccomp_bpf_load */
> >> +                             break;
> >> +#endif
> >
> > This seems seriously wrong to me.
> 
> Can you elaborate?

The 'call seccomp_bpf_load' needs a pc-relative offset,
I assume that is what EMIT1_off32() generates.

The other two instructions want an absolute 32 bit value...

	David



