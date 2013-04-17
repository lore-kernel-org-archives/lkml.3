Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965988Ab3DQHQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 03:16:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42298 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965736Ab3DQHQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 03:16:44 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <516E4C3F.8040302@jp.fujitsu.com>
Date: Wed, 17 Apr 2013 16:16:15 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <toshi.kani@hp.com>,
        <linuxram@us.ibm.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [Bug fix PATCH v3] Reusing a resource structure allocated by
 bootmem
References: <516DEC34.7040008@jp.fujitsu.com> <alpine.DEB.2.02.1304161733340.14583@chino.kir.corp.google.com> <516E2305.3060705@jp.fujitsu.com> <alpine.DEB.2.02.1304162144320.3493@chino.kir.corp.google.com> <516E452A.7060703@jp.fujitsu.com> <alpine.DEB.2.02.1304162351300.5220@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1304162351300.5220@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

2013/04/17 15:52, David Rientjes wrote:
> On Wed, 17 Apr 2013, Yasuaki Ishimatsu wrote:
>
>>> How much memory are we talking about?
>>
>> Hmm. I don't know correctly.
>>
>> Here is kernel message of my system. The message is shown by mem_init().
>>
>
> Do you have an estimate on the amount of struct resource memory that will
> be leaked if entire pages won't be freed?
>

I roughly estimated amount of memory which will leak as follows:

$ wc -l /proc/ioports
92 /proc/ioports
$ wc -l /proc/iomem
226 /proc/iomem

In my system, number of resource structures are 318 and
sizeof(struct resource) is 56 bytes. So even if all resource
structures are leaked, the size is 17 KiB.

Thanks,
Yasuaki Ishimatsu

