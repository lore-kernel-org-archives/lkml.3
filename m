Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab3IBJnK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:43:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36485 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab3IBJnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:43:08 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <52245D94.5050702@jp.fujitsu.com>
Date: Mon, 02 Sep 2013 18:42:44 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: ebiederm@xmission.com, vgoyal@redhat.com, akpm@linux-foundation.org,
        hpa@linux.intel.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, jingbai.ma@hp.com
Subject: Re: [PATCH 2/2] x86, apic: Disable BSP if boot cpu is AP
References: <20130829092458.5476.10277.stgit@localhost6.localdomain6> <20130829092804.5476.95588.stgit@localhost6.localdomain6> <20130831052252.GC12617@x1.alien8.de> <5223F8DB.3040506@jp.fujitsu.com> <20130902071318.GA3406@x1.alien8.de>
In-Reply-To: <20130902071318.GA3406@x1.alien8.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/02 16:13), Borislav Petkov wrote:
> On Mon, Sep 02, 2013 at 11:32:59AM +0900, HATAYAMA Daisuke wrote:
>> As you suggest, boot_cpu seems more understandable also to me. BTW,
>> please notice that it doesn't denote that the CPU we're booting on
>> currently, but that the CPU with BSP flag set.
>
> Hmm, by "BSP flag set" you mean it is the first LAPIC entry in the MADT,
> correct? At least this is the case when you set isbsp to true. Because,
> there's also the BSC flag in APIC_BAR (MSR 0x1b) which denotes the
> bootstrapping core on node 0.
>

The reason why I don't lookup BSP flag in MSR is that it's impossible.
To read MSR of some CPU, we need to use rdmsr instruction on the CPU.
However, in case of this issue, the BSP is halting or running in
the kdump 1st kernel.

A whole explanation is written in the patch description.

-- 
Thanks.
HATAYAMA, Daisuke

