Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaGJJvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 05:51:12 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:40667 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbaGJJvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 05:51:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140709130017.GL9485@arm.com>
References: <1404803213-10653-1-git-send-email-zlim.lnx@gmail.com>
	<20140709130017.GL9485@arm.com>
Date: Thu, 10 Jul 2014 11:51:08 +0200
Message-ID: <CAMEtUuwuQzYknOm4qqYFa2By=zCOpkk4_zp=_2BuPavg-rPc-A@mail.gmail.com>
Subject: Re: [PATCH RFCv2] arm64: eBPF JIT compiler
From: Alexei Starovoitov <ast@plumgrid.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Chema Gonzalez <chema@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 3:00 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Tue, Jul 08, 2014 at 08:06:53AM +0100, Zi Shen Lim wrote:
>>
>> 1. Implement remaining classes of eBPF instructions: ST|MEM, STX|XADD
>>    which currently do not have corresponding test cases in test_bpf.
>
> I can help out with atomics, if you need it. Are the memory barrier
> semantics well-defined for eBPF?

There are no barrier or cmpxchg instructions in eBPF, since such use case
doesn't exist yet. There is only xadd that is equivalent to atomic_add
which can be JITed as exclusive load/store on arm64.
