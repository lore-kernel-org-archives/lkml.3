Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab3EOIry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 04:47:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34708 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932098Ab3EOIrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 04:47:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,676,1363104000"; 
   d="scan'208";a="7275054"
Subject: Re: [PATCH] cpu remove CONFIG_INIT_ALL_POSSIBLE check
From: li guang <lig.fnst@cn.fujitsu.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
In-Reply-To: <51934744.9010803@linux.vnet.ibm.com>
References: <1368604214-23237-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <51934744.9010803@linux.vnet.ibm.com>
Date: Wed, 15 May 2013 16:46:10 +0800
Message-ID: <1368607570.5142.46.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/15 16:46:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/15 16:46:37,
	Serialize complete at 2013/05/15 16:46:37
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-05-15三的 13:58 +0530，Srivatsa S. Bhat写道：
> On 05/15/2013 01:20 PM, liguang wrote:
> > seems CONFIG_INIT_ALL_POSSIBLE is obsolete now.
> > 
> 
> Um? A simple grep showed me this:
> 
> arch/s390/Kconfig:      select INIT_ALL_POSSIBLE
> arch/m32r/Kconfig:      select INIT_ALL_POSSIBLE
> arch/parisc/Kconfig:    select INIT_ALL_POSSIBLE
> init/Kconfig:config INIT_ALL_POSSIBLE
> 

Oh, yes, 
I was fooled by a script which is not aiming to do this check.

Thanks!

> > Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> > ---
> >  kernel/cpu.c |    5 -----
> >  1 files changed, 0 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/cpu.c b/kernel/cpu.c
> > index cd166d3..2697d1a 100644
> > --- a/kernel/cpu.c
> > +++ b/kernel/cpu.c
> > @@ -662,12 +662,7 @@ EXPORT_SYMBOL_GPL(cpu_bit_bitmap);
> >  const DECLARE_BITMAP(cpu_all_bits, NR_CPUS) = CPU_BITS_ALL;
> >  EXPORT_SYMBOL(cpu_all_bits);
> > 
> > -#ifdef CONFIG_INIT_ALL_POSSIBLE
> > -static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
> > -	= CPU_BITS_ALL;
> > -#else
> >  static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
> > -#endif
> >  const struct cpumask *const cpu_possible_mask = to_cpumask(cpu_possible_bits);
> >  EXPORT_SYMBOL(cpu_possible_mask);
> > 
> 


