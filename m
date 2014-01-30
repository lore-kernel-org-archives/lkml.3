Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaA3I7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 03:59:52 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:49192 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaA3I7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 03:59:51 -0500
Date: Thu, 30 Jan 2014 09:59:40 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 1/9] perf tools: Fix symbol annotation for relocated
 kernel
Message-ID: <20140130085940.GA2643@gmail.com>
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com>
 <1391004884-10334-2-git-send-email-adrian.hunter@intel.com>
 <20140129185747.GE3998@ghostprotocols.net>
 <52E9FD31.108@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E9FD31.108@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Hunter <adrian.hunter@intel.com> wrote:

> On 29/01/14 20:57, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Jan 29, 2014 at 04:14:36PM +0200, Adrian Hunter escreveu:
> >> Kernel maps map memory addresses to file offsets.
> >> For symbol annotation, objdump needs the object VMA
> >> addresses.  For an unrelocated kernel, that is the
> >> same as the memory address.
> >>
> >> The addresses passed to objdump for symbol annotation
> >> did not take into account kernel relocation.  This
> >> patch fixes that.
> > 
> > Question: To fix the problem reported by Linus, i.e. the very minimal
> > fix, we only need this patch, right?
> 
> Yes but the other fixes are needed too.

So, for the specific case of kernel address layout randomization, how 
does this fix Linus's bug with KASLR enabled? How does the code 
recover the random, runtime offset of the relocated kernel, which 
varies from boot to boot?

Thanks,

	Ingo
