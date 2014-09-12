Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaILSmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:42:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:49600 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaILSmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:42:43 -0400
Date: Fri, 12 Sep 2014 20:42:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave.hansen@intel.com>
cc: Qiaowei Ren <qiaowei.ren@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 08/10] x86, mpx: add prctl commands PR_MPX_REGISTER,
 PR_MPX_UNREGISTER
In-Reply-To: <alpine.DEB.2.10.1409121812550.4178@nanos>
Message-ID: <alpine.DEB.2.10.1409122038590.4178@nanos>
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-9-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120020060.4178@nanos> <541239F1.2000508@intel.com> <alpine.DEB.2.10.1409120950260.4178@nanos>
 <alpine.DEB.2.10.1409121120440.4178@nanos> <5413050A.1090307@intel.com> <alpine.DEB.2.10.1409121812550.4178@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2014, Thomas Gleixner wrote:
> On Fri, 12 Sep 2014, Dave Hansen wrote:
> The proper solution to this problem is:
> 
>     do_bounds()
> 	bd_addr = get_bd_addr_from_xsave();
> 	bd_entry = bndstatus & ADDR_MASK:

Just for clarification. You CANNOT avoid the xsave here because it's
the only way to access BNDSTATUS according to the manual.

"The BNDCFGU and BNDSTATUS registers are accessible only with
 XSAVE/XRSTOR family of instructions"

So there is no point to cache BNDCFGU as you get it anyway when you
need to retrieve the invalid BD entry.

Thanks,

	tglx
