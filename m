Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaJTGN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 02:13:29 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35051 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbaJTGN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 02:13:26 -0400
Message-ID: <5444A802.9030504@gmail.com>
Date: Mon, 20 Oct 2014 08:13:22 +0200
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>
CC: Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Subject: INFO: task echo:622 blocked for more than 120 seconds. - 3.18.0-0.rc0.git
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


02:00.0 VGA compatible controller: 
NVIDIA Corporation G98 [GeForce 8400 GS Rev. 2] (rev a1)
Chipset: G98 (NV98)
Family : NV50

The same for all four kernel:
- 3.18.0-0.rc0.git8.1.fc22.x86_64
- 3.18.0-0.rc0.git9.1.fc22.x86_64
- 3.18.0-0.rc0.git9.3.fc22.x86_64
- 3.18.0-0.rc0.git9.4.fc22.x86_64
after
"fb: switching to nouveaufb from VESA VGA"
display is powered off.
The magic SysRq key sequence is necessary to reboot.

Yet reached this this one recital:
...
[    5.860996] [drm] Initialized nouveau 1.2.1 20120801 for 0000:02:00.0 on minor 0
...
[  240.229058] INFO: task echo:622 blocked for more than 120 seconds.
[  240.229594]       Not tainted 3.18.0-0.rc0.git9.3.fc22.x86_64 #1
[  240.230149] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.230661] echo            D ffff8800c82a3480 12472   622      1 0x00000004
[  240.231230]  ffff8800ca2e3ac8 0000000000000096 ffff8800c82a3480 00000000001d5f00
[  240.231784]  ffff8800ca2e3fd8 00000000001d5f00 ffff880128bf0000 ffff8800c82a3480
[  240.232344]  ffffffff82c30990 7fffffffffffffff ffffffff81ee2698 ffffffff81ee2690
[  240.232931] Call Trace:
[  240.233467]  [<ffffffff8185baf9>] schedule+0x29/0x70
[  240.234025]  [<ffffffff81860d1c>] schedule_timeout+0x26c/0x410
[  240.234562]  [<ffffffff81028c4a>] ? native_sched_clock+0x2a/0xa0
[  240.235118]  [<ffffffff811078bc>] ? mark_held_locks+0x7c/0xb0
[  240.235645]  [<ffffffff81861da0>] ? _raw_spin_unlock_irq+0x30/0x50
[  240.236198]  [<ffffffff81107a4d>] ? trace_hardirqs_on_caller+0x15d/0x200
[  240.236729]  [<ffffffff8185d52c>] wait_for_completion+0x10c/0x150
[  240.237290]  [<ffffffff810e51f0>] ? wake_up_state+0x20/0x20
[  240.237842]  [<ffffffff8112a559>] _rcu_barrier+0x159/0x200
[  240.238375]  [<ffffffff8112a655>] rcu_barrier+0x15/0x20
[  240.238913]  [<ffffffff8171813f>] netdev_run_todo+0x6f/0x310
[  240.239449]  [<ffffffff817251ae>] rtnl_unlock+0xe/0x10
[  240.239999]  [<ffffffff8170ea35>] unregister_netdev+0x25/0x30
[  240.240546]  [<ffffffffa00222d2>] rtl_remove_one+0x62/0x230 [r8169]
[  240.241104]  [<ffffffff814682cf>] pci_device_remove+0x3f/0xc0
[  240.241642]  [<ffffffff8155b34f>] __device_release_driver+0x7f/0xf0
[  240.242180]  [<ffffffff8155b3e5>] device_release_driver+0x25/0x40
[  240.242712]  [<ffffffff8146234c>] pci_stop_bus_device+0x9c/0xb0
[  240.243259]  [<ffffffff8146248e>] pci_stop_and_remove_bus_device_locked+0x1e/0x40
[  240.243785]  [<ffffffff8146b44c>] remove_store+0x7c/0x90
[  240.244321]  [<ffffffff81555f98>] dev_attr_store+0x18/0x30
[  240.244858]  [<ffffffff81302789>] sysfs_kf_write+0x49/0x60
[  240.245375]  [<ffffffff81301ac9>] kernfs_fop_write+0xf9/0x180
[  240.245921]  [<ffffffff8127305a>] vfs_write+0xba/0x200
[  240.246439]  [<ffffffff8186379c>] ? retint_swapgs+0x13/0x1b
[  240.246978]  [<ffffffff81273bac>] SyS_write+0x5c/0xd0
[  240.247491]  [<ffffffff81862b69>] system_call_fastpath+0x12/0x17
[  240.248025] 6 locks held by echo/622:
[  240.248532]  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff81273143>] vfs_write+0x1a3/0x200
[  240.249104]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff81301a97>] kernfs_fop_write+0xc7/0x180
[  240.249651]  #2:  (s_active#131){++++++}, at: [<ffffffff81300ce4>] kernfs_remove_self+0xf4/0x170
[  240.250229]  #3:  (pci_rescan_remove_lock){+.+.+.}, at: [<ffffffff8145f167>] pci_lock_rescan_remove+0x17/0x20
[  240.250779]  #4:  (&dev->mutex){......}, at: [<ffffffff8155b3dd>] device_release_driver+0x1d/0x40
[  240.251358]  #5:  (rcu_sched_state.barrier_mutex){+.+...}, at: [<ffffffff8112a435>] _rcu_barrier+0x35/0x200
[  241.303095] systemd[1]: start request repeated too quickly for lightdm.service
[  241.323052] systemd[1]: Unit lightdm.service entered failed state.
[  241.333101] systemd[1]: lightdm.service failed.
[  359.038325] INFO: task kworker/u16:2:81 blocked for more than 120 seconds.
[  359.039475]       Not tainted 3.18.0-0.rc0.git9.3.fc22.x86_64 #1
[  359.040004] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  359.040571] kworker/u16:2   D ffff880128131a40 10896    81      2 0x00000000
[  359.041162] Workqueue: netns cleanup_net
[  359.041701]  ffff8801275bba88 0000000000000096 ffff880128131a40 00000000001d5f00
[  359.042280]  ffff8801275bbfd8 00000000001d5f00 ffff880128bf3480 ffff880128131a40
[  359.042856]  ffff880128131a40 ffffffff81ee25e8 0000000000000246 ffff880128131a40
[  359.043436] Call Trace:
[  359.043975]  [<ffffffff8185c0a1>] schedule_preempt_disabled+0x31/0x80
[  359.044542]  [<ffffffff8185d8f3>] mutex_lock_nested+0x183/0x440
[  359.045108]  [<ffffffff8112a435>] ? _rcu_barrier+0x35/0x200
[  359.045647]  [<ffffffff81028c4a>] ? native_sched_clock+0x2a/0xa0
[  359.046218]  [<ffffffff8112a435>] ? _rcu_barrier+0x35/0x200
[  359.046767]  [<ffffffff8185f914>] ? __mutex_unlock_slowpath+0xc4/0x1c0
[  359.047333]  [<ffffffff8112a435>] _rcu_barrier+0x35/0x200
[  359.047875]  [<ffffffff8112a655>] rcu_barrier+0x15/0x20
[  359.048433]  [<ffffffff8171813f>] netdev_run_todo+0x6f/0x310
[  359.048969]  [<ffffffff8170cd35>] ? rollback_registered_many+0x265/0x2e0
[  359.049528]  [<ffffffff817251ae>] rtnl_unlock+0xe/0x10
[  359.050062]  [<ffffffff8170eb96>] default_device_exit_batch+0x156/0x180
[  359.050624]  [<ffffffff810fd6b0>] ? abort_exclusive_wait+0xb0/0xb0
[  359.051185]  [<ffffffff81706c43>] ops_exit_list.isra.1+0x53/0x60
[  359.051720]  [<ffffffff817077f0>] cleanup_net+0x100/0x1f0
[  359.052271]  [<ffffffff810ccdb8>] process_one_work+0x218/0x850
[  359.052806]  [<ffffffff810ccd1f>] ? process_one_work+0x17f/0x850
[  359.053356]  [<ffffffff810cd4d7>] ? worker_thread+0xe7/0x4a0
[  359.053891]  [<ffffffff810cd45b>] worker_thread+0x6b/0x4a0
[  359.054444]  [<ffffffff810cd3f0>] ? process_one_work+0x850/0x850
[  359.054977]  [<ffffffff810d37ab>] kthread+0x10b/0x130
[  359.055521]  [<ffffffff81028cc9>] ? sched_clock+0x9/0x10
[  359.056054]  [<ffffffff810d36a0>] ? kthread_create_on_node+0x250/0x250
[  359.056600]  [<ffffffff81862abc>] ret_from_fork+0x7c/0xb0
[  359.057145]  [<ffffffff810d36a0>] ? kthread_create_on_node+0x250/0x250
[  359.057668] 4 locks held by kworker/u16:2/81:
[  359.058212]  #0:  ("%s""netns"){.+.+.+}, at: [<ffffffff810ccd1f>] process_one_work+0x17f/0x850
[  359.058784]  #1:  (net_cleanup_work){+.+.+.}, at: [<ffffffff810ccd1f>] process_one_work+0x17f/0x850
[  359.059376]  #2:  (net_mutex){+.+.+.}, at: [<ffffffff8170777c>] cleanup_net+0x8c/0x1f0
[  359.059949]  #3:  (rcu_sched_state.barrier_mutex){+.+...}, at: [<ffffffff8112a435>] _rcu_barrier+0x35/0x200
[  359.060566] INFO: task echo:622 blocked for more than 120 seconds.
[  359.061131]       Not tainted 3.18.0-0.rc0.git9.3.fc22.x86_64 #1
[  359.061666] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  359.062218] echo            D ffff8800c82a3480 12472   622      1 0x00000004
[  359.062783]  ffff8800ca2e3ac8 0000000000000096 ffff8800c82a3480 00000000001d5f00
[  359.063365]  ffff8800ca2e3fd8 00000000001d5f00 ffff880128bf0000 ffff8800c82a3480
[  359.063915]  ffffffff82c30990 7fffffffffffffff ffffffff81ee2698 ffffffff81ee2690
[  359.064499] Call Trace:
[  359.065029]  [<ffffffff8185baf9>] schedule+0x29/0x70
[  359.065590]  [<ffffffff81860d1c>] schedule_timeout+0x26c/0x410
[  359.066141]  [<ffffffff81028c4a>] ? native_sched_clock+0x2a/0xa0
[  359.066664]  [<ffffffff811078bc>] ? mark_held_locks+0x7c/0xb0
[  359.067208]  [<ffffffff81861da0>] ? _raw_spin_unlock_irq+0x30/0x50
[  359.067723]  [<ffffffff81107a4d>] ? trace_hardirqs_on_caller+0x15d/0x200
[  359.068265]  [<ffffffff8185d52c>] wait_for_completion+0x10c/0x150
[  359.068789]  [<ffffffff810e51f0>] ? wake_up_state+0x20/0x20
[  359.069334]  [<ffffffff8112a559>] _rcu_barrier+0x159/0x200
[  359.069846]  [<ffffffff8112a655>] rcu_barrier+0x15/0x20
[  359.070378]  [<ffffffff8171813f>] netdev_run_todo+0x6f/0x310
[  359.070890]  [<ffffffff817251ae>] rtnl_unlock+0xe/0x10
[  359.071417]  [<ffffffff8170ea35>] unregister_netdev+0x25/0x30
[  359.071951]  [<ffffffffa00222d2>] rtl_remove_one+0x62/0x230 [r8169]
[  359.072499]  [<ffffffff814682cf>] pci_device_remove+0x3f/0xc0
[  359.073015]  [<ffffffff8155b34f>] __device_release_driver+0x7f/0xf0
[  359.073557]  [<ffffffff8155b3e5>] device_release_driver+0x25/0x40
[  359.074067]  [<ffffffff8146234c>] pci_stop_bus_device+0x9c/0xb0
[  359.074602]  [<ffffffff8146248e>] pci_stop_and_remove_bus_device_locked+0x1e/0x40
[  359.075141]  [<ffffffff8146b44c>] remove_store+0x7c/0x90
[  359.075658]  [<ffffffff81555f98>] dev_attr_store+0x18/0x30
[  359.076192]  [<ffffffff81302789>] sysfs_kf_write+0x49/0x60
[  359.076710]  [<ffffffff81301ac9>] kernfs_fop_write+0xf9/0x180
[  359.077249]  [<ffffffff8127305a>] vfs_write+0xba/0x200
[  359.077758]  [<ffffffff8186379c>] ? retint_swapgs+0x13/0x1b
[  359.078283]  [<ffffffff81273bac>] SyS_write+0x5c/0xd0
[  359.078796]  [<ffffffff81862b69>] system_call_fastpath+0x12/0x17
[  359.079326] 6 locks held by echo/622:
[  359.079829]  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff81273143>] vfs_write+0x1a3/0x200
[  359.080405]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff81301a97>] kernfs_fop_write+0xc7/0x180
[  359.080957]  #2:  (s_active#131){++++++}, at: [<ffffffff81300ce4>] kernfs_remove_self+0xf4/0x170
[  359.081531]  #3:  (pci_rescan_remove_lock){+.+.+.}, at: [<ffffffff8145f167>] pci_lock_rescan_remove+0x17/0x20
[  359.082133]  #4:  (&dev->mutex){......}, at: [<ffffffff8155b3dd>] device_release_driver+0x1d/0x40
[  359.082699]  #5:  (rcu_sched_state.barrier_mutex){+.+...}, at: [<ffffffff8112a435>] _rcu_barrier+0x35/0x200
[  380.911219] systemd-journald[386]: Received request to flush runtime journal from PID 1
[  383.238185] systemd-journald[386]: Received request to flush runtime journal from PID 1
[  383.559763] systemd[1]: Unit lightdm.service entered failed state.
[  383.569825] systemd[1]: lightdm.service failed.
[  385.570803] systemd[1]: lightdm.service failed.
[  479.091518] INFO: task kworker/u16:2:81 blocked for more than 120 seconds.
[  479.092050]       Not tainted 3.18.0-0.rc0.git9.3.fc22.x86_64 #1
[  479.092608] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  479.093093] kworker/u16:2   D ffff880128131a40 10896    81      2 0x00000000
[  479.093650] Workqueue: netns cleanup_net
[  479.094110]  ffff8801275bba88 0000000000000096 ffff880128131a40 00000000001d5f00
[  479.094594]  ffff8801275bbfd8 00000000001d5f00 ffff880128bf3480 ffff880128131a40
[  479.095040]  ffff880128131a40 ffffffff81ee25e8 0000000000000246 ffff880128131a40
[  479.095485] Call Trace:
[  479.095874]  [<ffffffff8185c0a1>] schedule_preempt_disabled+0x31/0x80
[  479.096246]  [<ffffffff8185d8f3>] mutex_lock_nested+0x183/0x440
[  479.096634]  [<ffffffff8112a435>] ? _rcu_barrier+0x35/0x200
[  479.096986]  [<ffffffff81028c4a>] ? native_sched_clock+0x2a/0xa0
[  479.097367]  [<ffffffff8112a435>] ? _rcu_barrier+0x35/0x200
[  479.097712]  [<ffffffff8185f914>] ? __mutex_unlock_slowpath+0xc4/0x1c0
[  479.098061]  [<ffffffff8112a435>] _rcu_barrier+0x35/0x200
[  479.098425]  [<ffffffff8112a655>] rcu_barrier+0x15/0x20
[  479.098771]  [<ffffffff8171813f>] netdev_run_todo+0x6f/0x310
[  479.099109]  [<ffffffff8170cd35>] ? rollback_registered_many+0x265/0x2e0
[  479.099485]  [<ffffffff817251ae>] rtnl_unlock+0xe/0x10
[  479.099828]  [<ffffffff8170eb96>] default_device_exit_batch+0x156/0x180
[  479.100181]  [<ffffffff810fd6b0>] ? abort_exclusive_wait+0xb0/0xb0
[  479.100572]  [<ffffffff81706c43>] ops_exit_list.isra.1+0x53/0x60
[  479.100935]  [<ffffffff817077f0>] cleanup_net+0x100/0x1f0
[  479.101323]  [<ffffffff810ccdb8>] process_one_work+0x218/0x850
[  479.101689]  [<ffffffff810ccd1f>] ? process_one_work+0x17f/0x850
[  479.102039]  [<ffffffff810cd4d7>] ? worker_thread+0xe7/0x4a0
[  479.102420]  [<ffffffff810cd45b>] worker_thread+0x6b/0x4a0
[  479.102773]  [<ffffffff810cd3f0>] ? process_one_work+0x850/0x850
[  479.103138]  [<ffffffff810d37ab>] kthread+0x10b/0x130
[  479.103529]  [<ffffffff81028cc9>] ? sched_clock+0x9/0x10
[  479.103912]  [<ffffffff810d36a0>] ? kthread_create_on_node+0x250/0x250
[  479.104315]  [<ffffffff81862abc>] ret_from_fork+0x7c/0xb0
[  479.104714]  [<ffffffff810d36a0>] ? kthread_create_on_node+0x250/0x250
[  479.105111] 4 locks held by kworker/u16:2/81:
[  479.105543]  #0:  ("%s""netns"){.+.+.+}, at: [<ffffffff810ccd1f>] process_one_work+0x17f/0x850
[  479.105997]  #1:  (net_cleanup_work){+.+.+.}, at: [<ffffffff810ccd1f>] process_one_work+0x17f/0x850
[  479.106485]  #2:  (net_mutex){+.+.+.}, at: [<ffffffff8170777c>] cleanup_net+0x8c/0x1f0
[  479.106966]  #3:  (rcu_sched_state.barrier_mutex){+.+...}, at: [<ffffffff8112a435>] _rcu_barrier+0x35/0x200
[  479.107496] INFO: task echo:622 blocked for more than 120 seconds.
[  479.107958]       Not tainted 3.18.0-0.rc0.git9.3.fc22.x86_64 #1
[  479.108450] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  479.108941] echo            D ffff8800c82a3480 12472   622      1 0x00000004
[  479.109494]  ffff8800ca2e3ac8 0000000000000096 ffff8800c82a3480 00000000001d5f00
[  479.110038]  ffff8800ca2e3fd8 00000000001d5f00 ffff880128bf0000 ffff8800c82a3480
[  479.110596]  ffffffff82c30990 7fffffffffffffff ffffffff81ee2698 ffffffff81ee2690
[  479.111143] Call Trace:
[  479.111694]  [<ffffffff8185baf9>] schedule+0x29/0x70
[  479.112236]  [<ffffffff81860d1c>] schedule_timeout+0x26c/0x410
[  479.112786]  [<ffffffff81028c4a>] ? native_sched_clock+0x2a/0xa0
[  479.113331]  [<ffffffff811078bc>] ? mark_held_locks+0x7c/0xb0
[  479.113853]  [<ffffffff81861da0>] ? _raw_spin_unlock_irq+0x30/0x50
[  479.114393]  [<ffffffff81107a4d>] ? trace_hardirqs_on_caller+0x15d/0x200
[  479.114917]  [<ffffffff8185d52c>] wait_for_completion+0x10c/0x150
[  479.115459]  [<ffffffff810e51f0>] ? wake_up_state+0x20/0x20
[  479.115975]  [<ffffffff8112a559>] _rcu_barrier+0x159/0x200
[  479.116510]  [<ffffffff8112a655>] rcu_barrier+0x15/0x20
[  479.117028]  [<ffffffff8171813f>] netdev_run_todo+0x6f/0x310
[  479.117553]  [<ffffffff817251ae>] rtnl_unlock+0xe/0x10
[  479.118067]  [<ffffffff8170ea35>] unregister_netdev+0x25/0x30
[  479.118617]  [<ffffffffa00222d2>] rtl_remove_one+0x62/0x230 [r8169]
[  479.119140]  [<ffffffff814682cf>] pci_device_remove+0x3f/0xc0
[  479.119688]  [<ffffffff8155b34f>] __device_release_driver+0x7f/0xf0
[  479.120196]  [<ffffffff8155b3e5>] device_release_driver+0x25/0x40
[  479.120722]  [<ffffffff8146234c>] pci_stop_bus_device+0x9c/0xb0
[  479.121243]  [<ffffffff8146248e>] pci_stop_and_remove_bus_device_locked+0x1e/0x40
[  479.121782]  [<ffffffff8146b44c>] remove_store+0x7c/0x90
[  479.122323]  [<ffffffff81555f98>] dev_attr_store+0x18/0x30
[  479.122838]  [<ffffffff81302789>] sysfs_kf_write+0x49/0x60
[  479.123364]  [<ffffffff81301ac9>] kernfs_fop_write+0xf9/0x180
[  479.123882]  [<ffffffff8127305a>] vfs_write+0xba/0x200
[  479.124416]  [<ffffffff8186379c>] ? retint_swapgs+0x13/0x1b
[  479.124928]  [<ffffffff81273bac>] SyS_write+0x5c/0xd0
[  479.125460]  [<ffffffff81862b69>] system_call_fastpath+0x12/0x17
[  479.125968] 6 locks held by echo/622:
[  479.126498]  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff81273143>] vfs_write+0x1a3/0x200
[  479.127054]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff81301a97>] kernfs_fop_write+0xc7/0x180
[  479.127624]  #2:  (s_active#131){++++++}, at: [<ffffffff81300ce4>] kernfs_remove_self+0xf4/0x170
[  479.128192]  #3:  (pci_rescan_remove_lock){+.+.+.}, at: [<ffffffff8145f167>] pci_lock_rescan_remove+0x17/0x20
[  479.128773]  #4:  (&dev->mutex){......}, at: [<ffffffff8155b3dd>] device_release_driver+0x1d/0x40
[  479.129361]  #5:  (rcu_sched_state.barrier_mutex){+.+...}, at: [<ffffffff8112a435>] _rcu_barrier+0x35/0x200
...

Ref.
http://koji.fedoraproject.org/koji/packageinfo?packageID=8


