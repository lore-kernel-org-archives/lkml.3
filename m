Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774Ab3FXWwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:52:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab3FXWws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:52:48 -0400
Message-ID: <51C8CDBC.4000503@redhat.com>
Date: Mon, 24 Jun 2013 18:52:44 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Chegu Vinod <chegu_vinod@hp.com>
CC: rusty@rustcorp.com.au, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>
Subject: Re: kvm_intel: Could not allocate 42 bytes percpu data
References: <51C897A7.50302@hp.com>
In-Reply-To: <51C897A7.50302@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/24/2013 03:01 PM, Chegu Vinod wrote:
> 
> Hello,
> 
> Lots (~700+) of the following messages are showing up in the dmesg of a 3.10-rc1
> based kernel (Host OS is running on a large socket count box with HT-on).
> 
> [   82.270682] PERCPU: allocation failed, size=42 align=16, alloc from reserved
> chunk failed
> [   82.272633] kvm_intel: Could not allocate 42 bytes percpu data

On 3.10?  Geez.  I thought we had fixed this.  I'll grab a big machine and see
if I can debug.

Rusty -- any ideas off the top of your head?'
> 
> ... also call traces like the following...
> 
> [  101.852136]  ffffc901ad5aa090 ffff88084675dd08 ffffffff81633743 ffff88084675ddc8
> [  101.860889]  ffffffff81145053 ffffffff81f3fa78 ffff88084809dd40 ffff8907d1cfd2e8
> [  101.869466]  ffff8907d1cfd280 ffff88087fffdb08 ffff88084675c010 ffff88084675dfd8
> [  101.878190] Call Trace:
> [  101.880953]  [<ffffffff81633743>] dump_stack+0x19/0x1e
> [  101.886679]  [<ffffffff81145053>] pcpu_alloc+0x9a3/0xa40
> [  101.892754]  [<ffffffff81145103>] __alloc_reserved_percpu+0x13/0x20
> [  101.899733]  [<ffffffff810b2d7f>] load_module+0x35f/0x1a70
> [  101.905835]  [<ffffffff8163ad6e>] ? do_page_fault+0xe/0x10
> [  101.911953]  [<ffffffff810b467b>] SyS_init_module+0xfb/0x140
> [  101.918287]  [<ffffffff8163f542>] system_call_fastpath+0x16/0x1b
> [  101.924981] kvm_intel: Could not allocate 42 bytes percpu data
> 
> 
> Wondering if anyone else has seen this with the recent [3.10] based kernels esp.
> on larger boxes?
> 
> There was a similar issue that was reported earlier (where modules were being
> loaded per cpu without checking if an instance was already loaded/being-loaded).
> That issue seems to have been addressed in the recent past (e.g.
> https://lkml.org/lkml/2013/1/24/659 along with a couple of follow on cleanups)  
> Is the above yet another variant of the original issue or perhaps some race
> condition that got exposed when there are lot more threads ?

Hmm ... not sure but yeah, that's the likely culprit.

P.
