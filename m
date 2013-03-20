Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab3CTUGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:06:40 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:40430 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab3CTUGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:06:39 -0400
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 17:06:39 -0300
Message-ID: <CAHG_u-=ChwiQ72O-9z1eD5Pex-niYMaRwMUOQOryYuPO154G=A@mail.gmail.com>
Subject: remap kernel static memory to user space
From: Eduardo Cruz <eduardohmdacruz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm trying to remap some kernel static memory to user space using
remap_pfn_range.
For that, I wrote a module that initializes a device, which later I
use mknod, etc.

When I allocate the memory with kmalloc, everything works:   (where
user_space_shared was allocated with kmalloc)

if ((ret = remap_pfn_range(vma, vma->vm_start,
virt_to_phys(user_space_shared) >> PAGE_SHIFT, length,
vma->vm_page_prot)) < 0)

In the application in user space:
kstc = mmap(0, sizeof(user_space_shared_t), PROT_READ|PROT_WRITE,
MAP_SHARED| MAP_LOCKED, fd, 0);

With user_space_shared allocated using kmalloc, it is working.
The application is able to read the data I wrote in the kernel module.

However, when I define and allocate that var in arch/ia64/mm/fault.c:

unsigned char user_space_shared[ sizeof(user_space_shared_t) +
PAGE_SIZE ] __attribute__((aligned(PAGE_SIZE)));
EXPORT_SYMBOL(user_space_shared);

And access that var from the module:

extern unsigned char user_space_shared[ sizeof(user_space_shared_t) +
PAGE_SIZE ];

There is no error message, but I can't read the contents i wrote
inside the kernel module from the application.

Your help would be appreciated.

ps:
I am taking care of page offsets/boundaries.
I'm using kernel 2.6.32 for ia64.


-- 
Eduardo Henrique Molina da Cruz
PhD student
Parallel and Distributed Processing Group
Federal University of Rio Grande do Sul (UFRGS)
