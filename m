Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaJ1RFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:05:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:50847 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaJ1RFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:05:51 -0400
Date: Tue, 28 Oct 2014 18:05:34 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Juergen Gross <jgross@suse.com>
cc: hpa@zytor.com, x86@kernel.org, mingo@redhat.com,
        stefan.bader@canonical.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        ville.syrjala@linux.intel.com, david.vrabel@citrix.com,
        jbeulich@suse.com, toshi.kani@hp.com
Subject: Re: [PATCH V4 1/3] x86: Make page cache mode a real type
In-Reply-To: <1414392513-24645-2-git-send-email-jgross@suse.com>
Message-ID: <alpine.DEB.2.11.1410281536170.5308@nanos>
References: <1414392513-24645-1-git-send-email-jgross@suse.com> <1414392513-24645-2-git-send-email-jgross@suse.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Juergen Gross wrote:
> At the moment there are a lot of places that handle setting or getting
> the page cache mode by treating the pgprot bits equal to the cache mode.
> This is only true because there are a lot of assumptions about the setup
> of the PAT MSR. Otherwise the cache type needs to get translated into
> pgprot bits and vice versa.
> 
> This patch tries to prepare for that by introducing a separate type
> for the cache mode and adding functions to translate between those and
> pgprot values.
> 
> To avoid too much performance penalty the translation between cache mode
> and pgprot values is done via tables which contain the relevant
> information.  Write-back cache mode is hard-wired to be 0, all other
> modes are configurable via those tables. For large pages there are
> translation functions as the PAT bit is located at different positions
> in the ptes of 4k and large pages.

I'm fine with the approach itself. Though I wish you had split this
patch in several sanely to review pieces.

  - Introduce enums, helper functions etc. which basically reflect
    the state of today

  - Change the usage sites to use the enums and helpers

  - Convert the enum/helper implementation to the new scheme

  - Split out the printk change

  ...

Thanks,

	tglx
