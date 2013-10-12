Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493Ab3JLOsw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 10:48:52 -0400
Received: from smtp-out.abv.bg ([194.153.145.70]:35063 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab3JLOsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 10:48:51 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Oct 2013 10:48:50 EDT
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=VkRvENIHNnW2SN+fKpAiaUmUHYZycV1UsuImBJC/+en8vcBAxAR5QV7Sx/omOTjZ+
	9q9Ze/nr3yBoWOzCW3BKucqfIS5cvd62u3KWqvFSJMNEi5mzVr+0rmuQ/jIqruxA5pT
	qU/z6K6dRcCbCFn+7feGWomHXJhgEXrfKlUpRtY=
Date: Sat, 12 Oct 2013 17:43:08 +0300 (EEST)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
To: tomi.valkeinen@ti.com
Cc: pali.rohar@gmail.com, pc+n900@asdf.org, linux-kernel@vger.kernel.org
Message-ID: <950342286.150022.1381588988533.JavaMail.apache@mail83.abv.bg>
Subject: OMAPFB: CMA allocation failures
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-Mailer: AbvMail 1.0
X-Originating-IP: 46.249.74.23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi Tomi,

patch http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/131269.html modifies
omapfb driver to use DMA API to allocate framebuffer memory instead of preallocating VRAM.

With this patch I see a lot of:

Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.879577] cma: dma_alloc_from_contiguous(cma c05f5844, count 192, align 8)
Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.914215] cma: dma_alloc_from_contiguous(): memory range at c07df000 is busy, retrying
Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.933502] cma: dma_alloc_from_contiguous(): memory range at c07e1000 is busy, retrying
Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.940032] cma: dma_alloc_from_contiguous(): memory range at c07e3000 is busy, retrying
Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.966644] cma: dma_alloc_from_contiguous(): memory range at c07e5000 is busy, retrying
Jan  1 06:33:27 Nokia-N900 kernel: [ 2054.976867] cma: dma_alloc_from_contiguous(): memory range at c07e7000 is busy, retrying
Jan  1 06:33:27 Nokia-N900 kernel: [ 2055.038055] cma: dma_alloc_from_contiguous(): memory range at c07e9000 is busy, retrying
Jan  1 06:33:27 Nokia-N900 kernel: [ 2055.038116] cma: dma_alloc_from_contiguous(): returned   (null)
Jan  1 06:33:27 Nokia-N900 kernel: [ 2055.038146] omapfb omapfb: failed to allocate framebuffer

errors while trying to play a video on N900 with Maemo 5 (Fremantle) on top of linux-3.12rc1.
It is deffinitely the CMA that fails to allocate the memory most of the times, but I wonder
how reliable CMA is to be used in omapfb. I even reserved 64MB for CMA, but that made no
difference. If CMA is disabled, the memory allocation still fails as obviously it is highly
unlikely there will be such a big chunk of continuous free memory on RAM limited device like
N900. 

One obvious solution is to just revert the removal of VRAM memory allocator, but that would
mean I'll have to maintain a separate tree with all the implications that brings.

What would you advise on how to deal with the issue?

Regards,
Ivo
