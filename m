Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030321AbaGCJYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:24:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030252AbaGCJX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:56 -0400
Message-ID: <53B52102.7060400@redhat.com>
Date: Thu, 03 Jul 2014 11:23:14 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Chema Gonzalez <chema@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] arm64: eBPF JIT compiler
References: <1404278424-31176-1-git-send-email-zlim.lnx@gmail.com> <20140703091450.GB12958@arm.com>
In-Reply-To: <20140703091450.GB12958@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2014 11:14 AM, Will Deacon wrote:
> On Wed, Jul 02, 2014 at 06:20:24AM +0100, Zi Shen Lim wrote:
>> The JIT compiler emits A64 instructions. It supports eBPF only.
>> Legacy BPF is supported thanks to conversion by BPF core.
>>
>> JIT is enabled in the same way as for other architectures:
>>
>>          echo 1 > /proc/sys/net/core/bpf_jit_enable
>>
>> Or for additional compiler output:
>>
>>          echo 2 > /proc/sys/net/core/bpf_jit_enable
>>
>> See Documentation/networking/filter.txt for more information.
>>
>> The implementation passes all 57 tests in lib/test_bpf.c
>> on ARMv8 Foundation Model :)
>
> First off, this is really cool. Thanks for putting in the effort to get this
> supported on arm64! I'm happy to run tests on some real hardware if you tell
> me how to run them :)

We have lib/test_bpf.c for this, see also Documentation/networking/filter.txt.

So, the procedure would be, e.g.:

  1) echo 1 > /proc/sys/net/core/bpf_jit_enable
  2) modprobe/insmod test_bpf
  3) See kernel log for passes/fails

For seccomp/BPF, there's a test suite in:

  https://github.com/redpig/seccomp
