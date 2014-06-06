Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaFFB40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 21:56:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbaFFB4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 21:56:23 -0400
Date: Thu, 5 Jun 2014 21:56:10 -0400
From: Dave Jones <davej@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: ima_mmap_file returning 0 to userspace as mmap result.
Message-ID: <20140606015610.GA23041@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20140604233122.GA19838@redhat.com>
 <538FF4C4.5090300@gmail.com>
 <20140605155658.GA22673@redhat.com>
 <20140605162045.GA25474@redhat.com>
 <1402019369.5458.55.camel@dhcp-9-2-203-236.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402019369.5458.55.camel@dhcp-9-2-203-236.watson.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 09:49:29PM -0400, Mimi Zohar wrote:
 
 > >  >  > > There's no mention of this return value in the man page, so I dug
 > >  >  > > into the kernel code, and it appears that we do..
 > >  >  > > 
 > >  >  > > sys_mmap
 > >  >  > > vm_mmap_pgoff
 > >  >  > > security_mmap_file
 > >  >  > > ima_file_mmap <- returns 0 if not PROT_EXEC
 > >  >  > > 
 > >  >  > > and then the 0 gets propagated up as a retval all the way to userspace.
 > >  > 
 > >  > I just realised that this affects even kernels with CONFIG_IMA unset,
 > >  > because there we just do 'return 0' unconditionally.
 > >  > 
 > >  > Also, it appears that kernels with CONFIG_SECURITY unset will also
 > >  > return a zero for the same reason.
 > > 
 > > Hang on, I was misreading that whole security_mmap_file ret handling code.
 > > There's something else at work here.  I'll dig and get a reproducer.
 > 
 > According to security.h, it should return 0 if permission is granted.
 > If IMA is not enabled, it should also return 0.  What exactly is the
 > problem?

Still digging. I managed to get this to reproduce constantly last night,
but no luck today.  From re-reading the code though, I think IMA/lsm isn't
the problem.

	Dave

