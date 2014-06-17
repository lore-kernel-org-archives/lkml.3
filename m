Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbaFQIVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:21:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720AbaFQIVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:21:11 -0400
Message-ID: <539FFA6B.9030004@redhat.com>
Date: Tue, 17 Jun 2014 10:20:59 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Alexei Starovoitov <ast@plumgrid.com>
Subject: Re: mips:allmodconfig build failure in 3.16-rc1 due to bpf_jit code
References: <539FA6CB.5050703@roeck-us.net>
In-Reply-To: <539FA6CB.5050703@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 04:24 AM, Guenter Roeck wrote:
> mips:allmodconfig fails in 3.16-rc1 with lots of undefined symbols.
>
> arch/mips/net/bpf_jit.c: In function 'is_load_to_a':
> arch/mips/net/bpf_jit.c:559:7: error: 'BPF_S_LD_W_LEN' undeclared (first use in this function)
> arch/mips/net/bpf_jit.c:559:7: note: each undeclared identifier is reported only once for each function it appears in
> arch/mips/net/bpf_jit.c:560:7: error: 'BPF_S_LD_W_ABS' undeclared (first use in this function)
> arch/mips/net/bpf_jit.c:561:7: error: 'BPF_S_LD_H_ABS' undeclared (first use in this function)
> arch/mips/net/bpf_jit.c:562:7: error: 'BPF_S_LD_B_ABS' undeclared (first use in this function)
> arch/mips/net/bpf_jit.c:563:7: error: 'BPF_S_ANC_CPU' undeclared (first use in this function)
> arch/mips/net/bpf_jit.c:564:7: error: 'BPF_S_ANC_IFINDEX' undeclared (first use in this function)
> arch/mips/net/bpf_jit.c:565:7: error: 'BPF_S_ANC_MARK' undeclared (first use in this function)
>
> and so on.
>
> Those symbols are not defined anywhere.
>
> The problem is due to a conflict with commit 348059313 (net: filter: get rid of BPF_S_*
> enum), which removed those definitions.

Yep, it seems both got in this merge window from different trees. Don't have mips, but
I'll have a look, and send you a patch.
