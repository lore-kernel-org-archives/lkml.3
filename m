Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3IIGVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 02:21:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35098 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3IIGVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 02:21:17 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <522D681E.1030809@jp.fujitsu.com>
Date: Mon, 09 Sep 2013 15:18:06 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: jingbai.ma@hp.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, akpm@linux-foundation.org, hpa@linux.intel.com,
        vgoyal@redhat.com
Subject: Re: [PATCH 2/2] x86, apic: Disable BSP if boot cpu is AP
References: <20130829092458.5476.10277.stgit@localhost6.localdomain6> <20130829092804.5476.95588.stgit@localhost6.localdomain6> <20130831052252.GC12617@x1.alien8.de> <5223F8DB.3040506@jp.fujitsu.com> <20130902071318.GA3406@x1.alien8.de> <52245D94.5050702@jp.fujitsu.com> <20130904061221.GA17791@x1.alien8.de>
In-Reply-To: <20130904061221.GA17791@x1.alien8.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/04 15:12), Borislav Petkov wrote:
> On Mon, Sep 02, 2013 at 06:42:44PM +0900, HATAYAMA Daisuke wrote:
>> The reason why I don't lookup BSP flag in MSR is that it's impossible.
>> To read MSR of some CPU, we need to use rdmsr instruction on the CPU.
>> However, in case of this issue, the BSP is halting or running in
>> the kdump 1st kernel.
>
> Yes, and on the AP, that flag would be cleared which makes it not a BSP.
>
>> A whole explanation is written in the patch description.
>
> Those tend to get lost in git history when a bunch of whitespace jerk
> offs appear ontop. So a nicely written comment in the code could be very
> helpful.
>
> Thanks.
>

Yes, that's the point this patch series misses. I'll describe the explanation
in Documentation/kexec/kexec.txt and point it in the comment of boot-up code.

-- 
Thanks.
HATAYAMA, Daisuke

