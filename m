Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbaAZLhT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 06:37:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:61680 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbaAZLhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 06:37:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,723,1384329600"; 
   d="scan'208";a="472602230"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: Ingo Molnar <mingo@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: RE: [PATCH v3 3/4] x86, mpx: add prctl commands PR_MPX_INIT,
 PR_MPX_RELEASE
Thread-Topic: [PATCH v3 3/4] x86, mpx: add prctl commands PR_MPX_INIT,
 PR_MPX_RELEASE
Thread-Index: AQHPGjnO5MG2nTCtrEa+syIX3GXcKpqWJM+AgACGcwD//35+AIAAtKEA
Date: Sun, 26 Jan 2014 11:37:12 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE014F225B@SHSMSX102.ccr.corp.intel.com>
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com>
 <1390727338-20487-4-git-send-email-qiaowei.ren@intel.com>
 <20140126082201.GB28831@gmail.com> <52E4C5F2.8070707@intel.com>
 <20140126083942.GB29339@gmail.com>
In-Reply-To: <20140126083942.GB29339@gmail.com>
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
> From: linux-kernel-owner@vger.kernel.org
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Ingo Molnar
> Sent: Sunday, January 26, 2014 4:40 PM
> To: Ren, Qiaowei
> Cc: H. Peter Anvin; Thomas Gleixner; Ingo Molnar; x86@kernel.org;
> linux-kernel@vger.kernel.org; Peter Zijlstra
> Subject: Re: [PATCH v3 3/4] x86, mpx: add prctl commands PR_MPX_INIT,
> PR_MPX_RELEASE
> 
> 
> * Ren Qiaowei <qiaowei.ren@intel.com> wrote:
> 
> > On 01/26/2014 04:22 PM, Ingo Molnar wrote:
> > >
> > >* Qiaowei Ren <qiaowei.ren@intel.com> wrote:
> > >
> > >>This patch adds the PR_MPX_INIT and PR_MPX_RELEASE prctl() commands
> > >>on the x86 platform. These commands can be used to init and release
> > >>MPX related resource.
> > >>
> > >>A MMU notifier will be registered during PR_MPX_INIT command
> > >>execution. So the bound tables can be automatically deallocated when
> > >>one memory area is unmapped.
> > >>
> > >>Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
> > >>---
> > >>  arch/x86/Kconfig                 |    4 ++
> > >>  arch/x86/include/asm/mpx.h       |    9 ++++
> > >>  arch/x86/include/asm/processor.h |   16 +++++++
> > >>  arch/x86/kernel/mpx.c            |   84
> ++++++++++++++++++++++++++++++++++++++
> > >>  include/uapi/linux/prctl.h       |    6 +++
> > >>  kernel/sys.c                     |   12 +++++
> > >>  6 files changed, 131 insertions(+), 0 deletions(-)
> > >
> > > Hm. What is the expected typical frequency of these syscalls for a
> > > larger application like a web browser? Only once per startup
> > > typically, or will they be called more frequently?
> >
> > It will be only once per startup.
> 
> In that case it would be more efficient to make this part of the binary execution
> environment so that exec() sets it up automatically, not a separate prctl()
> syscall.
> 
Sorry, I guess what I said is not accurate. Normally it will be only once per startup. But user application maybe only partly want to use MPX, e.g. only one thread of process. For those cases, user application need to enable MPX for specific part of the code. So it is not enough to set it up automatically.

Thanks,
Qiaowei
