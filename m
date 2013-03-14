Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3CNU6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:58:38 -0400
Received: from mout.gmx.net ([212.227.15.18]:64044 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab3CNU6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:58:37 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX198aJwDob18DIRSZNKLGTtQdfunYd3eaceeZJSvDl
	jzdJE0D0AXhwCB
Message-ID: <514239F7.3050704@gmx.de>
Date: Thu, 14 Mar 2013 21:58:31 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130309 Thunderbird/17.0.4
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: linux-mm@kvack.org, user-mode-linux-user@lists.sourceforge.net,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SLUB + UML : WARNING: at mm/page_alloc.c:2386
References: <51422008.3020208@gmx.de> <CAFLxGvyzkSsUJQMefeB2PcVBykZNqCQe5k19k0MqyVr111848w@mail.gmail.com>
In-Reply-To: <CAFLxGvyzkSsUJQMefeB2PcVBykZNqCQe5k19k0MqyVr111848w@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 09:51 PM, richard -rw- weinberger wrote:
> Can you please re-run with the attached patch.
> I'm wondering how much memory is requested.
>>From reading the source I'd say it must be less than PAGE_SIZE.
> But such a small allocation would not trigger the WARN_ON()...


2013-03-14T21:56:58.000+01:00 trinity sshd[1158]: pam_unix(sshd:session): session opened for user tfoerste by (uid=0)
2013-03-14T21:56:59.852+01:00 trinity kernel: memdup_user: -14
2013-03-14T21:56:59.852+01:00 trinity kernel: ------------[ cut here ]------------
2013-03-14T21:56:59.852+01:00 trinity kernel: WARNING: at mm/page_alloc.c:2386 __alloc_pages_nodemask+0x153/0x750()
2013-03-14T21:56:59.852+01:00 trinity kernel: 38bfbd14:  [<08342dd8>] dump_stack+0x22/0x24
2013-03-14T21:56:59.852+01:00 trinity kernel: 38bfbd2c:  [<0807d0da>] warn_slowpath_common+0x5a/0x80
2013-03-14T21:56:59.852+01:00 trinity kernel: 38bfbd54:  [<0807d1a3>] warn_slowpath_null+0x23/0x30
2013-03-14T21:56:59.852+01:00 trinity kernel: 38bfbd64:  [<080d3213>] __alloc_pages_nodemask+0x153/0x750
2013-03-14T21:56:59.852+01:00 trinity kernel: 38bfbdf0:  [<080d3838>] __get_free_pages+0x28/0x50
2013-03-14T21:56:59.852+01:00 trinity kernel: 38bfbe08:  [<080fc48f>] __kmalloc_track_caller+0x3f/0x180
2013-03-14T21:56:59.852+01:00 trinity kernel: 38bfbe30:  [<080dec82>] memdup_user+0x32/0x70
2013-03-14T21:56:59.853+01:00 trinity kernel: 38bfbe4c:  [<080dee7e>] strndup_user+0x3e/0x60
2013-03-14T21:56:59.853+01:00 trinity kernel: 38bfbe68:  [<0811b440>] copy_mount_string+0x30/0x50
2013-03-14T21:56:59.853+01:00 trinity kernel: 38bfbe7c:  [<0811be0a>] sys_mount+0x1a/0xe0
2013-03-14T21:56:59.853+01:00 trinity kernel: 38bfbeac:  [<08062a92>] handle_syscall+0x82/0xb0
2013-03-14T21:56:59.853+01:00 trinity kernel: 38bfbef4:  [<08074e7d>] userspace+0x46d/0x590
2013-03-14T21:56:59.853+01:00 trinity kernel: 38bfbfec:  [<0805f7cc>] fork_handler+0x6c/0x70
2013-03-14T21:56:59.853+01:00 trinity kernel: 38bfbffc:  [<5a5a5a5a>] 0x5a5a5a5a
2013-03-14T21:56:59.853+01:00 trinity kernel:
2013-03-14T21:56:59.853+01:00 trinity kernel: ---[ end trace 5bf182a223bd623c ]---
2013-03-14T21:56:59.853+01:00 trinity kernel: memdup_user: -14
2013-03-14T21:56:59.942+01:00 trinity kernel: VFS: Warning: trinity-child0 using old stat() call. Recompile your binary.
2013-03-14T21:56:59.942+01:00 trinity kernel: VFS: Warning: trinity-child0 using old stat() call. Recompile your binary.
2013-03-14T21:56:59.942+01:00 trinity kernel: VFS: Warning: trinity-child0 using old stat() call. Recompile your binary.
2013-03-14T21:57:01.000+01:00 trinity sshd[1160]: Received disconnect from 192.168.0.254: 11: disconnected by user
2013-03-14T21:57:01.000+01:00 trinity sshd[1158]: pam_unix(sshd:session): session closed for user tfoerste
2013-03-14T21:57:09.087+01:00 trinity kernel: memdup_user: -14
2013-03-14T21:57:18.191+01:00 trinity kernel: memdup_user: 4089
2013-03-14T21:57:26.236+01:00 trinity kernel: memdup_user: 28




-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
