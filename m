Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3LNTyB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:54:01 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:62700 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3LNTyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:54:00 -0500
Message-ID: <52ACB753.1040105@linaro.org>
Date: Sat, 14 Dec 2013 11:53:55 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>
Subject: Re: [PATCH 001/115] gpu: ion: Add ION Memory Manager
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org> <1386973529-4884-2-git-send-email-john.stultz@linaro.org> <20131213235028.GA4919@kroah.com> <52ABB1C8.1060406@linaro.org> <20131214170618.GA17461@kroah.com> <52ACB4EF.3010406@linaro.org>
In-Reply-To: <52ACB4EF.3010406@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 11:43 AM, John Stultz wrote:
> On 12/14/2013 09:06 AM, Greg KH wrote:
>> Everything works fine until this one (i.e. the driver doesn't build),
>> but after applying this patch, the build breaks with a ton of undefined
>> symbols at link time, here's a sample of some of them:
>>
>> ERROR: "ion_carveout_heap_destroy" [drivers/staging/android/ion/ion_heap.ko] undefined!
>> ERROR: "ion_chunk_heap_destroy" [drivers/staging/android/ion/ion_heap.ko] undefined!
>> ERROR: "ion_system_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
>> ERROR: "ion_carveout_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
>> ERROR: "ion_system_contig_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
>> ERROR: "ion_cma_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
>> ERROR: "ion_chunk_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
>> ERROR: "ion_buffer_destroy" [drivers/staging/android/ion/ion_heap.ko] undefined!
>> ERROR: "ion_heap_map_user" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
>> ERROR: "ion_heap_unmap_kernel" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
>> ERROR: "ion_heap_map_kernel" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
>> ERROR: "ion_heap_pages_zero" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
>> ERROR: "ion_pages_sync_for_device" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
>> ERROR: "ion_buffer_cached" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
>> ERROR: "ion_heap_buffer_zero" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
>>
>> So I'm not going to apply this patch, but I have the 115 previous
>> patches (I took your modified 001 patch that you sent off-list to me.)
> ? Hrmm. I'm not seeing this (I wouldn't have sent the patches if I did!).

Ah.. its a problem with make modules. I see it now. Will have a fix for
you shortly.

thanks
-john


