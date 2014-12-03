Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaLCPyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 10:54:35 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:38303 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbaLCPyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 10:54:33 -0500
MIME-Version: 1.0
In-Reply-To: <1417595881-32218-1-git-send-email-zlim.lnx@gmail.com>
References: <1417595881-32218-1-git-send-email-zlim.lnx@gmail.com>
Date: Wed, 3 Dec 2014 07:54:32 -0800
Message-ID: <CAMEtUuwJHC2eyOh3pD=qDXw1YbfJqx1a7W0o65n5Ur_B_TvNOA@mail.gmail.com>
Subject: Re: [PATCH] bpf: arm64: lift restriction on last instruction
From: Alexei Starovoitov <ast@plumgrid.com>
To: Zi Shen Lim <zlim.lnx@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 12:38 AM, Zi Shen Lim <zlim.lnx@gmail.com> wrote:
> Earlier implementation assumed last instruction is BPF_EXIT.
> Since this is no longer a restriction in eBPF, we remove this
> limitation.
>
> Per Alexei Starovoitov [1]:
>> classic BPF has a restriction that last insn is always BPF_RET.
>> eBPF doesn't have BPF_RET instruction and this restriction.
>> It has BPF_EXIT insn which can appear anywhere in the program
>> one or more times and it doesn't have to be last insn.
>
> [1] https://lkml.org/lkml/2014/11/27/2
>
> Fixes: e54bcde3d69d ("arm64: eBPF JIT compiler")
> Signed-off-by: Zi Shen Lim <zlim.lnx@gmail.com>

yours is cleaner than my own attempt to fix it.
Thanks!
Acked-by: Alexei Starovoitov <ast@plumgrid.com>
