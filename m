Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab3CNTxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 15:53:09 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:59918 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3CNTxH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 15:53:07 -0400
MIME-Version: 1.0
In-Reply-To: <51422008.3020208@gmx.de>
References: <51422008.3020208@gmx.de>
Date: Thu, 14 Mar 2013 20:53:05 +0100
Message-ID: <CAFLxGvxeOyg=zXqK+q5BpTHcpnaymk0_cyTUkUyRxD_C3czZww@mail.gmail.com>
Subject: Re: SLAB + UML : WARNING: at mm/page_alloc.c:2386
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-mm@kvack.org, user-mode-linux-user@lists.sourceforge.net,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 8:07 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> The following WARNING: can be triggered sometimes with trinity [1] under a user mode linux image
> using the SLUB allocator (and not with SLAB)
>
>
> 2013-03-14T19:09:51.071+01:00 trinity kernel: ------------[ cut here ]------------
> 2013-03-14T19:09:51.071+01:00 trinity kernel: WARNING: at mm/page_alloc.c:2386 __alloc_pages_nodemask+0x153/0x750()
> 2013-03-14T19:09:51.071+01:00 trinity kernel: 3899fd14:  [<08342dd8>] dump_stack+0x22/0x24
> 2013-03-14T19:09:51.071+01:00 trinity kernel: 3899fd2c:  [<0807d0da>] warn_slowpath_common+0x5a/0x80
> 2013-03-14T19:09:51.071+01:00 trinity kernel: 3899fd54:  [<0807d1a3>] warn_slowpath_null+0x23/0x30
> 2013-03-14T19:09:51.071+01:00 trinity kernel: 3899fd64:  [<080d3213>] __alloc_pages_nodemask+0x153/0x750
> 2013-03-14T19:09:51.071+01:00 trinity kernel: 3899fdf0:  [<080d3838>] __get_free_pages+0x28/0x50
> 2013-03-14T19:09:51.071+01:00 trinity kernel: 3899fe08:  [<080fc48f>] __kmalloc_track_caller+0x3f/0x180
> 2013-03-14T19:09:51.071+01:00 trinity kernel: 3899fe30:  [<080dec76>] memdup_user+0x26/0x70
> 2013-03-14T19:09:51.071+01:00 trinity kernel: 3899fe4c:  [<080dee7e>] strndup_user+0x3e/0x60
> 2013-03-14T19:09:51.076+01:00 trinity kernel: 3899fe68:  [<0811b440>] copy_mount_string+0x30/0x50
> 2013-03-14T19:09:51.076+01:00 trinity kernel: 3899fe7c:  [<0811be0a>] sys_mount+0x1a/0xe0
> 2013-03-14T19:09:51.076+01:00 trinity kernel: 3899feac:  [<08062a92>] handle_syscall+0x82/0xb0
> 2013-03-14T19:09:51.076+01:00 trinity kernel: 3899fef4:  [<08074e7d>] userspace+0x46d/0x590
> 2013-03-14T19:09:51.076+01:00 trinity kernel: 3899ffec:  [<0805f7cc>] fork_handler+0x6c/0x70
> 2013-03-14T19:09:51.076+01:00 trinity kernel: 3899fffc:  [<5a5a5a5a>] 0x5a5a5a5a
> 2013-03-14T19:09:51.076+01:00 trinity kernel:
> 2013-03-14T19:09:51.076+01:00 trinity kernel: ---[ end trace fd6f346f805efdbe ]---

Looks like strndup_user() triggers the issue.
In another trace also strndup_user() appeared.
-- 
Thanks,
//richard
