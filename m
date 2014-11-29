Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaK2B2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 20:28:54 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:58162 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaK2B2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 20:28:52 -0500
Message-ID: <54792138.2060008@huawei.com>
Date: Sat, 29 Nov 2014 09:28:24 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: <masami.hiramatsu.pt@hitachi.com>, <linux@arm.linux.org.uk>,
        <will.deacon@arm.com>, <taras.kondratiuk@linaro.org>,
        <ben.dooks@codethink.co.uk>, <cl@linux.com>, <rabin@rab.in>,
        <davem@davemloft.net>, <lizefan@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 2/2] ARM: kprobes: enable OPTPROBES for ARM 32
References: <1416551751-50846-1-git-send-email-wangnan0@huawei.com>	 <1416551751-50846-3-git-send-email-wangnan0@huawei.com> <1417099007.2041.6.camel@linaro.org>
In-Reply-To: <1417099007.2041.6.camel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.90]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.54792153.0044,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 5eab2da87ec146b6f25dc31e7f8256c7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/27 22:36, Jon Medhurst (Tixy) wrote:
> On Fri, 2014-11-21 at 14:35 +0800, Wang Nan wrote:
>> This patch introduce kprobeopt for ARM 32.
> 
> If I've understood things correctly, this is a feature which inserts
> probes by using a branch instruction to some trampoline code rather than
> using an undefined instruction as a breakpoint. That way we avoid the
> overhead of processing the exception and it is this performance
> improvement which is the main/only reason for implementing it?
> 
> If so, I though it good to see what kind of improvement we get by
> running the micro benchmarks in the kprobes test code. On an A7/A15
> big.LITTLE vexpress board the approximate figures I get are 0.3us for
> optimised probe, 1us for un-optimised, so a three times performance
> improvement. This is with an empty probe pre-handler and no post
> handler, so with a more realistic usecase, the relative improvement we
> get from optimisation would be less.
> 
> I thought it good to see what sort of benefits this code achieves,
> especially as it could grow quite complex over time, and the cost of
> that versus the benefit should be considered.
> 
> 

Thanks for your comments and your comprehensive testing.

In fact I have got even worst performance result on my hardware platform.
However, by utilizing previous introduced checker code to check instructions
in detail, I believe we can eliminate most of the emulation/simulation works
so the cost can be reduced.

Futhermore, kprobeopt can avoid exceptions, which have at least 2 advantanges:

1. Make things simpler. Although exception processing is fast in real hardware,
   it still need more state changing and processing than a branch instruction,
   which may cause unexcepted problems.

2. Branch instructions can be used in more cases than exception. For example,
   at very early stage of kernel booting when exception vector is
   not installed, and at kernel panic processing.



