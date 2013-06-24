Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3FXTCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:02:03 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:38905 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3FXTCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:02:02 -0400
Message-ID: <51C897A7.50302@hp.com>
Date: Mon, 24 Jun 2013 12:01:59 -0700
From: Chegu Vinod <chegu_vinod@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: rusty@rustcorp.com.au, prarit@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC: KVM <kvm@vger.kernel.org>
Subject: kvm_intel: Could not allocate 42 bytes percpu data
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

Lots (~700+) of the following messages are showing up in the dmesg of a 
3.10-rc1 based kernel (Host OS is running on a large socket count box 
with HT-on).

[   82.270682] PERCPU: allocation failed, size=42 align=16, alloc from 
reserved chunk failed
[   82.272633] kvm_intel: Could not allocate 42 bytes percpu data

... also call traces like the following...

[  101.852136]  ffffc901ad5aa090 ffff88084675dd08 ffffffff81633743 
ffff88084675ddc8
[  101.860889]  ffffffff81145053 ffffffff81f3fa78 ffff88084809dd40 
ffff8907d1cfd2e8
[  101.869466]  ffff8907d1cfd280 ffff88087fffdb08 ffff88084675c010 
ffff88084675dfd8
[  101.878190] Call Trace:
[  101.880953]  [<ffffffff81633743>] dump_stack+0x19/0x1e
[  101.886679]  [<ffffffff81145053>] pcpu_alloc+0x9a3/0xa40
[  101.892754]  [<ffffffff81145103>] __alloc_reserved_percpu+0x13/0x20
[  101.899733]  [<ffffffff810b2d7f>] load_module+0x35f/0x1a70
[  101.905835]  [<ffffffff8163ad6e>] ? do_page_fault+0xe/0x10
[  101.911953]  [<ffffffff810b467b>] SyS_init_module+0xfb/0x140
[  101.918287]  [<ffffffff8163f542>] system_call_fastpath+0x16/0x1b
[  101.924981] kvm_intel: Could not allocate 42 bytes percpu data


Wondering if anyone else has seen this with the recent [3.10] based 
kernels esp. on larger boxes?

There was a similar issue that was reported earlier (where modules were 
being loaded per cpu without checking if an instance was already 
loaded/being-loaded). That issue seems to have been addressed in the 
recent past (e.g. https://lkml.org/lkml/2013/1/24/659 along with a 
couple of follow on cleanups)   Is the above yet another variant of the 
original issue or perhaps some race condition that got exposed when 
there are lot more threads ?

Vinod



