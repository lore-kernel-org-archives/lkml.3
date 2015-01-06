Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbbAFIFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 03:05:03 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:35646 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbbAFIFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 03:05:01 -0500
MIME-Version: 1.0
Date: Tue, 6 Jan 2015 16:05:01 +0800
Message-ID: <CADkvYHE9qhgwaN3KFXwHp+STCM6XuxE-zti_hXj9QTSgmAJMPQ@mail.gmail.com>
Subject: ZRAM: scheduling while atomic 3.10.62
From: Yingchun Li <sword.l.dragon@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I encountered a BUG when use zram on my board, following is the message:

[  120.351196] BUG: scheduling while atomic: Binder_3/230/0x00000003
[  120.351806] Modules linked in: rdawfmac rda_cam_sensor(O) rda_ls(O)
rda_gs(O) rda_ts(O) voc(O) vpu(O) galcore(O) rda_headset(O)
[  120.353210] CPU: 0 PID: 230 Comm: Binder_3 Tainted: G        W  O
3.10.62-01224-gcfffb36 #1
[  120.354248] [<c001047d>] (unwind_backtrace+0x1/0x98) from
[<c000ee93>] (show_stack+0xb/0xc)
[  120.355285] [<c000ee93>] (show_stack+0xb/0xc) from [<c036c275>]
(__schedule_bug+0x31/0x48)
[  120.356323] [<c036c275>] (__schedule_bug+0x31/0x48) from
[<c036f9c9>] (__schedule+0x275/0x2c8)
[  120.357360] [<c036f9c9>] (__schedule+0x275/0x2c8) from [<c037044d>]
(__down_write_nested+0x51/0xa4)
[  120.358459] [<c037044d>] (__down_write_nested+0x51/0xa4) from
[<c025ed2f>] (zram_slot_free_notify+0x13/0x2c)
[  120.359680] [<c025ed2f>] (zram_slot_free_notify+0x13/0x2c) from
[<c007a06d>] (swap_entry_free+0xd9/0x124)
[  120.360900] [<c007a06d>] (swap_entry_free+0xd9/0x124) from
[<c007ac5f>] (free_swap_and_cache+0x1f/0xc8)
[  120.362060] [<c007ac5f>] (free_swap_and_cache+0x1f/0xc8) from
[<c006ebe9>] (unmap_single_vma+0x1fd/0x45c)
[  120.363220] [<c006ebe9>] (unmap_single_vma+0x1fd/0x45c) from
[<c006f4e3>] (unmap_vmas+0x33/0x40)
[  120.364318] [<c006f4e3>] (unmap_vmas+0x33/0x40) from [<c00716c7>]
(unmap_region+0x73/0xfc)
[  120.365356] [<c00716c7>] (unmap_region+0x73/0xfc) from [<c00728e7>]
(do_munmap+0x177/0x244)
[  120.366394] [<c00728e7>] (do_munmap+0x177/0x244) from [<c00729df>]
(vm_munmap+0x2b/0x38)
[  120.367370] [<c00729df>] (vm_munmap+0x2b/0x38) from [<c000cc41>]
(ret_fast_syscall+0x1/0x46)

And I notice there is a similar post here:

https://lkml.org/lkml/2013/8/17/27

And it has been fixed by mainline(by Commit a0c516cbfc74),and there is some
other patches to optimize the patch(Commit f614a9f48ded).

I just want to know is there any plan to back port the patchs to 3.10.y?
