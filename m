Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbbAWQNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:13:44 -0500
Received: from www.linutronix.de ([62.245.132.108]:37526 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161AbbAWQNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:13:40 -0500
Date: Fri, 23 Jan 2015 17:13:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 01/23] x86/apic: Avoid open coded x2apic detection
In-Reply-To: <alpine.DEB.2.11.1501221239040.5526@nanos>
Message-ID: <alpine.DEB.2.11.1501231711370.5526@nanos>
References: <20150115210458.625399149@linutronix.de> <20150115211702.285038186@linutronix.de> <20150116095927.GA18880@pd.tnic> <alpine.DEB.2.11.1501221239040.5526@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Thomas Gleixner wrote:
> On Fri, 16 Jan 2015, Borislav Petkov wrote:
> > 
> > #define x2apic_supported()      (cpu_has_x2apic)
> > 
> > which does the cpufeature test.
> > 
> > Can we agree on one interface only and simplify this a bit more?
> 
> I think I do that later on, but will make sure.

We can't do that some places want the cpu_has_x2apic check even when
X2APIC=n. x2apic_supported() is compiled to 0 when X2APIC=n.

Thanks,

	tglx

