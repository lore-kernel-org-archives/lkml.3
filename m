Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3LNTns (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:43:48 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:47898 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3LNTnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:43:46 -0500
Message-ID: <52ACB4EF.3010406@linaro.org>
Date: Sat, 14 Dec 2013 11:43:43 -0800
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
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org> <1386973529-4884-2-git-send-email-john.stultz@linaro.org> <20131213235028.GA4919@kroah.com> <52ABB1C8.1060406@linaro.org> <20131214170618.GA17461@kroah.com>
In-Reply-To: <20131214170618.GA17461@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 09:06 AM, Greg KH wrote:
> On Fri, Dec 13, 2013 at 05:18:00PM -0800, John Stultz wrote:
>> 0117-ion-Reenable-the-build.patch - This can be applied to the end of
>> the series, or folded into the last patch "ion: Update system heap
>> shrinker to use the new count/scan interface"
> Was there a 0116 patch somewhere?
No.. the disable build patch was inserted between patch 1 and 2, so
after the renumbering the re-enable patch was 117.

When I selected the disable patch to send I renamed it 0001 just to make
it more clear which one it would apply to.

Sorry for the confusion.

> Everything works fine until this one (i.e. the driver doesn't build),
> but after applying this patch, the build breaks with a ton of undefined
> symbols at link time, here's a sample of some of them:
>
> ERROR: "ion_carveout_heap_destroy" [drivers/staging/android/ion/ion_heap.ko] undefined!
> ERROR: "ion_chunk_heap_destroy" [drivers/staging/android/ion/ion_heap.ko] undefined!
> ERROR: "ion_system_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
> ERROR: "ion_carveout_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
> ERROR: "ion_system_contig_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
> ERROR: "ion_cma_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
> ERROR: "ion_chunk_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
> ERROR: "ion_buffer_destroy" [drivers/staging/android/ion/ion_heap.ko] undefined!
> ERROR: "ion_heap_map_user" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
> ERROR: "ion_heap_unmap_kernel" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
> ERROR: "ion_heap_map_kernel" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
> ERROR: "ion_heap_pages_zero" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
> ERROR: "ion_pages_sync_for_device" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
> ERROR: "ion_buffer_cached" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
> ERROR: "ion_heap_buffer_zero" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
>
> So I'm not going to apply this patch, but I have the 115 previous
> patches (I took your modified 001 patch that you sent off-list to me.)

? Hrmm. I'm not seeing this (I wouldn't have sent the patches if I did!).

If you have the chance, could you send me your config?

> Care to fix up the symbol issues in a new series of patches and then
> enabling the driver to build?
Will do.

thanks
-john


