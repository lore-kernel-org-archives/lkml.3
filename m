Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbaLBUBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:01:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933506AbaLBUBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:01:43 -0500
Message-ID: <547E1A73.6000805@redhat.com>
Date: Tue, 02 Dec 2014 15:00:51 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steve Capper <steve.capper@linaro.org>,
        David Long <dave.long@linaro.org>
CC: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/5] ARM64: Add kernel probes(Kprobes) support
References: <1416292375-29560-1-git-send-email-dave.long@linaro.org> <20141120135851.GA32528@linaro.org> <54759041.9080105@hitachi.com> <20141126100325.GA9157@linaro.org> <5476120D.9030703@linaro.org> <CAPvkgC3eVOZEn79C9PC9c7TqC_-yCtDhw5LL6ZWUJxr+oQFaow@mail.gmail.com> <5476BFB4.2020705@hitachi.com> <CAPvkgC0ELPPWfa-8kQ4H_e_O5G1ER4KEKuSWLxh_u-VZgh7W6A@mail.gmail.com> <547C36DB.7060903@hitachi.com> <547E129C.1090308@redhat.com>
In-Reply-To: <547E129C.1090308@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 02:27 PM, William Cohen wrote:

> Hi Masami and Dave,
> 
> I have applied the suggested patch above to my local kernel. However, I have noticed systemtap testsuite consistently getting panics when running both before AND after applying that patch to the kernel.  Any thoughts on why "perf stat" would cause that? Below is an example output
> 
> -Will

This problem doesn't look like it is related to the kprobes support.  It can be triggered without running kprobes related code such as a "perf stat make" on a user-space build. It's failure looks similar to:

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-June/265814.html

-Will
> 
> # perf stat make install
> 
> ...
> 
> Running ./systemtap/notest.exp ...
> Running ./systemtap.apps/java.exp ...
> [ 6734.986063] Bad mode in FIQ handler detected, code 0x56000000
> [ 6734.991788] CPU: 0 PID: 3968 Comm: stap Tainted: G            E  3.18.0-rc5kp3+ #3
> [ 6734.999317] Hardware name: APM X-Gene Mustang board (DT)
> [ 6735.004602] task: fffffe0016c25a00 ti: fffffe03d8aa8000 task.ti: fffffe03d8aa8000
> [ 6735.012052] PC is at 0x3ff7fc0d1fc
> [ 6735.015434] LR is at 0x3ff7fc31838
> [ 6735.018815] pc : [<000003ff7fc0d1fc>] lr : [<000003ff7fc31838>] pstate: 00000000
> [ 6735.026172] sp : fffffe03d8aabff0
> [ 6735.029467] x29: 000003fffe4f6460 x28: 000003ff7fb23640 
> [ 6735.034772] x27: 000003ff7fb23578 x26: 000000000059a420 
> [ 6735.040074] x25: 000000000000005f x24: 000003ff7fb3f000 
> [ 6735.045375] x23: 000000004178ee40 x22: 0000000000000006 
> [ 6735.050680] x21: 0000000000000001 x20: 0000000000008000 
> [ 6735.055980] x19: 000000004178ee40 x18: 000003fffe4f64a0 
> [ 6735.061282] x17: 000003ff7fc0d1fc x16: 000003ff7fd00008 
> [ 6735.066585] x15: 00000013cd9f3df0 x14: 0000000051c4a1f8 
> [ 6735.071886] x13: 0000000001519f64 x12: 000000000000000e 
> [ 6735.077187] x11: 646f6d2f62696c2f x10: 6174732f706d742f 
> [ 6735.082488] x9 : 312e332f73656c75 x8 : 0000000000000038 
> [ 6735.087790] x7 : 5f34366372617073 x6 : 000000000000007c 
> [ 6735.093094] x5 : 0000000000000000 x4 : 0000000000000001 
> [ 6735.098397] x3 : 0000000000000000 x2 : 0000000000000000 
> [ 6735.103697] x1 : 0000000000000001 x0 : 0000000000008030 
> [ 6735.108999] 
> [ 6735.110483] Bad mode in Synchronous Abort handler detected, code 0x8600000f
> [ 6735.117408] CPU: 0 PID: 3968 Comm: stap Tainted: G            E  3.18.0-rc5kp3+ #3
> [ 6735.124936] Hardware name: APM X-Gene Mustang board (DT)
> [ 6735.130220] task: fffffe0016c25a00 ti: fffffe03d8aa8000 task.ti: fffffe03d8aa8000
> [ 6735.137662] PC is at 0x3ff7fc31838
> [ 6735.141044] LR is at 0x3ff7fc31838
> [ 6735.144426] pc : [<000003ff7fc31838>] lr : [<000003ff7fc31838>] pstate: 600003c5
> [ 6735.151782] sp : fffffe03d8aabed0
> [ 6735.155077] x29: 000003fffe4f6460 x28: 000003ff7fb23640 
> [ 6735.160380] x27: 000003ff7fb23578 x26: 000000000059a420 
> [ 6735.165681] x25: 000000000000005f x24: 000003ff7fb3f000 
> [ 6735.170983] x23: 0000000000000000 x22: 000003ff7fc0d1fc 
> [ 6735.176285] x21: fffffe03d8aabff0 x20: 0000000000008000 
> [ 6735.181587] x19: 000000004178ee40 x18: 000003fffe4f64a0 
> [ 6735.186888] x17: 000003ff7fc0d1fc x16: 000003ff7fd00008 
> [ 6735.192189] x15: 00000013cd9f3df0 x14: 30303030203a6574 
> [ 6735.197490] x13: fffffe00008eda38 x12: cb88537fdc8cb000 
> [ 6735.202792] x11: fffffe03d8aabb70 x10: fffffe03d8aabb70 
> [ 6735.208094] x9 : 000000000000015f x8 : 0000000000000000 
> [ 6735.213395] x7 : 0000000000000200 x6 : fffffe0000095cd4 
> [ 6735.218698] x5 : fffffe0300030001 x4 : 0000000000000000 
> [ 6735.224001] x3 : fffffe03d8aabc80 x2 : 000000000000027e 
> [ 6735.229304] x1 : cb88537fdc8cb000 x0 : cb88537fdc8cb000 

<snip>

