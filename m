Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbbAVLHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:07:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:59126 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbbAVLHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:07:19 -0500
Date: Thu, 22 Jan 2015 12:06:46 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Juergen Gross <jgross@suse.com>
cc: Steven Noonan <steven@uplinklabs.net>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        stefan.bader@canonical.com,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        ville.syrjala@linux.intel.com, David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <jbeulich@suse.com>, toshi.kani@hp.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, bhelgaas@google.com
Subject: Re: [PATCH V6 01/18] x86: Make page cache mode a real type
In-Reply-To: <54C0CDD8.2010205@suse.com>
Message-ID: <alpine.DEB.2.11.1501221202300.5526@nanos>
References: <1415019724-4317-1-git-send-email-jgross@suse.com> <1415019724-4317-2-git-send-email-jgross@suse.com> <CAKbGBLhzOPXqWuDwEoqnvC05c1cFgXrJMHFmeCjwUYcff==F3A@mail.gmail.com> <54C0CDD8.2010205@suse.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Juergen Gross wrote:
> On 01/22/2015 08:11 AM, Steven Noonan wrote:
> > I notice these two symbols are exported GPL-only. This breaks builds
> > of several out-of-tree non-GPL modules such as the NVIDIA driver, and
> > VMware modules, etc. What is the appropriate code path for proprietary
> > modules to use when setting page cache mode flags? Alternatively, is
> > it possible for these EXPORT_SYMBOL_GPLs to be changed to
> > EXPORT_SYMBOL?
> 
> I don't mind you sending a patch to change this. I won't object such a
> patch. OTOH this is more kind of a political question and I don't want
> to spend my time on arguing.

It's rather simple. If the new cache stuff replaces code which was
available under EXPORT_SYMBOL, we either need a compat export or make
the new exports non GPL.

Not that I like it, but that has been the policy so far. We only break
out of tree stuff if the export is broken or security relevant, like
we did with the init_mm export a few years ago.

Thanks,

	tglx
