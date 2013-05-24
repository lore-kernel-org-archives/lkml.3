Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3EXPGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 11:06:36 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:35524 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab3EXPGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 11:06:34 -0400
Date: Fri, 24 May 2013 17:06:26 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH 0/2] kdump/mmap: Fix mmap of /proc/vmcore for s390
Message-ID: <20130524170626.2ac06efe@holzheu>
In-Reply-To: <20130524143644.GD18218@redhat.com>
References: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<20130524143644.GD18218@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052415-1948-0000-0000-0000053EFBDA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Fri, 24 May 2013 10:36:44 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

[snip]

> Sorry, I don't understand the problem. If we swapped low memory and
> crash reserved memory, that should have been taken care by prepared
> ELF headers so that we map the right pfns. In x86 we swap 640K of low
> memory with 640K of memory in reserved and we take care of this by
> preparing elf headers accordingly.
> 
> So why s390 can't do the same thing?

I am not sure if I understand this. Currently we create the ELF
header in a way that we have virtual=real. In the copy_oldmem_page() we
do the swap so that for the /proc/vmcore code it looks like contiguous
non-swapped memory.

One reason why I thought this was necessary was that /dev/oldmem
also uses the function and it should provide linear memory access like
it is on the live system with /dev/mem.

Is that implementation incorrect?

Best Regards,
Michael


