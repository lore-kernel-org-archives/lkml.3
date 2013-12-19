Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab3LSJ4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:56:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:11887 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab3LSJ4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:56:48 -0500
X-IronPort-AV: E=Sophos;i="4.95,512,1384272000"; 
   d="scan'208";a="9291074"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, eranian@google.com, dsahern@gmail.com,
        adrian.hunter@intel.com, acme@ghostprotocols.net
Cc: mingo@redhat.com, paulus@samba.org, a.p.zijlstra@chello.nl,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 0/4] Add support of guest user space symbols for perf kvm command.
Date: Thu, 19 Dec 2013 17:54:50 -0500
Message-Id: <cover.1387493396.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 17:56:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 17:56:16,
	Serialize complete at 2013/12/19 17:56:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
	This patch add support of guest user space symbols for perf kvm command.

Example:
        # perf kvm --guestmount /tmp/guestmount/ top
        Samples: 1K of event 'cycles', Event count (approx.): 259112905
         17.34%  libcrypto.so.1.0.1e  [u] 0x000000000007d971
          5.60%  [guest.kernel]       [g] kallsyms_expand_symbol
          5.44%  libcrypto.so.1.0.1e  [u] md5_block_asm_data_order
          4.09%  [guest.kernel]       [g] number.isra.1
          3.59%  [guest.kernel]       [g] vsnprintf
          3.52%  sshd                 [u] 0x00000000000441c0
          2.37%  [guest.kernel]       [g] format_decode
          2.36%  [guest.kernel]       [g] memcpy
          2.11%  [guest.kernel]       [g] strnlen

        # perf kvm --guestmount /tmp/guestmount/ record -a sleep 1
        [ perf record: Woken up 1 times to write data ]
        [ perf record: Captured and wrote 0.828 MB perf.data.guest (~36163 samples) ]
    
        # perf kvm --guestmount /tmp/guestmount/ report
        Samples: 4K of event 'cycles', Event count (approx.): 2662750816
          8.67%  [guest/9217]  dd                            [u] 0x0000000000004e90
          6.62%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] fget_light
          6.17%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] system_call
          5.97%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] __srcu_read_lock
          5.53%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] __srcu_read_unlock
          5.47%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] __audit_syscall_exit
          5.38%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] fsnotify
          5.32%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] system_call_after_swapgs
          4.45%  [guest/9217]  libc-2.17.so                  [u] __GI___libc_write
          4.15%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] sys_write
          3.97%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] vfs_read
          3.78%  [guest/9217]  libc-2.17.so                  [u] __GI___libc_read


Dongsheng Yang (4):
  perf tools: Add support of guest in synthesize_threads.
  perf tools: Add support for PERF_RECORD_MISC_GUEST_USER in
    thread__find_addr_map().
  perf tools: Add support of user space symbols for guest in perf kvm
    top.
  perf tools: Add support of user space symbols for guest in perf kvm
    record.

 tools/perf/builtin-record.c | 10 ++++++++++
 tools/perf/builtin-top.c    | 15 ++++++++++-----
 tools/perf/util/event.c     | 44 ++++++++++++++++++++++++++++++--------------
 3 files changed, 50 insertions(+), 19 deletions(-)

-- 
1.8.2.1

