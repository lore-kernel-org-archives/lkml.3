Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934479Ab3CSXga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:36:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:1246 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab3CSXg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:36:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,874,1355126400"; 
   d="scan'208";a="304804464"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "penguin-kernel@i-love.sakura.ne.jp" 
	<penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: RE: [PATCH] x86/microcode_intel_early.c: Get 32-bit physical
 address by __pa_nodebug()
Thread-Topic: [PATCH] x86/microcode_intel_early.c: Get 32-bit physical
 address by __pa_nodebug()
Thread-Index: AQHOJO57sAP2UmNvlkKKIjP7DJ1H6JiuGq6A//+PSyA=
Date: Tue, 19 Mar 2013 23:36:27 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C7122055946F9E@ORSMSX105.amr.corp.intel.com>
References: <1363705484-27645-1-git-send-email-fenghua.yu@intel.com>
 <CAE9FiQVhziaB9vEUNw-EBvA1Bfey=uMEw+CERuqSyPgU3qCJUA@mail.gmail.com>
In-Reply-To: <CAE9FiQVhziaB9vEUNw-EBvA1Bfey=uMEw+CERuqSyPgU3qCJUA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
> Yinghai Lu
> On Tue, Mar 19, 2013 at 8:04 AM, Fenghua Yu <fenghua.yu@intel.com>
> wrote:
> > From: Fenghua Yu <fenghua.yu@intel.com>
> >
> > In 32-bit, __pa_symbol() in CONFIG_DEBUG_VIRTUAL accesses kernel data
> (e.g.
> > max_low_pfn) that haven't been setup yet in such early boot phase. To
> fix the
> > issue, __pa_nodebug() replaces __pa_symbol() to get a global symbol's
> physical
> > address.
> 
> That explanation is not precise.
> 
> __phys_addr in 32bit when DEBUG_VIRTUAL is set, it does have check
>         /* max_low_pfn is set early, but not _that_ early */
>         if (max_low_pfn) {
>          ....
>         }
> the reason should be:
> in head_32.S, 32bit flat mode, you need to switch to phys addr to
> access
> global variable max_low_pfn.

Max_low_pfn is not set up yet at this point, but __pa_symbol() reads it
if CONFIG_DEBUG_VIRTUAL. There is no need to access max_low_pfn or any
other data that is not setup yet if CONFIG_DEBUG_VIRTUAL.

So I think the explanation is ok.

Thanks.

-Fenghua
