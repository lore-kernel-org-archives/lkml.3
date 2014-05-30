Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaE3C5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 22:57:11 -0400
Received: from mail-oa0-f65.google.com ([209.85.219.65]:40073 "EHLO
	mail-oa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaE3C5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 22:57:09 -0400
MIME-Version: 1.0
Date: Fri, 30 May 2014 10:57:08 +0800
Message-ID: <CAGO-9moQrepikUk198XjgiE=hC2W6u_Wsup8yK=ooBfPNg1PfQ@mail.gmail.com>
Subject: Ask for help on the memory allocation for process shared mutex
 (resend with plain text)
From: yang ben <benyangfsl@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear experts,

I came across a memory/mutex issue. Would you kindly shed some light on it?

I use pthread_mutex_xxx API to protect processes in user space. Since
it should be process shared, I allocated a shared memory to store
pthread_mutex_t structure.

The shared memory is allocated using vmalloc_user() and mapped using
remap_vmalloc_range() in driver. However, get_futex_key() will always
return -EFAULT, because page_head->mapping==0.

futex.c (Linux-3.10.31)
         if (!page_head->mapping) {
                 int shmem_swizzled = PageSwapCache(page_head);
                 unlock_page(page_head);
                 put_page(page_head);
                 if (shmem_swizzled)
                         goto again;
                 return -EFAULT;
         }

Is there special requirement on the memory to store mutex? What's the
correct way to allocate such memory in driver?
Thanks in advance!

Regards,
Ben
