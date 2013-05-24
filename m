Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab3EXRGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:06:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756996Ab3EXRGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:06:00 -0400
Date: Fri, 24 May 2013 13:05:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/2] kdump/mmap: Fix mmap of /proc/vmcore for s390
Message-ID: <20130524170507.GG18218@redhat.com>
References: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com>
 <20130524143644.GD18218@redhat.com>
 <20130524170626.2ac06efe@holzheu>
 <20130524152849.GF18218@redhat.com>
 <20130524184653.52d75b5f@holzheu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524184653.52d75b5f@holzheu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 06:46:53PM +0200, Michael Holzheu wrote:
> On Fri, 24 May 2013 11:28:49 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > On Fri, May 24, 2013 at 05:06:26PM +0200, Michael Holzheu wrote:
> 
> [snip] 
> 
> > As /proc/vmcore is the most used and useful interface, I prefer that
> > we swap memory and put that info in elf headers. For /dev/oldme, I
> > don't mind if we leave it as it is. If somebody really cares, then
> > I guess we need to write a new command line option which /dev/mem
> > can parse and which tells it about swaps so that /dev/oldmem can
> > map things correctly. (This is better than hardcoding things).
> 
> Besides of the potential /dev/oldmem issue, I still do not understand
> the option of doing the swap in the elf header. Looks like I missed
> here a fundamental design point of kdump :(
> 
> Is that done by specifying different virtual and physical addresses in
> the ELF header?

Nope. We keep the virtual to physical address mapping same. We just modify
the p_offset in PT_LOAD elf header to represent where actually the
memory is present physically. And when /proc/vmcore reads the data, it
reads it from p_offset.

IOW, p_offset and p_paddr will be different for swapped memory but 
should be same for memory which has not been swapped.

Thanks
Vivek
