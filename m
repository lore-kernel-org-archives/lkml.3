Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaAZSnb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 13:43:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbaAZSna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 13:43:30 -0500
Date: Sun, 26 Jan 2014 19:43:10 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/8] perf tools: kaslr fixes
Message-ID: <20140126184310.GB1126@krava.brq.redhat.com>
References: <1390576218-1463-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390576218-1463-1-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 05:10:10PM +0200, Adrian Hunter wrote:
> Hi
> 
> Here are some patches that improve perf tools
> handling of relocation.
> 
> This has become an issue as mentioned in this
> thread:
> 
> 	http://marc.info/?l=linux-kernel&m=139030004314756
> 
> 
> It looks like the changes I made to vmlinux and
> module mapping to allow object code to be read
> broke the symbol annotation for relocated kernels.
> The first patch fixes that.
> 
> There were some other issues though:
> 	- ref_reloc_sym was not always set up
> 	- mustn't use kcore if the kernel has moved
> 	- kallsyms is not unique for a given
> 	buildid
> 
> These things need more testing but I thought it was
> worth getting comments now.
> 
> 
> Adrian Hunter (8):
>       perf tools: Fix symbol annotation for relocated kernel
>       perf tools: Add kallsyms__get_function_start()
>       perf tools: Add machine__get_kallsyms_filename()
>       perf tools: Set up ref_reloc_sym in machine__create_kernel_maps()
>       perf report: Get ref_reloc_sym from kernel map
>       perf tools: Prevent the use of kcore if the kernel has moved
>       perf tools: test does not need to set up ref_reloc_sym
>       perf tools: Adjust kallsyms for relocated kernel

cannot say much for the code changes (look ok ;-) ), but
it fixed the issue for me

Tested-by: Jiri Olsa <jolsa@redhat.com>

jirka
