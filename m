Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaDYOrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 10:47:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47076 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaDYOrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 10:47:36 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-d2-535a75851842
Message-id: <535A75C1.3050901@samsung.com>
Date: Fri, 25 Apr 2014 17:48:33 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: linux-security-module <linux-security-module@vger.kernel.org>,
        john.johansen@canonical.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, viro@ZenIV.linux.org.uk,
        oleg@redhat.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-team@lists.ubuntu.com
Subject: Re: Kernel panic at Ubuntu: IMA + Apparmor
References: <535A5C78.1070901@samsung.com>
In-reply-to: <535A5C78.1070901@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t/xq7qtpVHBBqd6zS3WrV/MZHHiSyub
	xZxHm9gtLu+aw2bxoecRm8XW/a2MFuf/Hme1+LRiErMDh8eshl42jweHNrN4XLtxn8Wj53uy
	x/t9V9k8Pm+S89j05C1TAHsUl01Kak5mWWqRvl0CV8aE99OZC7bqVhy47tTA+Eu1i5GTQ0LA
	ROL0gw8sELaYxIV769lAbCGBpYwS15fzdjFyAdmNTBKLT29ghXBmMUr8OfGMEaSKV0BLYv2+
	XlYQm0VAVeLT9aVMIDabgJ7EhuYf7CC2qECExL3Gw6wQ9YISPybfYwEZJCJwlVFi/70+sNXM
	AjES21Z9Byri4BAWMJbY/CEI4gotieMbb4BdxCmgLbGw/woTRLmOxP7WaWwQtrzE5jVvmSHq
	VSW6165lg/hGUeL05HPMExiFZyFZPQtJ+ywk7QsYmVcxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn
	525ihETSlx2Mi49ZHWIU4GBU4uH9oBYZLMSaWFZcmXuIUYKDWUmE91p+VLAQb0piZVVqUX58
	UWlOavEhRiYOTqkGRs0Few4qh53rlG96peQg/GGd2OfNm8o3L/C1M9zCaHXifv4hBj2bCi6B
	a6rLk5aWn1x3nd2bbVfVK1buRZNtKmsSq9+9PvLhTslaq9+C/3Uu3zRqnn7sN1/8DQNl9zNW
	h2fEH1F0Z4mvmMqtKS9hstXgu1zs779ZuY5fjDRiXnOtvrLq+Kwb75RYijMSDbWYi4oTAbru
	rYmCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/14 16:00, Dmitry Kasatkin wrote:
