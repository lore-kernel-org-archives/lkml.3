Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaEFRB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:01:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46575 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbaEFRBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:01:54 -0400
Date: Tue, 6 May 2014 18:00:39 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 3/3] perf tools: Add libdw DWARF post unwind support for
 ARM64
Message-ID: <20140506170039.GB13677@arm.com>
References: <1399391733-11927-1-git-send-email-jean.pihet@linaro.org>
 <1399391733-11927-4-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399391733-11927-4-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Tue, May 06, 2014 at 04:55:33PM +0100, Jean Pihet wrote:
> Adding libdw DWARF post unwind support, which is part
> of elfutils-devel/libdw-dev package from version 0.158.
> 
> Note: the libdw code needs some support for dwarf unwinding
> on ARM64, this code is submitted seperately on the elfutils
> ML.
> 
> The new code is contained in unwin-libdw.c object, and
> implements unwind__get_entries unwind interface function.

Are you planning to implement support for 32-bit ARM too? If so, we'll need
compat handling here again (your favourite!).

> +bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg)
> +{
> +	struct unwind_info *ui = arg;
> +	struct regs_dump *user_regs = &ui->sample->user_regs;
> +	Dwarf_Word dwarf_regs[PERF_REG_ARM64_MAX];

Shouldn't this be PERF_REG_ARM64_MAX - 1?

Will
