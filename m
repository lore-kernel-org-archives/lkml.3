Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763621Ab3DDREp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:04:45 -0400
Received: from mout.gmx.net ([212.227.17.22]:51956 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763473Ab3DDREn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:04:43 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19+TUx0p9h+OdjaAkGELHFYacivqghvHsBSVBcQqb
	YFybORVlg1Wm5P
Message-ID: <515DB2A6.7020902@gmx.de>
Date: Thu, 04 Apr 2013 19:04:38 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130309 Thunderbird/17.0.4
MIME-Version: 1.0
To: user-mode-linux-user@lists.sourceforge.net
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: user mode linux: trinity syscall "madvise" triggers quickly BUG:
 Bad page map
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if SLUB is used (SLAB works fine till now with this syscall).

What I get with the this trinity command line

$> trinity --children 2 -c madvise

for a 32 bit Gentoo Linux (both as host and as guest) 
and host kernel 3.8.5 and guest kernel 3.9-rc5 is the following :


2013-04-04T19:00:29.220+02:00 trinity kernel: BUG: Bad page map in process trinity-child1  pte:0032d045 pmd:3932e1e1
2013-04-04T19:00:29.220+02:00 trinity kernel: page:0a73f5a0 count:1 mapcount:-1 mapping:  (null) index:0x0
2013-04-04T19:00:29.220+02:00 trinity kernel: page flags: 0x404(referenced|reserved)
2013-04-04T19:00:29.220+02:00 trinity kernel: addr:00100000 vm_flags:00040055 anon_vma:  (null) mapping:  (null) index:100
2013-04-04T19:00:29.220+02:00 trinity kernel: vma->vm_ops->fault: special_mapping_fault+0x0/0x80
2013-04-04T19:00:29.220+02:00 trinity kernel: 413c7d20:  [<0836efd8>] dump_stack+0x22/0x24
2013-04-04T19:00:29.220+02:00 trinity kernel: 413c7d38:  [<0837039b>] print_bad_pte+0x17b/0x197
2013-04-04T19:00:29.220+02:00 trinity kernel: 413c7d7c:  [<080e2c68>] unmap_single_vma+0x268/0x430
2013-04-04T19:00:29.220+02:00 trinity kernel: 413c7ddc:  [<080e33f4>] zap_page_range+0x74/0xb0
2013-04-04T19:00:29.220+02:00 trinity kernel: 413c7e10:  [<080e172d>] sys_madvise+0x3bd/0x720
2013-04-04T19:00:29.225+02:00 trinity kernel: 413c7eac:  [<08064a92>] handle_syscall+0x82/0xb0
2013-04-04T19:00:29.225+02:00 trinity kernel: 413c7ef4:  [<08076f0d>] userspace+0x46d/0x590
2013-04-04T19:00:29.225+02:00 trinity kernel: 413c7fec:  [<080617cc>] fork_handler+0x6c/0x70
2013-04-04T19:00:29.225+02:00 trinity kernel: 413c7ffc:  [<00000002>] 0x2
2013-04-04T19:00:29.225+02:00 trinity kernel:
2013-04-04T19:00:29.225+02:00 trinity kernel: Disabling lock debugging due to kernel taint
2013-04-04T19:00:29.225+02:00 trinity kernel: BUG: Bad page state in process trinity-child1  pfn:0032d
2013-04-04T19:00:29.225+02:00 trinity kernel: page:0a73f5a0 count:0 mapcount:-1 mapping:  (null) index:0x0
2013-04-04T19:00:29.225+02:00 trinity kernel: page flags: 0x404(referenced|reserved)
2013-04-04T19:00:29.225+02:00 trinity kernel: 413c7cd8:  [<0836efd8>] dump_stack+0x22/0x24
2013-04-04T19:00:29.230+02:00 trinity kernel: 413c7cf0:  [<080cf185>] bad_page+0xb5/0xe0
2013-04-04T19:00:29.230+02:00 trinity kernel: 413c7d0c:  [<080cf223>] free_pages_prepare+0x73/0xb0
2013-04-04T19:00:29.230+02:00 trinity kernel: 413c7d28:  [<080d064d>] free_hot_cold_page+0x1d/0x100
2013-04-04T19:00:29.230+02:00 trinity kernel: 413c7d50:  [<080d2fde>] __put_single_page+0x1e/0x30
2013-04-04T19:00:29.230+02:00 trinity kernel: 413c7d64:  [<080d3107>] put_page+0x27/0x30
2013-04-04T19:00:29.230+02:00 trinity kernel: 413c7d6c:  [<080f026c>] free_page_and_swap_cache+0x3c/0x50
2013-04-04T19:00:29.230+02:00 trinity kernel: 413c7d7c:  [<080e2c85>] unmap_single_vma+0x285/0x430
2013-04-04T19:00:29.230+02:00 trinity kernel: 413c7ddc:  [<080e33f4>] zap_page_range+0x74/0xb0
2013-04-04T19:00:29.230+02:00 trinity kernel: 413c7e10:  [<080e172d>] sys_madvise+0x3bd/0x720
2013-04-04T19:00:29.230+02:00 trinity kernel: 413c7eac:  [<08064a92>] handle_syscall+0x82/0xb0
2013-04-04T19:00:29.234+02:00 trinity kernel: 413c7ef4:  [<08076f0d>] userspace+0x46d/0x590
2013-04-04T19:00:29.234+02:00 trinity kernel: 413c7fec:  [<080617cc>] fork_handler+0x6c/0x70
2013-04-04T19:00:29.234+02:00 trinity kernel: 413c7ffc:  [<00000002>] 0x2
2013-04-04T19:00:29.234+02:00 trinity kernel:
2013-04-04T19:00:30.174+02:00 trinity kernel: BUG: Bad rss-counter state mm:40623600 idx:0 val:-1

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
