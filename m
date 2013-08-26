Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab3HZLYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:24:13 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:47284 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425Ab3HZLYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:24:12 -0400
X-Greylist: delayed 4125 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Aug 2013 07:24:12 EDT
User-Agent: K-9 Mail for Android
In-Reply-To: <521AF818.3070208@t-online.de>
References: <521AF818.3070208@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: dvb_device_open: possible circular locking dependency detected
From: Andy Walls <awalls@md.metrocast.net>
Date: Mon, 26 Aug 2013 06:15:25 -0400
To: Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org
CC: linux-media@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <535ff736-dc4c-4175-8197-0702688031f9@email.android.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-26_02:2013-08-25,2013-08-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1305240000 definitions=main-1308260040
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Knut Petersen <Knut_Petersen@t-online.de> wrote:
>As long as I use the "Hauppauge WinTV Nova-HD-S2", nobody seems to be
>really interested in silencing deadlock warnings triggered by
>dvb_device_open().
>
>dvb lockdep problems are old, see Andy Walls mail written in 2010
><http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/27027>,
>but they still
>exist.
>
>
>[  186.583006] ======================================================
>[  186.583009] [ INFO: possible circular locking dependency detected ]
>[  186.583013] 3.11.0-rc6-main+ #29 Not tainted
>[  186.583016] -------------------------------------------------------
>[  186.583019] kaffeine/1986 is trying to acquire lock:
>[  186.583022]  (&fe->lock){+.+.+.}, at: [<f8c4a0d9>]
>videobuf_dvb_find_frontend+0x1b/0x43 [videobuf_dvb]
>[  186.583036]
>[  186.583036] but task is already holding lock:
>[  186.583039]  (minor_rwsem){++++..}, at: [<f8c340a1>]
>dvb_device_open+0x26/0xfa [dvb_core]
>[  186.583054]
>[  186.583054] which lock already depends on the new lock.
>[  186.583054]
>[  186.583058]
>[  186.583058] the existing dependency chain (in reverse order) is:
>[  186.583062]
>[  186.583062] -> #2 (minor_rwsem){++++..}:
>[  186.583068]        [<c01682d4>] lock_acquire+0x9b/0xd5
>[  186.583077]        [<c0532cea>] down_write+0x20/0x3c
>[  186.583084]        [<f8c343f8>] dvb_register_device+0x158/0x20a
>[dvb_core]
>[  186.583093]        [<f8c3a28a>] dvb_register_frontend+0x15b/0x18d
>[dvb_core]
>[  186.583104]        [<f8c4a297>] videobuf_dvb_register_bus+0xd1/0x2c7
>[videobuf_dvb]
>[  186.583110]        [<f8c51eb1>] cx8802_dvb_probe+0x201b/0x2136
>[cx88_dvb]
>[  186.583118]        [<f851787b>] cx8802_register_driver+0x121/0x1f7
>[cx8802]
>[  186.583129]        [<f8c5f01c>] 0xf8c5f01c
>[  186.583135]        [<c01003b5>] do_one_initcall+0x6f/0xea
>[  186.583140]        [<c0170443>] load_module+0x168a/0x1985
>[  186.583146]        [<c01707b7>] SyS_init_module+0x79/0x91
>[  186.583151]        [<c0535045>] syscall_call+0x7/0xb
>[  186.583156]
>[  186.583156] -> #1 (dvbdev_register_lock){+.+.+.}:
>[  186.583162]        [<c01682d4>] lock_acquire+0x9b/0xd5
>[  186.583167]        [<c05326a1>] mutex_lock_nested+0x3a/0x298
>[  186.583172]        [<f8c342c2>] dvb_register_device+0x22/0x20a
>[dvb_core]
>[  186.583181]        [<f8c34968>] dvb_dmxdev_init+0xbb/0xf7 [dvb_core]
>[  186.583189]        [<f8c4a33f>]
>videobuf_dvb_register_bus+0x179/0x2c7 [videobuf_dvb]
>[  186.583195]        [<f8c51eb1>] cx8802_dvb_probe+0x201b/0x2136
>[cx88_dvb]
>[  186.583202]        [<f851787b>] cx8802_register_driver+0x121/0x1f7
>[cx8802]
>[  186.583208]        [<f8c5f01c>] 0xf8c5f01c
>[  186.583212]        [<c01003b5>] do_one_initcall+0x6f/0xea
>[  186.583217]        [<c0170443>] load_module+0x168a/0x1985
>[  186.583221]        [<c01707b7>] SyS_init_module+0x79/0x91
>[  186.583226]        [<c0535045>] syscall_call+0x7/0xb
>[  186.583231]
>[  186.583231] -> #0 (&fe->lock){+.+.+.}:
>[  186.583237]        [<c01677cd>] __lock_acquire+0xebd/0x154c
>[  186.583242]        [<c01682d4>] lock_acquire+0x9b/0xd5
>[  186.583246]        [<c05326a1>] mutex_lock_nested+0x3a/0x298
>[  186.583251]        [<f8c4a0d9>] videobuf_dvb_find_frontend+0x1b/0x43
>[videobuf_dvb]
>[  186.583257]        [<f8c4fcef>] cx88_dvb_bus_ctrl+0x25/0x9d
>[cx88_dvb]
>[  186.583263]        [<f8c39e63>] dvb_frontend_open+0x12f/0x2ca
>[dvb_core]
>[  186.583273]        [<f8c34103>] dvb_device_open+0x88/0xfa [dvb_core]
>[  186.583281]        [<c01db1ab>] chrdev_open+0xfc/0x11c
>[  186.583287]        [<c01d6332>] do_dentry_open+0x169/0x203
>[  186.583293]        [<c01d656f>] finish_open+0x2c/0x37
>[  186.583297]        [<c01e2b45>] do_last+0x818/0xa03
>[  186.583303]        [<c01e2f35>] path_openat+0x205/0x4d2
>[  186.583308]        [<c01e343d>] do_filp_open+0x2a/0x63
>[  186.583312]        [<c01d749e>] do_sys_open+0x140/0x1bb
>[  186.583317]        [<c01d7536>] SyS_open+0x1d/0x1f
>[  186.583322]        [<c0535045>] syscall_call+0x7/0xb
>[  186.583327]
>[  186.583327] other info that might help us debug this:
>[  186.583327]
>[  186.583331] Chain exists of:
>[  186.583331]   &fe->lock --> dvbdev_register_lock --> minor_rwsem
>[  186.583331]
>[  186.583340]  Possible unsafe locking scenario:
>[  186.583340]
>[  186.583343]        CPU0                    CPU1
>[  186.583346]        ----                    ----
>[  186.583348]   lock(minor_rwsem);
>[  186.583352] lock(dvbdev_register_lock);
>[  186.583357]                                lock(minor_rwsem);
>[  186.583361]   lock(&fe->lock);
>[  186.583365]
>[  186.583365]  *** DEADLOCK ***
>[  186.583365]
>[  186.583369] 2 locks held by kaffeine/1986:
>[  186.583372]  #0:  (dvbdev_mutex){+.+...}, at: [<f8c34097>]
>dvb_device_open+0x1c/0xfa [dvb_core]
>[  186.583385]  #1:  (minor_rwsem){++++..}, at: [<f8c340a1>]
>dvb_device_open+0x26/0xfa [dvb_core]
>[  186.583398]
>[  186.583398] stack backtrace:
>[  186.583403] CPU: 0 PID: 1986 Comm: kaffeine Not tainted
>3.11.0-rc6-main+ #29
>[  186.583406] Hardware name:    /i915GMm-HFS, BIOS 6.00 PG 09/14/2005
>[  186.583410]  00000000 c0a3600c f0d79c5c c052f17a f0d79c8c c052d253
>c06b1687 c06b1553
>[  186.583421]  c06b151b c06b153c c06b151b f0d79cd4 f0ed64e0 00000002
>f0ed695c f0ed6974
>[  186.583432]  f0d79d04 c01677cd f0ed695c 00000002 00000002 00000000
>ffffe000 f0d79ffc
>[  186.583443] Call Trace:
>[  186.583450]  [<c052f17a>] dump_stack+0x16/0x18
>[  186.583456]  [<c052d253>] print_circular_bug+0x233/0x240
>[  186.583462]  [<c01677cd>] __lock_acquire+0xebd/0x154c
>[  186.583469]  [<c01682d4>] lock_acquire+0x9b/0xd5
>[  186.583476]  [<f8c4a0d9>] ? videobuf_dvb_find_frontend+0x1b/0x43
>[videobuf_dvb]
>[  186.583483]  [<f8c4a0d9>] ? videobuf_dvb_find_frontend+0x1b/0x43
>[videobuf_dvb]
>[  186.583489]  [<c05326a1>] mutex_lock_nested+0x3a/0x298
>[  186.583496]  [<f8c4a0d9>] ? videobuf_dvb_find_frontend+0x1b/0x43
>[videobuf_dvb]
>[  186.583503]  [<f8c4a0d9>] videobuf_dvb_find_frontend+0x1b/0x43
>[videobuf_dvb]
>[  186.583511]  [<f8c4fcef>] cx88_dvb_bus_ctrl+0x25/0x9d [cx88_dvb]
>[  186.583522]  [<f8c39e63>] dvb_frontend_open+0x12f/0x2ca [dvb_core]
>[  186.583532]  [<f8c340e0>] ? dvb_device_open+0x65/0xfa [dvb_core]
>[  186.583542]  [<f8c34103>] dvb_device_open+0x88/0xfa [dvb_core]
>[  186.583548]  [<c01db1ab>] chrdev_open+0xfc/0x11c
>[  186.583554]  [<c01d6332>] do_dentry_open+0x169/0x203
>[  186.583559]  [<c01db0af>] ? cdev_put+0x1f/0x1f
>[  186.583564]  [<c01d656f>] finish_open+0x2c/0x37
>[  186.583569]  [<c01e2b45>] do_last+0x818/0xa03
>[  186.583575]  [<c01e00ff>] ? inode_permission+0x44/0x47
>[  186.583580]  [<c01e015c>] ? link_path_walk+0x5a/0x690
>[  186.583586]  [<c01e2f35>] path_openat+0x205/0x4d2
>[  186.583592]  [<c0168a78>] ? trace_hardirqs_on+0xb/0xd
>[  186.583598]  [<c01e343d>] do_filp_open+0x2a/0x63
>[  186.583606]  [<c01ecd6f>] ? __alloc_fd+0xbf/0xc9
>[  186.583612]  [<c01d749e>] do_sys_open+0x140/0x1bb
>[  186.583617]  [<c01d8e9d>] ? __fput+0x1af/0x1c8
>[  186.583623]  [<c0530000>] ? decode_winbond+0x60/0x159
>[  186.583629]  [<c01d7536>] SyS_open+0x1d/0x1f
>[  186.583634]  [<c0535045>] syscall_call+0x7/0xb
>[  186.583640]  [<c0530000>] ? decode_winbond+0x60/0x159
>[  187.238501] cx24116_firmware_ondemand: Waiting for firmware upload
>(dvb-fe-cx24116.fw)...
>[  187.241340] cx24116_firmware_ondemand: Waiting for firmware
>upload(2)...
>[  192.841700] cx24116_load_firmware: FW version 1.26.90.0
>[  192.841717] cx24116_firmware_ondemand: Firmware upload complete
>
>
>cu,
>  Knut

Hi Knut,

The v4l2 control handler lock false alarms, described in my old email, are fixed in 3.10 IIRC.

The dvb lock problem you have is unrelated to the v4l2 lock problem.

Regards,
Andy
