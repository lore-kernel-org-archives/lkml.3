Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab3KXPOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 10:14:43 -0500
Received: from mout.gmx.net ([212.227.15.19]:58207 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489Ab3KXPOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 10:14:25 -0500
Message-ID: <529217CD.1000204@gmx.de>
Date: Sun, 24 Nov 2013 16:14:21 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: UML devel <user-mode-linux-devel@lists.sourceforge.net>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: why does index in truncate_inode_pages_range() grows so much ?
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:Qdw7haRx6w/yIZ26CH0SbtZurbgx22B+XoiwEvNUIamyylZDm3f
 BHsi6ivH++eWhehAsPaxA2hz4bWxbbNYpYcHEmzPcWTx9xnzKeg8a4tEWiQ4tjqOdu9IYDB
 LvZEivncEZtBae1r8tbcEPOtBys1IoiuVw7MzEY/8A2YLh1O2JVCUd/+Gn+UqI6IxdT5l8K
 sFx1uGDnUBCfeInCaYQPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At a 32 bit guest UML with current kernel git tree I putted a printk
into that function :

void truncate_inode_pages_range(struct address_space *mapping,
                                loff_t lstart, loff_t lend)
{
...


                cond_resched();
                index++;
		printk ("            <------------




and got (while fuzzying the UML guest with trinity) this output in the
UML guest:


Nov 24 12:06:53 trinity kernel: index:42 end:4294967295
Nov 24 12:06:53 trinity kernel: index:43 end:4294967295
Nov 24 12:06:53 trinity kernel: index:5 end:4294967295
Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
Nov 24 12:06:53 trinity kernel: index:1035468800 end:4294967295
Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
Nov 24 12:06:53 trinity kernel: index:16 end:4294967295
Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
Nov 24 12:06:53 trinity kernel: index:4 end:4294967295
Nov 24 12:06:53 trinity kernel: index:2 end:4294967295
Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
Nov 24 12:06:53 trinity kernel: index:4184867847 end:4294967295
Nov 24 12:06:53 trinity kernel: index:1 end:4294967295
Nov 24 12:06:53 trinity kernel: index:3 end:4294967295
Nov 24 12:06:53 trinity kernel: index:1727 end:4294967295
Nov 24 12:06:53 trinity kernel: index:1 end:4294967295


I'm wondering if index is expected to become sometimes so big.

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
