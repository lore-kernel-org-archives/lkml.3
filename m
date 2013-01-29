Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab3A2N7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:59:51 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33607 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756559Ab3A2N7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:59:49 -0500
Date: Tue, 29 Jan 2013 14:59:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org
Subject: Re: [PATCH v5 14/20] scripts/gdb: Add internal helper and
 convenience function to retrieve thread_info
Message-ID: <20130129135946.GG14302@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Jason Wessel <jason.wessel@windriver.com>,
	kgdb-bugreport@lists.sourceforge.net,
	Andi Kleen <andi@firstfloor.org>, Tom Tromey <tromey@redhat.com>,
	Ben Widawsky <ben@bwidawsk.net>, Tony Luck <tony.luck@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org
References: <cover.1359463075.git.jan.kiszka@siemens.com>
 <c4fb2b8d82932f2e86956bd0bd08caf15855b652.1359463075.git.jan.kiszka@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c4fb2b8d82932f2e86956bd0bd08caf15855b652.1359463075.git.jan.kiszka@siemens.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 01:37:57PM +0100, Jan Kiszka wrote:
> Add the internal helper get_thread_info that calculated the thread_info
> from a given task variable. Also export this service as a convenience
> function.
> 
> Note: ia64 version is untested.
> 
> CC: Tony Luck <tony.luck@intel.com>
> CC: Fenghua Yu <fenghua.yu@intel.com>
> CC: linux-ia64@vger.kernel.org
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---

[ … ]

> +class LxThreadInfoFunc (gdb.Function):
> +	# Calculate Linux thread_info from task variable.
> +	__doc__ = "Calculate Linux thread_info from task variable.\n" \
> +		  "\n" \
> +		  "$lx_thread_info(TASK): Given TASK, return the corresponding thread_info\n" \
> +		  "variable."
> +
> +	def __init__(self):
> +		super(LxThreadInfoFunc, self).__init__("lx_thread_info")
> +
> +	def invoke(self, task):
> +		return get_thread_info(task)
> +
> +LxThreadInfoFunc()

Nice, you can plug commands into one-another:

(gdb) p $lx_thread_info($lx_current())
$12 = {task = 0xffffffff81a14440, exec_domain = 0xffffffff81a21e00, flags = 0, status = 0, cpu = 0, 
  preempt_count = 1, addr_limit = {seg = 18446744073709551615}, restart_block = {
    fn = 0xffffffff81054cd0 <do_no_restart_syscall>, {futex = {uaddr = 0x0, val = 0, flags = 0, bitset = 0, 
        time = 0, uaddr2 = 0x0}, nanosleep = {clockid = 0, rmtp = 0x0, compat_rmtp = 0x0, expires = 0}, 
      poll = {ufds = 0x0, nfds = 0, has_timeout = 0, tv_sec = 0, tv_nsec = 0}}}, sysenter_return = 0x0, 
  sig_on_uaccess_error = 0, uaccess_err = 0}

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
