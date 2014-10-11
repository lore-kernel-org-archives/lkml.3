Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaJKDPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 23:15:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbaJKDPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 23:15:34 -0400
Date: Sat, 11 Oct 2014 11:14:52 +0800
From: Baoquan He <bhe@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        keescook@chromium.org, ak@linux.intel.com, ebiederm@xmission.com,
        kexec@lists.infradead.org, whissi@whissi.de,
        kumagai-atsushi@mxc.nes.nec.co.jp, stable@vger.kernel.org
Subject: Re: [resend Patch v3 1/2] kaslr: check if kernel location is changed
Message-ID: <20141011031452.GB11560@dhcp-16-116.nay.redhat.com>
References: <1412060896-1902-1-git-send-email-bhe@redhat.com>
 <542B1EC1.8090502@zytor.com>
 <20141001135237.GA13689@redhat.com>
 <543553C7.9010906@zytor.com>
 <20141008192728.GA26517@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008192728.GA26517@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/14 at 03:27pm, Vivek Goyal wrote:
> On Wed, Oct 08, 2014 at 08:09:59AM -0700, H. Peter Anvin wrote:
 
> > Sorry... this makes no sense.
> > 
> > For x86-64, there is no direct connection between the physical and
> > virtual address spaces that the kernel runs in...
> 
> I am sorry I did not understand this one. I thought that initial
> relocatable kernel implementaion did not have any direct connection
> between virtual and physical address. One could load kernel anywhere
> and kernel virtual address will not change and we will just adjust
> page tables to map virtual address to right physical address.
> 
> Now handle_relocation() stuff seems to introduce a close coupling
> between physical and virtual address. So if kernel shifts by 16MB
> in physical address space, then it will shift by equal amount
> in virtual address space. So there seems to be a direct connection
> between virtual and physical address space in this case.

Yeah, it's exactly as Vivek said.

Before kaslr was introduced, x86_64 kernel can be put anywhere, and
always _text is 0xffffffff81000000. Meanwhile phys_base contains the
offset between the compiled addr (namely 0x1000000) and kernel loaded
addr. After kaslr implementation was added, as long as kernel loaded
addr is different 0x1000000, it will call handle_relocations(). The
offset now is added onto each symbols including _text and phys_base
becomes 0.

It's clearly showing that by checking /proc/kallsyms and value of
phys_base.


Thanks
Baoquan
