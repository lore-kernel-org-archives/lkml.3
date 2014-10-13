Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbaJMRXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 13:23:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbaJMRXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 13:23:19 -0400
Date: Mon, 13 Oct 2014 13:22:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Baoquan He <bhe@redhat.com>, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, ak@linux.intel.com, ebiederm@xmission.com,
        kexec@lists.infradead.org, whissi@whissi.de,
        kumagai-atsushi@mxc.nes.nec.co.jp, stable@vger.kernel.org
Subject: Re: [resend Patch v3 1/2] kaslr: check if kernel location is changed
Message-ID: <20141013172242.GB9777@redhat.com>
References: <1412060896-1902-1-git-send-email-bhe@redhat.com>
 <542B1EC1.8090502@zytor.com>
 <20141001135237.GA13689@redhat.com>
 <543553C7.9010906@zytor.com>
 <20141008192728.GA26517@redhat.com>
 <20141011031452.GB11560@dhcp-16-116.nay.redhat.com>
 <543907B5.7060001@zytor.com>
 <20141013125257.GB6466@redhat.com>
 <20141013151955.GA9777@redhat.com>
 <543BF304.9090708@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543BF304.9090708@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 08:43:00AM -0700, H. Peter Anvin wrote:
> On 10/13/2014 08:19 AM, Vivek Goyal wrote:
> >>>
> >>> This really shouldn't have happened this way on x86-64.  It has to happen
> >>> this way on i386, but I worry that this may be a serious misdesign in kaslr
> >>> on x86-64.  I'm also wondering if there is any other fallout of this?
> >>
> >> I agree. On x86_64, we should stick to previous design and this new
> >> logic of performing relocations does not sound very clean and makes
> >> things very confusing.
> >>
> >> I am wondering that why couldn't we simply adjust page tables in case of
> >> kaslr on x86_64, instead of performing relocations.
> > 
> > Well, IIUC, if virtual addresses are shifted w.r.t what virtual address
> > kernel was compiled for, then relocation will have to be done.
> > 
> > So question will be if physical address shift is enough for kaslr or
> > virtual address shift is necessary.
> > 
> 
> I would assume that without a virtual address shift kaslr is pretty darn
> pointless.  Without the physical address shift the 1:1 map can be used,
> and again, kaslr becomes pointless.  However, there is absolutely no
> reason why they should be coupled.  They can, in fact, be independently
> randomized.

Agreed. On x86_64, we should be able to randomize virtual address space
and physical address space independently. And in that case whole of
the physical memory should be available for a possible location for
kernel. (As opposed to a small limit (I guess 1GB) now)

Thanks
Vivek