> Hello,
>
> I discovered a kernel panic on system running Ubuntu when IMA is enabled.
> It happens on reboot.
>
> ----------------------
> [  106.750100] NSPROXY is NULL: error.log (/var/log/mysql/error.log)
> [  106.750167] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000018
> [  106.750221] IP: [<ffffffff811ec7da>] our_mnt+0x1a/0x30
> [  106.750241] PGD 0
> [  106.750254] Oops: 0000 [#1] SMP
> [  106.750272] Modules linked in: cuse parport_pc ppdev bnep rfcomm
> bluetooth rpcsec_gss_krb5 nfsd auth_rpcgss nfs_acl nfs lockd sunrpc
> fscache dm_crypt intel_rapl x86_pkg_temp_thermal intel_powerclamp
> kvm_intel snd_hda_codec_hdmi kvm crct10dif_pclmul crc32_pclmul
> ghash_clmulni_intel aesni_intel aes_x86_64 glue_helper lrw gf128mul
> ablk_helper cryptd snd_hda_codec_realtek dcdbas snd_hda_intel
> snd_hda_codec snd_hwdep snd_pcm snd_page_alloc snd_seq_midi
> snd_seq_midi_event snd_rawmidi psmouse snd_seq microcode serio_raw
> snd_timer snd_seq_device snd soundcore video lpc_ich coretemp mac_hid lp
> parport mei_me mei nbd hid_generic e1000e usbhid ahci ptp hid libahci
> pps_core
> [  106.750658] CPU: 6 PID: 1394 Comm: mysqld Not tainted 3.13.0-rc7-kds+ #15
> [  106.750673] Hardware name: Dell Inc. OptiPlex 9010/0M9KCM, BIOS A08
> 09/19/2012
> [  106.750689] task: ffff8800de804920 ti: ffff880400fca000 task.ti:
> ffff880400fca000
> [  106.750704] RIP: 0010:[<ffffffff811ec7da>]  [<ffffffff811ec7da>]
> our_mnt+0x1a/0x30
> [  106.750725] RSP: 0018:ffff880400fcba60  EFLAGS: 00010286
> [  106.750738] RAX: 0000000000000000 RBX: 0000000000000100 RCX:
> ffff8800d51523e7
> [  106.750764] RDX: ffffffffffffffea RSI: ffff880400fcba34 RDI:
> ffff880402d20020
> [  106.750791] RBP: ffff880400fcbae0 R08: 0000000000000000 R09:
> 0000000000000001
> [  106.750817] R10: 0000000000000000 R11: 0000000000000001 R12:
> ffff8800d5152300
> [  106.750844] R13: ffff8803eb8df510 R14: ffff880400fcbb28 R15:
> ffff8800d51523e7
> [  106.750871] FS:  0000000000000000(0000) GS:ffff88040d200000(0000)
> knlGS:0000000000000000
> [  106.750910] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  106.750935] CR2: 0000000000000018 CR3: 0000000001c0e000 CR4:
> 00000000001407e0
> [  106.750962] Stack:
> [  106.750981]  ffffffff813434eb ffff880400fcbb20 ffff880400fcbb18
> 0000000000000000
> [  106.751037]  ffff8800de804920 ffffffff8101b9b9 0001800000000000
> 0000000000000100
> [  106.751093]  0000010000000000 0000000000000002 000000000000000e
> ffff8803eb8df500
> [  106.751149] Call Trace:
> [  106.751172]  [<ffffffff813434eb>] ? aa_path_name+0x2ab/0x430
> [  106.751199]  [<ffffffff8101b9b9>] ? sched_clock+0x9/0x10
> [  106.751225]  [<ffffffff8134a68d>] aa_path_perm+0x7d/0x170
> [  106.751250]  [<ffffffff8101b945>] ? native_sched_clock+0x15/0x80
> [  106.751276]  [<ffffffff8134aa73>] aa_file_perm+0x33/0x40
> [  106.751301]  [<ffffffff81348c5e>] common_file_perm+0x8e/0xb0
> [  106.751327]  [<ffffffff81348d78>] apparmor_file_permission+0x18/0x20
> [  106.751355]  [<ffffffff8130c853>] security_file_permission+0x23/0xa0
> [  106.751382]  [<ffffffff811c77a2>] rw_verify_area+0x52/0xe0
> [  106.751407]  [<ffffffff811c789d>] vfs_read+0x6d/0x170
> [  106.751432]  [<ffffffff811cda31>] kernel_read+0x41/0x60
> [  106.751457]  [<ffffffff8134fd45>] ima_calc_file_hash+0x225/0x280
> [  106.751483]  [<ffffffff8134fb52>] ? ima_calc_file_hash+0x32/0x280
> [  106.751509]  [<ffffffff8135022d>] ima_collect_measurement+0x9d/0x160
> [  106.751536]  [<ffffffff810b552d>] ? trace_hardirqs_on+0xd/0x10
> [  106.751562]  [<ffffffff8134f07c>] ? ima_file_free+0x6c/0xd0
> [  106.751587]  [<ffffffff81352824>] ima_update_xattr+0x34/0x60
> [  106.751612]  [<ffffffff8134f0d0>] ima_file_free+0xc0/0xd0
> [  106.751637]  [<ffffffff811c9635>] __fput+0xd5/0x300
> [  106.751662]  [<ffffffff811c98ae>] ____fput+0xe/0x10
> [  106.751687]  [<ffffffff81086774>] task_work_run+0xc4/0xe0
> [  106.751712]  [<ffffffff81066fad>] do_exit+0x2bd/0xa90
> [  106.751738]  [<ffffffff8173c958>] ? retint_swapgs+0x13/0x1b
> [  106.751763]  [<ffffffff8106780c>] do_group_exit+0x4c/0xc0
> [  106.751788]  [<ffffffff81067894>] SyS_exit_group+0x14/0x20
> [  106.751814]  [<ffffffff8174522d>] system_call_fastpath+0x1a/0x1f
> [  106.751839] Code: c3 0f 1f 44 00 00 55 48 89 e5 e8 22 fe ff ff 5d c3
> 0f 1f 44 00 00 55 65 48 8b 04 25 c0 c9 00 00 48 8b 80 28 06 00 00 48 89
> e5 5d <48> 8b 40 18 48 39 87 c0 00 00 00 0f 94 c0 c3 0f 1f 80 00 00 00
> [  106.752185] RIP  [<ffffffff811ec7da>] our_mnt+0x1a/0x30
> [  106.752214]  RSP <ffff880400fcba60>
> [  106.752236] CR2: 0000000000000018
> [  106.752258] ---[ end trace 3c520748b4732721 ]---
> [  106.752282] Fixing recursive fault but reboot is needed!
>
> ----------------------------
>
> It happens in "our_mnt", because current->nsproxy is NULL...
>
> It looks like "current->nsproxy" is gone before mysqld closes error.log,
> or it is always NULL for mysqld???
>
>
> Does anyone have any ideas?
>
> Thanks,
> Dmitry
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


It seems the problem is the order of functions in do_exit

do_exit()
{
    ...
    exit_task_namespaces(tsk);
    exit_task_work(tsk);
    ...
}

First, namesspaces is cleaned up.
Second, delayed fput is done.

It seems this patch appeared in 3.10 is the reason for the panic:

8aac62706         move exit_task_namespaces() outside of exit_notify()

This patch moved exit_task_namespaces(tsk) before exit_task_work..

Oleg, Al, any thoughts?

Thanks,

- Dmitry

