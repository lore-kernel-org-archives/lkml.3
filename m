Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3JCN6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:58:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46947 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3JCN6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:58:06 -0400
Date: Thu, 3 Oct 2013 15:57:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, mingo@kernel.org,
        tglx@linutronix.de, hpa@zytor.com
Subject: Re: [BUG] perf tests: Test converting perf time to TSC
Message-ID: <20131003135748.GK28601@twins.programming.kicks-ass.net>
References: <20131002132308.GB20396@krava.brq.redhat.com>
 <524C23D3.6020300@intel.com>
 <20131003081737.GB993@krava.brq.redhat.com>
 <524D2E06.5020801@intel.com>
 <20131003085625.GA3081@twins.programming.kicks-ass.net>
 <524D4359.2060801@intel.com>
 <20131003110224.GD3081@twins.programming.kicks-ass.net>
 <524D59B5.4040004@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524D59B5.4040004@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 02:49:09PM +0300, Adrian Hunter wrote:
> You can boot with notsc and perf still seems to work
> e.g.
> 
> $ dmesg | grep -i tsc
> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0+ root=UUID=f1b4c71a-15aa-41a6-8898-cdde49966bce ro ignore_loglevel earlyprintk=ttyS0 console=ttyS0,115200n8 no_console_suspend notsc=1
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.11.0+ root=UUID=f1b4c71a-15aa-41a6-8898-cdde49966bce ro ignore_loglevel earlyprintk=ttyS0 console=ttyS0,115200n8 no_console_suspend notsc=1
> [    0.000000] tsc: Kernel compiled with CONFIG_X86_TSC, cannot disable TSC completely
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.004000] tsc: Detected 2593.932 MHz processor
> [    0.224000] TSC deadline timer enabled

Yeah, and we still use the TSC deadline timer too.. I think we should
seriously consider removing the notsc option. I really don't know what
its good for.

Thomas, Ingo, hpa?
