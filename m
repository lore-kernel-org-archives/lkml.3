Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbaFXAee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:34:34 -0400
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:56563 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbaFXAed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:34:33 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53A8C76A.4060207@jp.fujitsu.com>
Date: Tue, 24 Jun 2014 09:33:46 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <akpm@linux-foundation.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <tangchen@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
        <guz.fnst@cn.fujitsu.com>, <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] x86,mem-hotplug: pass sync_global_pgds() a correct
 argument in remove_pagetable()
References: <53A132E2.9000605@jp.fujitsu.com>	 <53A1339E.2000000@jp.fujitsu.com> <1403288831.25108.0.camel@misato.fc.hp.com>
In-Reply-To: <1403288831.25108.0.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/21 3:27), Toshi Kani wrote:
> On Wed, 2014-06-18 at 15:37 +0900, Yasuaki Ishimatsu wrote:
>> remove_pagetable() gets start argument and passes the argument to
>> sync_global_pgds(). In this case, the argument must not be modified.
>> If the argument is modified and passed to sync_global_pgds(),
>> sync_global_pgds() does not correctly synchronize PGD to PGD entries
>> of all processes MM since synchronized range of memory [start, end]
>> is wrong.
>>
>> Unfortunately the start argument is modified in remove_pagetable().
>> So this patch fixes the issue.
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>

> Acked-by: Toshi Kani <toshi.kani@hp.com>

Thank you for your review.

Thanks,
Yasuak Ishimatsu

>
> Thanks,
> -Toshi
>
>


