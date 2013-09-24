Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab3IXO7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 10:59:16 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:33050 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab3IXO7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 10:59:14 -0400
Date: Tue, 24 Sep 2013 16:59:11 +0200
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
Message-ID: <20130924145911.GA8494@gmail.com>
References: <20130923212459.544517569@asylum.americas.sgi.com>
 <20130924075212.GG28538@gmail.com>
 <524198FD.2090104@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <524198FD.2090104@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> On 9/24/2013 12:52 AM, Ingo Molnar wrote:
> > 
> > Hm, do you test-build your patches? 
> 
> Both build and test incessantly...
> 
> This series produces the following
> > annoying warning:
> > 
> >  arch/x86/platform/uv/uv_nmi.c: In function ‘uv_nmi_setup’:
> >  arch/x86/platform/uv/uv_nmi.c:664:2: warning: the address of ‘uv_nmi_cpu_mask’ will always evaluate as ‘true’ [-Waddress]
> 
> I didn't hit the above warning since I never tried building without 
> CONFIG_CPUMASK_OFFSTACK defined. [...]

Ok, that explains it!

> [...]  I wonder if uv_nmi.c should not be built if not on an enterprise 
> sized system?

I don't think so - the config variations help root out such bugs.

Thanks,

	Ingo
