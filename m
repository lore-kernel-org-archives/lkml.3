Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaFFBtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 21:49:35 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56641 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaFFBte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 21:49:34 -0400
Message-ID: <1402019369.5458.55.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: ima_mmap_file returning 0 to userspace as mmap result.
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 05 Jun 2014 21:49:29 -0400
In-Reply-To: <20140605162045.GA25474@redhat.com>
References: <20140604233122.GA19838@redhat.com> <538FF4C4.5090300@gmail.com>
	 <20140605155658.GA22673@redhat.com> <20140605162045.GA25474@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060601-0928-0000-0000-00000273A9D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-05 at 12:20 -0400, Dave Jones wrote: 
> On Thu, Jun 05, 2014 at 11:56:58AM -0400, Dave Jones wrote:
>  > On Thu, Jun 05, 2014 at 06:40:36AM +0200, Michael Kerrisk (man-pages) wrote:
>  >  > On 06/05/2014 01:31 AM, Dave Jones wrote:
>  >  > > I just noticed that trinity was freaking out in places when mmap was
>  >  > > returning zero.  This surprised me, because I had the mmap_min_addr
>  >  > > sysctl set to 64k, so it wasn't a MAP_FIXED mapping that did it.
>  >  > > 
>  >  > > There's no mention of this return value in the man page, so I dug
>  >  > > into the kernel code, and it appears that we do..
>  >  > > 
>  >  > > sys_mmap
>  >  > > vm_mmap_pgoff
>  >  > > security_mmap_file
>  >  > > ima_file_mmap <- returns 0 if not PROT_EXEC
>  >  > > 
>  >  > > and then the 0 gets propagated up as a retval all the way to userspace.
>  > 
>  > I just realised that this affects even kernels with CONFIG_IMA unset,
>  > because there we just do 'return 0' unconditionally.
>  > 
>  > Also, it appears that kernels with CONFIG_SECURITY unset will also
>  > return a zero for the same reason.
> 
> Hang on, I was misreading that whole security_mmap_file ret handling code.
> There's something else at work here.  I'll dig and get a reproducer.

According to security.h, it should return 0 if permission is granted.
If IMA is not enabled, it should also return 0.  What exactly is the
problem?

thanks,

Mimi

