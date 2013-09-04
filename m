Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab3IDTAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:00:53 -0400
Received: from mail.renton.name ([90.155.165.44]:39731 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760076Ab3IDTAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:00:51 -0400
Date: Wed, 4 Sep 2013 22:53:15 +0400
From: Alexey Vlasov <renton@renton.name>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <bitbucket@online.de>, linux-kernel@vger.kernel.org
Subject: Re: Kernel migration eat CPUs
Message-ID: <20130904185315.GB13294@beaver>
References: <20130823151711.f4c1f596b4c7aa1eecccc9a6@linux-foundation.org>
 <20130825142837.GD31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130825142837.GD31370@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 25, 2013 at 04:28:37PM +0200, Peter Zijlstra wrote:

> and a function (or function-graph)
> trace for when this happens?

Unfortunately I could not make trace.
First when migration threads start to eat CPUs and when I turn on trace:
# echo function > current_tracer
# echo 1 > tracing_on
then server is down at once. LA comes up to several thousands, it stops
to receive commands. Sometimes I even have to reboot it.

And second when I manage to get trace then it shows little useful data.

https://www.dropbox.com/s/kxgwr9fuckddtgf/trace.txt.gz

Probably this junk appears from grsec patch? And I don't see migration
threads in it.

> Perhaps perf top -p <pick-a-thread> while the problem is happening will
> show something.

Also "perf top" doesn't show anything. It gives same values when
migration threads eat CPUs and when everything is OK on server.

=========================================
PerfTop: 68932 irqs/sec kernel:60.3%  exact: 0.0% [4000Hz cycles], (all, 32 CPUs)
---------------------------------------------------------------------------------

64.11%  [netconsole]           [k] 0xffffffff81000de3
34.19%  [unknown]              [.] 0x0000000000585c45
 0.40%  libc-2.15.so           [.] 0x0000000000124b10
 0.23%  perf                   [.] 0x000000000004df4f
 0.14%  ld-2.15.so             [.] 0x00000000000183e7
 0.08%  libc-2.15.so           [.] _nss_files_parse_grent
 0.06%  libc-2.15.so           [.] _nss_files_parse_pwent
 0.04%  libc-2.15.so           [.] memchr
 0.04%  php-cgi                [.] match
 0.03%  libcrypt-2.15.so       [.] 0x0000000000004eab
 0.03%  bash                   [.] 0x000000000001fe5a
 0.02%  libc-2.15.so           [.] _IO_getline_info
 0.02%  php-cgi                [.] php_pcre_exec
 0.02%  libc-2.15.so           [.] _dl_addr
 0.02%  eaccelerator.so        [.] eaccelerator_crc32
 0.02%  php-cgi                [.] zend_hash_quick_find
 0.02%  libnss_compat-2.15.so  [.] 0x00000000000055f1
 0.01%  php-cgi                [.] zendparse
 0.01%  libc-2.15.so           [.] fgets_unlocked
 0.01%  libnss_compat-2.15.so  [.] _nss_compat_initgroups_dyn
=========================================

Now server is more loaded and eating CPUs by migration threads happens more often
and it lasts longer.

-- 
BRGDS. Alexey Vlasov.
