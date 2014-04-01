Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaDAMrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:47:13 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:62998 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaDAMrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:47:11 -0400
MIME-Version: 1.0
Date: Tue, 1 Apr 2014 09:47:09 -0300
Message-ID: <CAGG-pURwpGGFyCp-htffegnVhf1VwAke1XPrC+GirXKy-HhqJA@mail.gmail.com>
Subject: [RFC] Only a.out QMAGIC format is working
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "open list:FILESYSTEMS (VFS...), linux-kernel@vger.kernel.org (open
	list)" <linux-fsdevel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>,
        kernelnewbies <Kernelnewbies@kernelnewbies.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sirs,

I was researching about old binary formats and did some tests.
Meantime, I was able to run sucessfully only the QMAGIC format.
Nonetheless, the OMAGIC, NMAGIC and ZMAGIC didn't work anymore.

The test occurred using old slackware binaries and some new, the
latter compiled by me, using cross-compiled as and ld. In any case,
the QMAGIC was the only functional.

After some debugging I identified (when loading a OMAGIC) that the
kernel sigkill the current after this checking:

http://lxr.linux.no/linux+v3.13.5/arch/x86/ia32/ia32_aout.c#L325

 325                error = vm_brk(text_addr & PAGE_MASK, map_size);
 326
 327                if (error != (text_addr & PAGE_MASK)) {
 328                        send_sig(SIGKILL, current, 0);
 329                        return error;
 330                }

I suppose this happens due to changes made, in the course of time, in
the memory mapping (vm_brk/do_brk), therefore the only one that still
works is the QMAGIC (the aligned one). Or maybe, it's purposely. [RFC]

Is important to note that when a ZMAGIC is loaded what happens is a
"Segmentation fault" and not "SIGKILL".

That was reported by others too:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/966472

-- 
Regards,

Geyslan G. Bem
hackingbits.com
