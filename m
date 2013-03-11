Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab3CKJCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:02:47 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:18035 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3CKJCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:02:46 -0400
Message-ID: <513D9DB1.7040100@hp.com>
Date: Mon, 11 Mar 2013 17:02:41 +0800
From: Jingbai Ma <jingbai.ma@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130108 Thunderbird/10.0.12
MIME-Version: 1.0
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: jingbai.ma@hp.com, vgoyal@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, lisa.mitchell@hp.com, mingo@redhat.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, ebiederm@xmission.com,
        hpa@zytor.com, yinghai@kernel.org
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel
 to speedup kernel dump process
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net> <20130307152108.GC2790@redhat.com> <5139B827.3050500@hp.com> <20130309.133118.214580151.d.hatayama@jp.fujitsu.com>
In-Reply-To: <20130309.133118.214580151.d.hatayama@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2013 12:31 PM, HATAYAMA Daisuke wrote:
> From: Jingbai Ma<jingbai.ma@hp.com>
> Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel to speedup kernel dump process
> Date: Fri, 8 Mar 2013 18:06:31 +0800
>
>> On 03/07/2013 11:21 PM, Vivek Goyal wrote:
>>> On Thu, Mar 07, 2013 at 10:58:18PM +0800, Jingbai Ma wrote:
> ...
>>> First of all 64MB per TB should not be a huge deal. And makedumpfile
>>> also has this cyclic mode where you process a map, discard it and then
>>> move on to next section. So memory usage remains constant at the
>>> expense
>>> of processing time.
>>
>> Yes, that's true. But in cyclic mode, makedumpfile will have to
>> write/read bitmap from storage, it will also impact the performance.
>> I have measured the penalty for cyclic mode is about 70%
>> slowdown. Maybe could be faster after mmap implemented.
>
> I guess the slowdown came from the issue that enough VMCOREINFO was
> not provided from the kernel, and unnecessary filtering processing for
> free pages is done multiple times.

Thanks for your comments! It would be very helpful.
I will test it on the machine again.

-- 
Jingbai Ma (jingbai.ma@hp.com)
