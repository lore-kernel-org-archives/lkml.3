Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab3J1Hhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 03:37:51 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56889 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3J1Hht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 03:37:49 -0400
X-AuditID: 9c930197-b7b3eae00000122e-bc-526e144bb22e
Date: Mon, 28 Oct 2013 16:37:48 +0900
From: Minchan Kim <minchan@kernel.org>
To: =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, pali.rohar@gmail.com,
        pc+n900@asdf.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: OMAPFB: CMA allocation failures
Message-ID: <20131028073748.GA17038@bbox>
References: <991366690.30380.1381819791799.JavaMail.apache@mail83.abv.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <991366690.30380.1381819791799.JavaMail.apache@mail83.abv.bg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Oct 15, 2013 at 09:49:51AM +0300, Ивайло Димитров wrote:
>  Hi
> 
>  >-------- Оригинално писмо --------
>  >От:  Tomi Valkeinen 
>  >Относно: Re: OMAPFB: CMA allocation failures
>  >До: Ивайло Димитров
> 	
>  >Изпратено на: Понеделник, 2013, Октомври 14 09:04:35 EEST
>  >
>  >
>  >Hi,
>  >
>  >On 12/10/13 17:43, Ивайло Димитров wrote:
>  >>  Hi Tomi,
>  >> 
>  >> patch http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/131269.html modifies
>  >> omapfb driver to use DMA API to allocate framebuffer memory instead of preallocating VRAM.
>  >> 
>  >> With this patch I see a lot of:
>  >> 
>  >> Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.879577] cma: dma_alloc_from_contiguous(cma c05f5844, count 192, align 8)
>  >> Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.914215] cma: dma_alloc_from_contiguous(): memory range at c07df000 is busy, retrying
>  >> Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.933502] cma: dma_alloc_from_contiguous(): memory range at c07e1000 is busy, retrying
>  >> Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.940032] cma: dma_alloc_from_contiguous(): memory range at c07e3000 is busy, retrying
>  >> Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.966644] cma: dma_alloc_from_contiguous(): memory range at c07e5000 is busy, retrying
>  >> Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.976867] cma: dma_alloc_from_contiguous(): memory range at c07e7000 is busy, retrying
>  >> Jan  1 06:33:27 Nokia-N900 kernel: [ 2055.038055] cma: dma_alloc_from_contiguous(): memory range at c07e9000 is busy, retrying
>  >> Jan  1 06:33:27 Nokia-N900 kernel: [ 2055.038116] cma: dma_alloc_from_contiguous(): returned   (null)
>  >> Jan  1 06:33:27 Nokia-N900 kernel: [ 2055.038146] omapfb omapfb: failed to allocate framebuffer
>  >> 
>  >> errors while trying to play a video on N900 with Maemo 5 (Fremantle) on top of linux-3.12rc1.
>  >> It is deffinitely the CMA that fails to allocate the memory most of the times, but I wonder
>  >> how reliable CMA is to be used in omapfb. I even reserved 64MB for CMA, but that made no
>  >> difference. If CMA is disabled, the memory allocation still fails as obviously it is highly
>  >> unlikely there will be such a big chunk of continuous free memory on RAM limited device like
>  >> N900. 
>  >> 
>  >> One obvious solution is to just revert the removal of VRAM memory allocator, but that would
>  >> mean I'll have to maintain a separate tree with all the implications that brings.
>  >> 
>  >> What would you advise on how to deal with the issue?
>  >
>  >I've not seen such errors, and I'm no expert on CMA. But I guess the
>  >contiguous memory area can get fragmented enough no matter how hard one
>  >tries to avoid it. The old VRAM system had the same issue, although it
>  >was quite difficult to hit it.
> 
> I am using my n900 as a daily/only device since the beginning of 2010, never seen such an 
> issue with video playback. And as a maintainer of one of the community supported kernels for
> n900 (kernel-power) I've never had such an issue reported. On stock kernel and derivatives of
> course. It seems VRAM allocator is virtually impossible to fail, while with CMA OMAPFB fails on
> the first video after boot-up.
> 
> When saying you've not seen such an issue - did you actually test video playback, on what
> device and using which distro? Did you use DSP accelerated decoding?
> 
>  >64MB does sound quite a lot, though. I wonder what other drivers are
>  >using CMA, and how do they manage to allocate so much memory and
>  >fragment it so badly... With double buffering, N900 should only need
>  >something like 3MB for the frame buffer.
> 
> Sure, 64 MB is a lot, but I just wanted to see if that would make any difference. And for 720p 
> 3MB is not enough, something like 8MB is needed.
> 
>  >With a quick glance I didn't find any debugfs or such files to show
>  >information about the CMA area. It'd be helpful to find out what's going
>  >on there. Or maybe normal allocations are fragmenting the CMA area, but
>  >for some reason they cannot be moved? Just guessing.
> 
> I was able to track down the failures to:
> http://lxr.free-electrons.com/source/mm/migrate.c#L320

That path is for anonymous page migration so the culprit I can think of
is that you did get_user_pages on those anonymous pages for pin them.
Right?

If so, it's no surpse that fails the migration and CMA doesn't work.

-- 
Kind regards,
Minchan Kim
