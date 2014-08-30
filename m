Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaH3W1M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 18:27:12 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:34596 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbaH3W1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 18:27:10 -0400
Date: Sun, 31 Aug 2014 01:27:01 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        hughd@google.com, cat.schulze@alice-dsl.net
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
Message-ID: <20140830222701.GA30338@drone.musicnaut.iki.fi>
References: <alpine.SOC.1.00.1408151534480.27263@math.ut.ee>
 <alpine.SOC.1.00.1408181528270.2922@math.ut.ee>
 <20140818173552.GA2126@drone.musicnaut.iki.fi>
 <20140818.103850.2072106996313096989.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818.103850.2072106996313096989.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 18, 2014 at 10:38:50AM -0700, David Miller wrote:
> All patches are in 3,17-rc1

FYI, the warning/bug still triggers with 3.17-rc2 during GCC bootstrap:

[94075.963753] ------------[ cut here ]------------
[94076.018105] WARNING: CPU: 0 PID: 17192 at /home/aaro/los/work/shared/linux-v3.17-rc2/mm/mmap.c:2766 exit_mmap+0x128/0x160()
[94076.151407] Modules linked in:
[94076.187825] CPU: 0 PID: 17192 Comm: rm Not tainted 3.17.0-rc2-ultra-los_3ec1 #1
[94076.275319] Call Trace:
[94076.304490]  [00000000004c1308] exit_mmap+0x128/0x160
[94076.364915]  [000000000045118c] mmput+0x2c/0xc0
[94076.419062]  [0000000000453cb0] do_exit+0x1b0/0x880
[94076.477387]  [0000000000454ff8] do_group_exit+0x38/0xc0
[94076.539880]  [0000000000455094] SyS_exit_group+0x14/0x20
[94076.603429]  [0000000000406074] linux_sparc_syscall32+0x34/0x60
[94076.674225] ---[ end trace b4b3ce0b3bcc0234 ]---
[94076.729446] BUG: Bad rss-counter state mm:ffffff0016898000 idx:1 val:2

A.
