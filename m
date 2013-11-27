Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab3K0CTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:19:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:30578 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905Ab3K0CTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:19:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,779,1378882800"; 
   d="scan'208";a="415668072"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "mszeredi@suse.cz" <mszeredi@suse.cz>
CC: "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: fuse try to freeze with lock held
Thread-Topic: fuse try to freeze with lock held
Thread-Index: Ac7rFxlD+SyxfMpuRICVEra1GU5gRA==
Date: Wed, 27 Nov 2013 02:19:31 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01BB245D@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hit the below warning when enabling the CONFIG_DEBUG_LOCK_ALLOC,
__fuse_request_send == >
request_wait_answer == >
wait_event_freezable == >
try_to_freeze()

But here the inode->i_mutex is hold yet in vfs_readdir().

Could anyone give some help? Thanks.


[ 3148.552435] Freezing user space processes ... [ 3148.557781]
[ 3148.559505] =====================================
[ 3148.564803] [ BUG: du/21716 still has locks held! ]
[ 3148.570319] 3.10.16-261493-g1308ae2 #8 Tainted: G        W  O

[ 3148.586082]  #0:  (&type->i_mutex_dir_key#3){......}, at: [<c1341dc6>] vfs_readdir+0x66/0xd0
[ 3148.595967]
[ 3148.595967] stack backtrace:
[ 3148.600875] CPU: 2 PID: 21716 Comm: du Tainted: G        W  O 3.10.16-261493-g1308ae2 #8
[ 3148.609973]  d7e494e0 d7e494e0 cca6be78 c1b0fccb cca6be90 c12913f1 c1db2cc5 d7e497e4
[ 3148.618872]  000054d4 cca6beac cca6becc c1440d8b d7e494e0 f2557800 f12acedc 00000000
[ 3148.627747]  00000000 00000000 d7e494e0 c125f100 cca6beb8 cca6beb8 f12ace40 f2557800
[ 3148.636614] Call Trace:
[ 3148.639395]  [<c1b0fccb>] dump_stack+0x16/0x18
[ 3148.644375]  [<c12913f1>] debug_check_no_locks_held+0x91/0xa0
[ 3148.650862]  [<c1440d8b>] __fuse_request_send+0x14b/0x320
[ 3148.656961]  [<c125f100>] ? wake_up_bit+0x30/0x30
[ 3148.662242]  [<c1440f71>] fuse_request_send+0x11/0x20
[ 3148.667941]  [<c14455a9>] fuse_readdir+0x109/0x690
[ 3148.673327]  [<c1341dc6>] ? vfs_readdir+0x66/0xd0
[ 3148.678636]  [<c1b1bec5>] ? sub_preempt_count+0x45/0x60
[ 3148.684503]  [<c1b15694>] ? mutex_lock_killable_nested+0x214/0x300
[ 3148.691457]  [<c1341b60>] ? SyS_ioctl+0x90/0x90
[ 3148.696553]  [<c1341dc6>] ? vfs_readdir+0x66/0xd0
[ 3148.701857]  [<c1341b60>] ? SyS_ioctl+0x90/0x90

