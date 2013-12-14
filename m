Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab3LNT0z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:26:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58636 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3LNT0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:26:54 -0500
Date: Sat, 14 Dec 2013 09:06:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jesse Barker <jesse.barker@arm.com>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>
Subject: Re: [PATCH 001/115] gpu: ion: Add ION Memory Manager
Message-ID: <20131214170618.GA17461@kroah.com>
References: <1386973529-4884-1-git-send-email-john.stultz@linaro.org>
 <1386973529-4884-2-git-send-email-john.stultz@linaro.org>
 <20131213235028.GA4919@kroah.com>
 <52ABB1C8.1060406@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52ABB1C8.1060406@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 05:18:00PM -0800, John Stultz wrote:
> 0117-ion-Reenable-the-build.patch - This can be applied to the end of
> the series, or folded into the last patch "ion: Update system heap
> shrinker to use the new count/scan interface"

Was there a 0116 patch somewhere?

Everything works fine until this one (i.e. the driver doesn't build),
but after applying this patch, the build breaks with a ton of undefined
symbols at link time, here's a sample of some of them:

ERROR: "ion_carveout_heap_destroy" [drivers/staging/android/ion/ion_heap.ko] undefined!
ERROR: "ion_chunk_heap_destroy" [drivers/staging/android/ion/ion_heap.ko] undefined!
ERROR: "ion_system_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
ERROR: "ion_carveout_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
ERROR: "ion_system_contig_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
ERROR: "ion_cma_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
ERROR: "ion_chunk_heap_create" [drivers/staging/android/ion/ion_heap.ko] undefined!
ERROR: "ion_buffer_destroy" [drivers/staging/android/ion/ion_heap.ko] undefined!
ERROR: "ion_heap_map_user" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
ERROR: "ion_heap_unmap_kernel" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
ERROR: "ion_heap_map_kernel" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
ERROR: "ion_heap_pages_zero" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
ERROR: "ion_pages_sync_for_device" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
ERROR: "ion_buffer_cached" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!
ERROR: "ion_heap_buffer_zero" [drivers/staging/android/ion/ion_chunk_heap.ko] undefined!

So I'm not going to apply this patch, but I have the 115 previous
patches (I took your modified 001 patch that you sent off-list to me.)

Care to fix up the symbol issues in a new series of patches and then
enabling the driver to build?

thanks,

greg k-h
