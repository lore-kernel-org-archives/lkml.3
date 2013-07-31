Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751Ab3GaRqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 13:46:36 -0400
Received: from mail-vb0-f50.google.com ([209.85.212.50]:47956 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760578Ab3GaRqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 13:46:33 -0400
Date: Wed, 31 Jul 2013 14:46:24 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V2 1/9] perf tools: add test for reading object code
Message-ID: <20130731174624.GJ3614@ghostprotocols.net>
References: <1375218838-31042-1-git-send-email-adrian.hunter@intel.com>
 <1375218838-31042-2-git-send-email-adrian.hunter@intel.com>
 <20130731145820.GF3614@ghostprotocols.net>
 <20130731172833.GH3614@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731172833.GH3614@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jul 31, 2013 at 02:28:33PM -0300, Arnaldo Carvalho de Melo escreveu:
> Still investigating, but the attached patch is needed to handle such
> failure cases:
 
> [root@zoo ~]# perf test 21
> 21: Test object code reading                               : FAILED!
> [root@zoo ~]# perf test -v 21

Lowering the freq to 4kHz gets me to where I think you was at this
point:

[root@zoo ~]# perf test -v 21
21: Test object code reading                               :
--- start ---
Looking at the vmlinux_path (6 entries long)
symsrc__init: cannot get elf header.
Using /lib/modules/3.11.0-rc2+/build/vmlinux for symbols
Parsing event 'cycles'
Reading object code for memory address: 0xffffffff8101ce7d
File is: /lib/modules/3.11.0-rc2+/build/vmlinux
On file address is: 0xffffffff8101ce7d
dso__data_read_offset failed
---- end ----
Test object code reading: FAILED!
[root@zoo ~]# 

I.e. we need the follow on patches to fix this issue, right?

I'll merge my changes with your first patch and continue from there.

- Arnaldo
