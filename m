Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbaGCPH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:07:27 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:56143 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243AbaGCPHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:07:25 -0400
Message-ID: <53B571A3.7060004@de.ibm.com>
Date: Thu, 03 Jul 2014 17:07:15 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
CC: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH/RFC 0/4] perf kvm: add stat support for s390
References: <1404397747-20939-1-git-send-email-yarygin@linux.vnet.ibm.com>
In-Reply-To: <1404397747-20939-1-git-send-email-yarygin@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070315-1948-0000-0000-000000694194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/14 16:29, Alexander Yarygin wrote:
> Currently, a lot of code in buildin-kvm.c are x86 specific.
> In accordance with the proposal of David Ahern, we moved the code under
> #ifdefs from buildin-kvm.c into tools/perf/arch/*/kvm-stat.c. Architecture
> specific constants were added in arch/*/include/uapi/perf-kvm.h. Also,
> generic perf kvm stat structures were moved into the new file util/kvm-stat.h.
> 
> So, patches 1-3 reduce architecture dependency of buildin-kvm.c.
> Patch 4 implements s390 specific functions. Since some events on s390
> can have tree-like structure, the patch also adds functions to handle
> these events in generic code.
> 
> The patch set based on linux-3.16-rc1 including patches in
> "perf kvm: refactoring and small changes".
> 
> Link to the "perf kvm: refactoring and small changes" patch series:
> https://lkml.org/lkml/2014/7/3/461
> Link to the previous thread: https://lkml.org/lkml/2014/4/25/331
> 
> Alexander Yarygin (4):
>   perf kvm: Use defines of kvm events
>   perf kvm: Move arch specific code into arch/
>   perf kvm: Add skip_event() for --duration option
>   perf kvm: Add stat support on s390
> 
>  arch/s390/include/uapi/asm/Kbuild     |    1 +
>  arch/s390/include/uapi/asm/kvm_perf.h |   25 +++
>  arch/x86/include/uapi/asm/Kbuild      |    1 +
>  arch/x86/include/uapi/asm/kvm_perf.h  |   16 ++
>  tools/perf/Documentation/perf-kvm.txt |   10 +-
>  tools/perf/MANIFEST                   |    3 +
>  tools/perf/Makefile.perf              |    1 +
>  tools/perf/arch/s390/Makefile         |    2 +
>  tools/perf/arch/s390/util/kvm-stat.c  |  105 +++++++++
>  tools/perf/arch/x86/Makefile          |    1 +
>  tools/perf/arch/x86/util/kvm-stat.c   |  156 ++++++++++++++
>  tools/perf/builtin-kvm.c              |  384 +++++++++------------------------
>  tools/perf/util/kvm-stat.h            |  140 ++++++++++++
>  13 files changed, 561 insertions(+), 284 deletions(-)
>  create mode 100644 arch/s390/include/uapi/asm/kvm_perf.h
>  create mode 100644 arch/x86/include/uapi/asm/kvm_perf.h
>  create mode 100644 tools/perf/arch/s390/util/kvm-stat.c
>  create mode 100644 tools/perf/arch/x86/util/kvm-stat.c
>  create mode 100644 tools/perf/util/kvm-stat.h
> 
> --
> 1.7.9.5


CC Paolo,

All patches, look sane and
Acked-by; Christian Borntraeger <borntraeger@de.ibm.com>

Christian


