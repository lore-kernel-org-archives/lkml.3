Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaEBJQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaEBJQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:16:48 -0400
Date: Fri, 2 May 2014 11:16:38 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH/RFC 00/11] perf/s390/kvm: trace events, perf kvm stat
Message-ID: <20140502091638.GA6327@krava.redhat.com>
References: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398417153-57347-1-git-send-email-borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 11:12:22AM +0200, Christian Borntraeger wrote:
> The goal of this series is to
> - enable perf kvm stat on s390
> - get rid of a perf warning "insn_to_mnemonic not found" when it tries to
>   decode s390 perf trace events

perf tools changes look good to me

> 
> Review feedback is welcome.

CC-ing David Ahern

jirka

> In addition, The patch set touches s390/kvm code and perf code.
> So any feedback on which tree to use for this series is also 
> welcome.
> 
> Christian
> 
> 
> Alexander Yarygin (11):
>   s390: add sie exit reasons tables
>   KVM: s390: Use trace tables from sie.h.
>   KVM: s390: decoder of SIE intercepted instructions
>   KVM: s390: Use intercept_insn decoder in trace event
>   perf kvm: Intoduce HAVE_KVM_STAT_SUPPORT flag
>   perf kvm: simplify of exit reasons tables definitions
>   perf kvm: Refactoring of cpu_isa_config()
>   perf kvm: allow for variable string sizes
>   perf kvm: use defines of kvm events
>   perf: allow to use cpuinfo on s390
>   perf kvm: add stat support on s390
> 
>  arch/s390/include/uapi/asm/kvm.h   |   7 +
>  arch/s390/include/uapi/asm/sie.h   | 245 ++++++++++++++++++++++++++++++++++
>  arch/s390/kvm/trace.h              |  39 +-----
>  arch/x86/include/uapi/asm/kvm.h    |   8 ++
>  tools/perf/MANIFEST                |   3 +
>  tools/perf/arch/s390/Makefile      |   2 +
>  tools/perf/arch/s390/util/header.c |  17 +++
>  tools/perf/arch/x86/Makefile       |   1 +
>  tools/perf/builtin-kvm.c           | 263 +++++++++++++++++++++++++++++--------
>  tools/perf/config/Makefile         |   4 +
>  tools/perf/perf.h                  |   1 +
>  11 files changed, 499 insertions(+), 91 deletions(-)
>  create mode 100644 arch/s390/include/uapi/asm/sie.h
>  create mode 100644 tools/perf/arch/s390/util/header.c
> 
> -- 
> 1.8.4.2
> 
