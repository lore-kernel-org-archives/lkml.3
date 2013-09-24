Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750792Ab3IXHwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 03:52:17 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:50308 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3IXHwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 03:52:16 -0400
Date: Tue, 24 Sep 2013 09:52:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] x86/UV/KDB/NMI: Updates for NMI/KDB handler for SGI
 UV
Message-ID: <20130924075212.GG28538@gmail.com>
References: <20130923212459.544517569@asylum.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130923212459.544517569@asylum.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hm, do you test-build your patches? This series produces the following 
annoying warning:

 arch/x86/platform/uv/uv_nmi.c: In function ‘uv_nmi_setup’:
 arch/x86/platform/uv/uv_nmi.c:664:2: warning: the address of ‘uv_nmi_cpu_mask’ will always evaluate as ‘true’ [-Waddress]

This:

        alloc_cpumask_var(&uv_nmi_cpu_mask, GFP_KERNEL);
        BUG_ON(!uv_nmi_cpu_mask);


the way to check for allocation failures is by checking the return value 
of alloc_cpumask_var():

	BUG_ON(!alloc_cpumask_var(&uv_nmi_cpu_mask, GFP_KERNEL));

I've fixed this in the patch.

Thanks,

	Ingo
