Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbaC0LHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 07:07:54 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:47626 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbaC0LHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 07:07:52 -0400
From: Ma Haijun <mahaijuns@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Al Viro <viro@ZenIV.linux.org.uk>,
        Ma Haijun <mahaijuns@gmail.com>
Subject: [media] videobuf-dma-contig: fix vm_iomap_memory() call
Date: Thu, 27 Mar 2014 19:07:05 +0800
Message-Id: <1395918426-27787-1-git-send-email-mahaijuns@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a trivial fix, but I think the patch itself has problem too. 
The function requires a phys_addr_t, but we feed it with a dma_handle_t.
AFAIK, this implicit conversion does not always work.
Can I use virt_to_phys(mem->vaddr) to get the physical address instead?
(mem->vaddr and mem->dma_handle are from dma_alloc_coherent)

Regards

Ma Haijun

Ma Haijun (1):
  [media] videobuf-dma-contig: fix incorrect argument to
    vm_iomap_memory() call

 drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
1.8.3.2

