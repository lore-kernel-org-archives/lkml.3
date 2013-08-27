Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3H0KYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 06:24:16 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:52897 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3H0KYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 06:24:14 -0400
X-Nat-Received: from [202.181.97.72]:62551 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1377599035.12765
To: ak@linux.intel.com, viro@ZenIV.linux.org.uk, geert@linux-m68k.org,
        akpm@linux-foundation.org
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130822] module: broken module versions?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201308262306.DHB48401.OHFSVQJOtLFOMF@I-love.SAKURA.ne.jp>
In-Reply-To: <201308262306.DHB48401.OHFSVQJOtLFOMF@I-love.SAKURA.ne.jp>
Message-Id: <201308271923.FCG13057.QLVHOFFSMtJOFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 27 Aug 2013 19:23:51 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 27082013 #10958075, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that symbols which cause "disagrees about version of symbol" messages
have crc == 0.

---------- scripts/mod/modpost.c ----------
 	/* CRC'd symbol */
 	if (strncmp(symname, CRC_PFX, strlen(CRC_PFX)) == 0) {
 		crc = (unsigned int) sym->st_value;
+		if (!crc)
+			fprintf(stderr, "symbol %s has crc=0 sym->st_shndx=%d\n",
+				symname, sym->st_shndx);
 		sym_update_crc(symname + strlen(CRC_PFX), mod, crc,
 			       export);
 	}
---------- scripts/mod/modpost.c ----------

I got below messages upon build.

  symbol __crc_sys_close has crc=0 sym->st_shndx=0
  symbol __crc_path_is_under has crc=0 sym->st_shndx=0
  symbol __crc_task_nice has crc=0 sym->st_shndx=0
  symbol __crc_vfs_fsync_range has crc=0 sym->st_shndx=0
  symbol __crc___symbol_put has crc=0 sym->st_shndx=0
  symbol __crc_iov_shorten has crc=0 sym->st_shndx=0
  symbol __crc_inode_add_bytes has crc=0 sym->st_shndx=0
  symbol __crc_sock_register has crc=0 sym->st_shndx=0
  symbol __crc_vm_brk has crc=0 sym->st_shndx=0
  symbol __crc_kern_mount_data has crc=0 sym->st_shndx=0
  symbol __crc_schedule_timeout has crc=0 sym->st_shndx=0
  symbol __crc_generic_getxattr has crc=0 sym->st_shndx=0
  symbol __crc_in_group_p has crc=0 sym->st_shndx=0
  symbol __crc_finish_open has crc=0 sym->st_shndx=0
  symbol __crc_get_unmapped_area has crc=0 sym->st_shndx=0
  symbol __crc_generic_write_sync has crc=0 sym->st_shndx=0
  symbol __crc_filp_close has crc=0 sym->st_shndx=0
  symbol __crc_d_tmpfile has crc=0 sym->st_shndx=0
  symbol __crc_iterate_fd has crc=0 sym->st_shndx=0
  symbol __crc_register_exec_domain has crc=0 sym->st_shndx=0
  symbol __crc_ns_capable has crc=0 sym->st_shndx=0
  symbol __crc___page_file_mapping has crc=0 sym->st_shndx=0
  symbol __crc_mnt_set_expiry has crc=0 sym->st_shndx=0
  symbol __crc_do_sync_read has crc=0 sym->st_shndx=0
  symbol __crc_vfs_test_lock has crc=0 sym->st_shndx=0
  symbol __crc_perf_event_create_kernel_counter has crc=0 sym->st_shndx=0
  symbol __crc_current_fs_time has crc=0 sym->st_shndx=0
  symbol __crc_softirq_work_list has crc=0 sym->st_shndx=0
  symbol __crc_sys_close has crc=0 sym->st_shndx=0
  symbol __crc_path_is_under has crc=0 sym->st_shndx=0
  symbol __crc_task_nice has crc=0 sym->st_shndx=0
  symbol __crc_vfs_fsync_range has crc=0 sym->st_shndx=0
  symbol __crc___symbol_put has crc=0 sym->st_shndx=0
  symbol __crc_iov_shorten has crc=0 sym->st_shndx=0
  symbol __crc_inode_add_bytes has crc=0 sym->st_shndx=0
  symbol __crc_sock_register has crc=0 sym->st_shndx=0
  symbol __crc_vm_brk has crc=0 sym->st_shndx=0
  symbol __crc_kern_mount_data has crc=0 sym->st_shndx=0
  symbol __crc_schedule_timeout has crc=0 sym->st_shndx=0
  symbol __crc_generic_getxattr has crc=0 sym->st_shndx=0
  symbol __crc_in_group_p has crc=0 sym->st_shndx=0
  symbol __crc_finish_open has crc=0 sym->st_shndx=0
  symbol __crc_get_unmapped_area has crc=0 sym->st_shndx=0
  symbol __crc_generic_write_sync has crc=0 sym->st_shndx=0
  symbol __crc_filp_close has crc=0 sym->st_shndx=0
  symbol __crc_d_tmpfile has crc=0 sym->st_shndx=0
  symbol __crc_iterate_fd has crc=0 sym->st_shndx=0
  symbol __crc_register_exec_domain has crc=0 sym->st_shndx=0
  symbol __crc_ns_capable has crc=0 sym->st_shndx=0
  symbol __crc___page_file_mapping has crc=0 sym->st_shndx=0
  symbol __crc_mnt_set_expiry has crc=0 sym->st_shndx=0
  symbol __crc_do_sync_read has crc=0 sym->st_shndx=0
  symbol __crc_vfs_test_lock has crc=0 sym->st_shndx=0
  symbol __crc_perf_event_create_kernel_counter has crc=0 sym->st_shndx=0
  symbol __crc_current_fs_time has crc=0 sym->st_shndx=0
  symbol __crc_softirq_work_list has crc=0 sym->st_shndx=0

I continued bisection in this way and found that commit 5c019369 "syscalls.h:
use gcc alias instead of assembler aliases for syscalls" started showing
below messages upon build.

  WARNING: "ns_capable" [net/ipv6/sit.ko] has no CRC!
  WARNING: "ns_capable" [net/ipv6/ipv6.ko] has no CRC!
  WARNING: "sock_register" [net/ipv6/ipv6.ko] has no CRC!
  WARNING: "ns_capable" [net/ipv4/ip_tunnel.ko] has no CRC!
  WARNING: "inode_add_bytes" [fs/udf/udf.ko] has no CRC!
  WARNING: "current_fs_time" [fs/udf/udf.ko] has no CRC!
  WARNING: "do_sync_read" [fs/udf/udf.ko] has no CRC!
  WARNING: "d_tmpfile" [fs/udf/udf.ko] has no CRC!
  WARNING: "sys_close" [fs/binfmt_misc.ko] has no CRC!
  WARNING: "current_fs_time" [fs/binfmt_misc.ko] has no CRC!
  WARNING: "vm_brk" [fs/binfmt_aout.ko] has no CRC!
  WARNING: "sys_close" [fs/autofs4/autofs4.ko] has no CRC!
  WARNING: "schedule_timeout" [drivers/hid/usbhid/usbhid.ko] has no CRC!

Reverting commit 5c019369 from linux-next-20130822 solved this problem.

Andi, would you check?

Regards.
