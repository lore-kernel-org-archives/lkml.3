Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3LSOMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:12:50 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:34172 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab3LSOMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:12:49 -0500
Date: Thu, 19 Dec 2013 11:12:32 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, dsahern@gmail.com,
        adrian.hunter@intel.com, mingo@redhat.com, paulus@samba.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH 0/4] Add support of guest user space symbols for perf kvm
 command.
Message-ID: <20131219141232.GM4819@ghostprotocols.net>
References: <cover.1387493396.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387493396.git.yangds.fnst@cn.fujitsu.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 19, 2013 at 05:54:50PM -0500, Dongsheng Yang escreveu:
> Hi all,
> 	This patch add support of guest user space symbols for perf kvm command.

Cool stuff! Please see some comments on the patches, with requests for
possible patch splits and better changeset comments.
 
> Example:
>         # perf kvm --guestmount /tmp/guestmount/ top
>         Samples: 1K of event 'cycles', Event count (approx.): 259112905
>          17.34%  libcrypto.so.1.0.1e  [u] 0x000000000007d971
>           5.60%  [guest.kernel]       [g] kallsyms_expand_symbol
>           5.44%  libcrypto.so.1.0.1e  [u] md5_block_asm_data_order
>           4.09%  [guest.kernel]       [g] number.isra.1
>           3.59%  [guest.kernel]       [g] vsnprintf
>           3.52%  sshd                 [u] 0x00000000000441c0
>           2.37%  [guest.kernel]       [g] format_decode
>           2.36%  [guest.kernel]       [g] memcpy
>           2.11%  [guest.kernel]       [g] strnlen
> 
>         # perf kvm --guestmount /tmp/guestmount/ record -a sleep 1
>         [ perf record: Woken up 1 times to write data ]
>         [ perf record: Captured and wrote 0.828 MB perf.data.guest (~36163 samples) ]
>     
>         # perf kvm --guestmount /tmp/guestmount/ report
>         Samples: 4K of event 'cycles', Event count (approx.): 2662750816
>           8.67%  [guest/9217]  dd                            [u] 0x0000000000004e90
>           6.62%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] fget_light
>           6.17%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] system_call
>           5.97%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] __srcu_read_lock
>           5.53%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] __srcu_read_unlock
>           5.47%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] __audit_syscall_exit
>           5.38%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] fsnotify
>           5.32%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] system_call_after_swapgs
>           4.45%  [guest/9217]  libc-2.17.so                  [u] __GI___libc_write
>           4.15%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] sys_write
>           3.97%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] vfs_read
>           3.78%  [guest/9217]  libc-2.17.so                  [u] __GI___libc_read
> 
> 
> Dongsheng Yang (4):
>   perf tools: Add support of guest in synthesize_threads.
>   perf tools: Add support for PERF_RECORD_MISC_GUEST_USER in
>     thread__find_addr_map().
>   perf tools: Add support of user space symbols for guest in perf kvm
>     top.
>   perf tools: Add support of user space symbols for guest in perf kvm
>     record.
> 
>  tools/perf/builtin-record.c | 10 ++++++++++
>  tools/perf/builtin-top.c    | 15 ++++++++++-----
>  tools/perf/util/event.c     | 44 ++++++++++++++++++++++++++++++--------------
>  3 files changed, 50 insertions(+), 19 deletions(-)
> 
> -- 
> 1.8.2.1
