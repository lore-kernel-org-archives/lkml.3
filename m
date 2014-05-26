Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaEZUNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:13:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:48134 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbaEZUNw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:13:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="546792956"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH 0/15] x86/xsaves: Optimize xstate context switch by
 xsaves/xrstors
Thread-Topic: [PATCH 0/15] x86/xsaves: Optimize xstate context switch by
 xsaves/xrstors
Thread-Index: AQHPeRoAQsE9Wh4ybE6CVJeF4AW2IZtTSVWA
Date: Mon, 26 May 2014 20:13:50 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712205A605703@ORSMSX106.amr.corp.intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
 <538397F5.6010002@amacapital.net>
In-Reply-To: <538397F5.6010002@amacapital.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andy Lutomirski [mailto:luto@amacapital.net]
> On 05/26/2014 10:01 AM, Fenghua Yu wrote:
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > With ever growing extended state registers (xstate) on x86 processors,
> kernel
> > needs to cope with issue of growing memory space occupied by xstate.
> The xsave
> > area is holding more and more xstate registers, growing from legacy
> FP and
> > SSE to AVX, AVX2, AVX-512, MPX, and Intel PT.
> >
> > The recently introduced compacted format of xsave area saves xstates
> only
> > for enabled states. This patch set saves the xsave area space per
> process
> > in compacted format by xsaves/xrstors instructions.
> 
> Are we going to want to encourage userspace to do something like
> sticking vzeroupper right before each syscall to make any
> xsaves/xrestores faster?

This patch set allow compacted format in kernel and standard format
in user space. This works fine for both kernel and user application.

As said in the patch 9/15, there would be two issues for user applications
to use xsaves/xrstors: one is modified optimization doesn't work for
user applications and the other one is legacy applications don't
know compacted format of xsave area.

So I don't see we need xsaves/xrstors in user space. But I could be
wrong.

Thanks.

-Fenghua
