Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaJ0UhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:37:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:40536 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaJ0UhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:37:08 -0400
Date: Mon, 27 Oct 2014 21:36:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Ren, Qiaowei" <qiaowei.ren@intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Subject: RE: [PATCH v9 09/12] x86, mpx: decode MPX instruction to get bound
 violation information
In-Reply-To: <9E0BE1322F2F2246BD820DA9FC397ADE0180ED16@shsmsx102.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.11.1410272135420.5308@nanos>
References: <1413088915-13428-1-git-send-email-qiaowei.ren@intel.com> <1413088915-13428-10-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.11.1410241408360.5308@nanos> <9E0BE1322F2F2246BD820DA9FC397ADE0180ED16@shsmsx102.ccr.corp.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Ren, Qiaowei wrote:
> On 2014-10-24, Thomas Gleixner wrote:
> > On Sun, 12 Oct 2014, Qiaowei Ren wrote:
> > 
> >> This patch sets bound violation fields of siginfo struct in #BR
> >> exception handler by decoding the user instruction and constructing
> >> the faulting pointer.
> >> 
> >> This patch does't use the generic decoder, and implements a limited
> >> special-purpose decoder to decode MPX instructions, simply because
> >> the generic decoder is very heavyweight not just in terms of
> >> performance but in terms of interface -- because it has to.
> > 
> > My question still stands why using the existing decoder is an issue.
> > Performance is a complete non issue in case of a bounds violation and
> > the interface argument is just silly, really.
> > 
> 
> As hpa said, we only need to decode several mpx instructions
> including BNDCL/BNDCU, and general decoder looks like a little
> heavy. Peter, what do you think about it?

You're repeating yourself. Care to read the discussion about this from
the last round of review again?

Thanks,

	tglx
