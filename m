Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3EHP22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:28:28 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:49929 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3EHP20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:28:26 -0400
Date: Wed, 8 May 2013 17:28:20 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Jan Willeke <willeke@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: Re: [PATCH 0/4] kdump: Allow ELF header creation in new kernel
Message-ID: <20130508172820.77075d23@holzheu>
In-Reply-To: <20130507163701.GA14403@redhat.com>
References: <1367845799-29125-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<20130507163701.GA14403@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050815-0342-0000-0000-000004F83C05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

On Tue, 7 May 2013 12:37:01 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Mon, May 06, 2013 at 03:09:55PM +0200, Michael Holzheu wrote:
> > Hello Vivek,
> > 
> > For s390 we want to use /proc/vmcore for our SCSI stand-alone
> > dump (zfcpdump). We have support where the first HSA_SIZE bytes are
> > saved into a hypervisor owned memory area (HSA) before the kdump
> > kernel is booted. When the kdump kernel starts, it is restricted
> > to use only HSA_SIZE bytes.
> > 
> 
> Hi Michael,
> 
> Hatayama is changing /proc/vmcore interface to support mmap(). Can you
> please rebase your changes on top of those patches.
> 
> http://thread.gmane.org/gmane.linux.kernel/1477622

Fine, we will do that.
 
> Secondly, I think /proc/vmcore does not have to know whether elf
> headers are in old memory or new memory. Given that s390 is taking
> a deviation, so it now becomes an arch specific detail. Can't we
> just create few arch specific helper functions to retrieve and free
> elf headers.
> 
> - arch_get_crash_headers()
> 	- All arch except return elfcorehdr_add except s390.
> - arch_read_crash_header_data()
> 	- All arch just call into read_from_oldmem() except s390. We
>   	  can provide a generic implementation in /proc/vmcore.c so
> 	  all other arch can use that generic implementation.  Or
> 	  use symbol override trick.
> - arch_free_crash_headers()
> 	- All arch do nothing except s390 which can reclaim the memory
>  	  for elf headers prepared. Generic code has parsed/copied
> the headers by now.
> 
> What do you think? Above 3 calls should solve the problem and allow
> arch to handle elf headers differently. And generic implementation
> still keeps common logic for processing headers.

Ok, we will try that. There might be a problem that our ELF notes
content is also in the new kernel memory. But also for that there be a
solution.

Michael

