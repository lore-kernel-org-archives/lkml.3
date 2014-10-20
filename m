Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaJTLXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:23:10 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36346 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaJTLXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:23:07 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-2e-5444f098fcee
Message-id: <5444F096.3010703@samsung.com>
Date: Mon, 20 Oct 2014 15:23:02 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.8.1
MIME-version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: jbd2: revoke: negative shift exponent in hash()
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
In-reply-to: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e/4Vd0ZH1xCDL4dErP4+qWDxWLO+jVs
	FhMetrFbTNsobrGy8wGrxcx5d9gs/uzawWRxedccNotLBxYwWbTsu8Bkcbz3AJPF4iO3mS02
	b5rKbNHa85Pd4seGx6wO/B4tm8s9ds66y+6xYFOpx+YVWh6bVnWyebw7d47d48SM3yweTWeO
	Mnt8fHqLxeP9vqtsHmcWHGH3+LxJzuNEyxfWAN4oLpuU1JzMstQifbsErowFfYeYCjaJVGxZ
	uomxgbFbuIuRk0NCwETi17QNjBC2mMSFe+vZuhi5OIQEljJKLN7Szg7hNDNJ/Os8zApSxSug
	JXHq3hVmEJtFQFVi5eNzYHE2AT2Jf7O2s4HYogIREhvX72CEqBeU+DH5HguILSKQJTHp1D0m
	kKHMAkuZJZq6zoI1CAtYSNz4/YYJxBYScJPovnQIzOYUcJe4MG8v2DJmAXWJSfMWQdnyEpvX
	vGWewCgwC8mOWUjKZiEpW8DIvIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJAK/7mBceszq
	EKMAB6MSD+8OM5cQIdbEsuLK3EOMEhzMSiK8Dm+AQrwpiZVVqUX58UWlOanFhxiZODilGhhd
	PzV18jZdmKVzevX6gB3JLp+CbEpicxb/n3099seRyEpry73Tm7sUjr1y121dn7TzZqqaeaGJ
	R8EPqaOHnpRIW7vs6L06Ne9CIYP3brmywJ1qbrdjwpv5/3D5lE/Ynvas0DFqv4TTBRWn7Ohj
	Kau0Hp13VDqkfuR8UY+Kdfw6de9Fr7Yv41BiKc5INNRiLipOBAAbz5LYngIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And one more negative shift, this time in jbd2/revoke.c in hash() function:

================================================================================
UBSan: Undefined behaviour in ../fs/jbd2/revoke.c:142:9
shift exponent -4 is negative
CPU: 3 PID: 1314 Comm: runscript.sh Not tainted 3.18.0-rc1+ #65
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
 0000000000000010 0000000000000000 0000000000000000 ffff8800baba3868
 ffffffff82ade70a 000000000000004a fffffffffffffffc ffff8800baba3878
 ffffffff819a5339 ffff8800baba3928 ffffffff819a5825 ffff8800baba38b8
Call Trace:
dump_stack (/home/andrew/linux/ubsan_x86//lib/dump_stackc:52)
ubsan_epilogue (/home/andrew/linux/ubsan_x86//lib/ubsanc:159)
__ubsan_handle_shift_out_of_bounds (/home/andrew/linux/ubsan_x86//lib/ubsanc:458)
find_revoke_record (/home/andrew/linux/ubsan_x86//fs/jbd2/revokec:142 /home/andrew/linux/ubsan_x86//fs/jbd2/revokec:180)
jbd2_journal_cancel_revoke (/home/andrew/linux/ubsan_x86//fs/jbd2/revokec:449)
do_get_write_access (/home/andrew/linux/ubsan_x86//fs/jbd2/transactionc:992)
jbd2_journal_get_write_access (/home/andrew/linux/ubsan_x86//fs/jbd2/transactionc:1022)
__ext4_journal_get_write_access (/home/andrew/linux/ubsan_x86//fs/ext4/ext4_jbd2c:159)
ext4_file_open (/home/andrew/linux/ubsan_x86//fs/ext4/filec:238)
do_dentry_open (/home/andrew/linux/ubsan_x86//fs/openc:722)
? __inode_permission (/home/andrew/linux/ubsan_x86//fs/nameic:418)
? ext4_check_all_de (/home/andrew/linux/ubsan_x86//fs/ext4/filec:209)
finish_open (/home/andrew/linux/ubsan_x86//fs/openc:784)
? may_open (/home/andrew/linux/ubsan_x86//fs/nameic:2572)
do_last (/home/andrew/linux/ubsan_x86//fs/nameic:3069)
? link_path_walk (/home/andrew/linux/ubsan_x86//fs/nameic:1495 /home/andrew/linux/ubsan_x86//fs/nameic:1757)
? inode_has_perm (/home/andrew/linux/ubsan_x86//security/selinux/hooksc:1620)
path_openat (/home/andrew/linux/ubsan_x86//fs/nameic:699 /home/andrew/linux/ubsan_x86//fs/nameic:3229)
do_filp_open (/home/andrew/linux/ubsan_x86//fs/nameic:3260)
? prepare_creds (/home/andrew/linux/ubsan_x86//kernel/credc:269)
do_open_exec (/home/andrew/linux/ubsan_x86//fs/execc:762)
do_execve_common.isra.21 (/home/andrew/linux/ubsan_x86//fs/execc:1476)
? getname_flags (/home/andrew/linux/ubsan_x86//fs/nameic:160)
SyS_execve (/home/andrew/linux/ubsan_x86//fs/execc:1604)
stub_execve (/home/andrew/linux/ubsan_x86//arch/x86/kernel/entry_64S:649)
================================================================================



