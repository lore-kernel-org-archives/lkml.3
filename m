Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaFMAOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 20:14:35 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:65185 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaFMAOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 20:14:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140611135413.ecd77d52dcf1d4fd6671ac8c@linux-foundation.org>
References: <CAD=FV=VX6QqL+jdEwk8Mp53FHBqj2v=w65zqBcbYWTtPZPmMVQ@mail.gmail.com>
	<20140611135413.ecd77d52dcf1d4fd6671ac8c@linux-foundation.org>
Date: Thu, 12 Jun 2014 17:14:32 -0700
X-Google-Sender-Auth: O5YfxrBig-W22CLrk69nOtygKo8
Message-ID: <CAL1qeaEemmb6sh8BgH=iqPDQh7-HrKACDBdvnMBxS9tprK-e_Q@mail.gmail.com>
Subject: Re: CONFIG_PREMPT vs. linux-next causes slub_debug=FZPUA errors
From: Andrew Bresticker <abrestic@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Kevin Hilman <khilman@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you have more examples?  I couldn't locate a report from Andrew.

Here's a dump I've gotten with next-20140610 on a Jetson TK1 board:

[   10.488994] =============================================================================
[   10.497177] BUG bio-1 (Not tainted): Poison overwritten
[   10.502403] -----------------------------------------------------------------------------
[   10.502403]
[   10.512052] Disabling lock debugging due to kernel taint
[   10.517368] INFO: 0xe9b1b078-0xe9b1b07f. First byte 0x20 instead of 0x6b
[   10.524079] INFO: Allocated in mempool_alloc+0x54/0x168 age=4 cpu=0 pid=876
[   10.531050] INFO: Freed in mempool_free+0x34/0x90 age=5 cpu=1 pid=176
[   10.537483] INFO: Slab 0xead0d300 objects=21 used=21 fp=0x  (null)
flags=0x4080
[   10.544788] INFO: Object 0xe9b1b000 @offset=12288 fp=0xe9b19500
[   10.544788]
[   10.552188] Bytes b4 e9b1aff0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[   10.560974] Object e9b1b000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.569575] Object e9b1b010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.578183] Object e9b1b020: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.586792] Object e9b1b030: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.595401] Object e9b1b040: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.604011] Object e9b1b050: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.612620] Object e9b1b060: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.621230] Object e9b1b070: 6b 6b 6b 6b 6b 6b 6b 6b 20 30 01 00 00
00 00 00  kkkkkkkk 0......
[   10.629829] Object e9b1b080: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.638437] Object e9b1b090: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.647046] Object e9b1b0a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.655656] Object e9b1b0b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.664265] Object e9b1b0c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.672875] Object e9b1b0d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.681485] Object e9b1b0e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.690086] Object e9b1b0f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.698687] Object e9b1b100: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.707295] Object e9b1b110: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.715904] Object e9b1b120: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.724515] Object e9b1b130: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.733126] Object e9b1b140: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.741736] Object e9b1b150: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.750349] Object e9b1b160: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.758947] Object e9b1b170: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.767554] Object e9b1b180: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.776164] Object e9b1b190: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.784775] Object e9b1b1a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.793384] Object e9b1b1b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.801995] Object e9b1b1c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.810604] Object e9b1b1d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.819203] Object e9b1b1e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.827810] Object e9b1b1f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.836420] Object e9b1b200: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.845029] Object e9b1b210: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.853639] Object e9b1b220: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.862249] Object e9b1b230: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.870858] Object e9b1b240: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.879457] Object e9b1b250: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.888064] Object e9b1b260: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.896674] Object e9b1b270: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.905284] Object e9b1b280: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b  kkkkkkkkkkkkkkkk
[   10.913892] Object e9b1b290: 6b 6b 6b 6b 6b 6b 6b a5
          kkkkkkk.
[   10.921810] Redzone e9b1b298: bb bb bb bb
           ....
[   10.929456] Padding e9b1b2c0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[   10.938151] Padding e9b1b2d0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[   10.946848] Padding e9b1b2e0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[   10.955545] Padding e9b1b2f0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[   10.964244] CPU: 2 PID: 204 Comm: jbd2/dm-0-8 Tainted: G    B
  3.15.0-next-20140610-00010-gd4a46d4 #194
[   10.974260] [<c0016240>] (unwind_backtrace) from [<c0011b60>]
(show_stack+0x10/0x14)
[   10.982019] [<c0011b60>] (show_stack) from [<c0634c8c>]
(dump_stack+0x84/0xc4)
[   10.989241] [<c0634c8c>] (dump_stack) from [<c00dcb6c>]
(check_bytes_and_report+0xc4/0x100)
[   10.997602] [<c00dcb6c>] (check_bytes_and_report) from [<c00dcd58>]
(check_object+0x1b0/0x23c)
[   11.006225] [<c00dcd58>] (check_object) from [<c00dec30>]
(alloc_debug_processing+0x78/0x160)
[   11.014763] [<c00dec30>] (alloc_debug_processing) from [<c00df3f4>]
(__slab_alloc.isra.66.constprop.73+0x6dc/0x7b0)
[   11.025207] [<c00df3f4>] (__slab_alloc.isra.66.constprop.73) from
[<c00df748>] (kmem_cache_alloc+0x110/0x140)
[   11.035127] [<c00df748>] (kmem_cache_alloc) from [<c00a5ea8>]
(mempool_alloc+0x54/0x168)
[   11.043232] [<c00a5ea8>] (mempool_alloc) from [<c02103d0>]
(bio_alloc_bioset+0x14c/0x1cc)
[   11.051424] [<c02103d0>] (bio_alloc_bioset) from [<c04227dc>]
(__split_and_process_bio+0x1d8/0x400)
[   11.060477] [<c04227dc>] (__split_and_process_bio) from
[<c0422b20>] (dm_request+0x11c/0x1ec)
[   11.068996] [<c0422b20>] (dm_request) from [<c02146f8>]
(generic_make_request+0xa8/0xd4)
[   11.077094] [<c02146f8>] (generic_make_request) from [<c02147a8>]
(submit_bio+0x84/0x140)
[   11.085281] [<c02147a8>] (submit_bio) from [<c010fc90>]
(_submit_bh+0x1a4/0x250)
[   11.092690] [<c010fc90>] (_submit_bh) from [<c01a5c40>]
(jbd2_journal_commit_transaction+0x958/0x15b8)
[   11.102006] [<c01a5c40>] (jbd2_journal_commit_transaction) from
[<c01a9c60>] (kjournald2+0xc4/0x24c)
[   11.111149] [<c01a9c60>] (kjournald2) from [<c0042034>] (kthread+0xd8/0xf0)
[   11.118108] [<c0042034>] (kthread) from [<c000e7f8>]
(ret_from_fork+0x14/0x3c)
