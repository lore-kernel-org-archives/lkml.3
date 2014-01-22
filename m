Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaAVMBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 07:01:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:60796 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161AbaAVMBX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 07:01:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,699,1384329600"; 
   d="scan'208";a="462793164"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: RE: [PATCH v2 0/4] Intel MPX support
Thread-Topic: [PATCH v2 0/4] Intel MPX support
Thread-Index: AQHPF2iQ1cV6ZhmSakelbdnep6mdOZqQpCQw
Date: Wed, 22 Jan 2014 12:01:18 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE014EC163@SHSMSX102.ccr.corp.intel.com>
References: <1390382866-6361-1-git-send-email-qiaowei.ren@intel.com>
 <20140122115321.GA8281@gmail.com>
In-Reply-To: <20140122115321.GA8281@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ingo Molnar [mailto:mingo.kernel.org@gmail.com] On Behalf Of Ingo
> Molnar
> Sent: Wednesday, January 22, 2014 7:53 PM
> To: Ren, Qiaowei
> Cc: H. Peter Anvin; Thomas Gleixner; Ingo Molnar; x86@kernel.org;
> linux-kernel@vger.kernel.org; Peter Zijlstra
> Subject: Re: [PATCH v2 0/4] Intel MPX support
> 
> 
> * Qiaowei Ren <qiaowei.ren@intel.com> wrote:
> 
> > Changes since v1:
> >   * check to see if #BR occurred in userspace or kernel space.
> >   * use generic structure and macro as much as possible when
> >     decode mpx instructions.
> >
> > Qiaowei Ren (4):
> >   x86, mpx: add documentation on Intel MPX
> >   x86, mpx: hook #BR exception handler to allocate bound tables
> >   x86, mpx: add prctl commands PR_MPX_INIT, PR_MPX_RELEASE
> >   x86, mpx: extend siginfo structure to include bound violation
> >     information
> >
> >  Documentation/x86/intel_mpx.txt    |   76 +++++++
> >  arch/x86/Kconfig                   |    4 +
> >  arch/x86/include/asm/mpx.h         |   63 ++++++
> >  arch/x86/include/asm/processor.h   |   16 ++
> >  arch/x86/kernel/Makefile           |    1 +
> >  arch/x86/kernel/mpx.c              |  417
> ++++++++++++++++++++++++++++++++++++
> >  arch/x86/kernel/traps.c            |   61 +++++-
> >  include/uapi/asm-generic/siginfo.h |    9 +-
> >  include/uapi/linux/prctl.h         |    6 +
> >  kernel/signal.c                    |    4 +
> >  kernel/sys.c                       |   12 +
> >  11 files changed, 667 insertions(+), 2 deletions(-)  create mode
> > 100644 Documentation/x86/intel_mpx.txt  create mode 100644
> > arch/x86/include/asm/mpx.h  create mode 100644 arch/x86/kernel/mpx.c
> 
> Such a patch submission is absolutely inadequate!
> 
> Please outline:
> 
>   - a short summary of what the feature does
> 
>   - a short description of what hardware supports it today or will
>     support it in the future
> 
>   - a short description of whether the feature needs any
>     configuration from the user or it's entirely auto-enabled on
>     hardware that supports it.
> 
>   - a cost/benefit description to unrelated code: is this slowing down
>     anything else?
> 
>   - how does user-space compiler support stand, what's the expected
>     status there, etc.
> 
> Only a small fraction of that information can be found in
> Documentation/x86/intel_mpx.txt. in
> 
> I'm absolutely sick of these semi-anonymous patch submissions from Intel, so
> I'm NAK-ing it until it's communicated properly.
> 
Ok. I will add related content into this documentation.

Thanks,
Qiaowei
