Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab3GRKkQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:40:16 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:47486 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab3GRKkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:40:12 -0400
Date: Thu, 18 Jul 2013 12:40:04 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v7 0/5] kdump: Allow ELF header creation in new kernel
Message-ID: <20130718124004.098b85f4@holzheu>
In-Reply-To: <20130717214207.GB27633@redhat.com>
References: <OF6010D9F0.5A45F2CF-ONC1257BAB.002B1F3E-C1257BAB.002B2812@de.ibm.com>
	<20130717180049.3b9c6ec8@holzheu>
	<20130717214207.GB27633@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071810-8372-0000-0000-0000069CC4D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jul 2013 17:42:07 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Jul 17, 2013 at 06:00:49PM +0200, Michael Holzheu wrote:

[snip]

> > But this is all additional effort now and would not be necessary if we
> > integrate this patch series in 3.11.
> > 
> > Perhaps we should let Andrew decide here.
> 
> Hi Michael,
> 
> Given the fact that andrew too prefers a fix to get s390 working at this
> stage can we modify s390 copy_from_oldmem() to be able to copy to 
> vmalloc() memory area.
> 
> For mmap(), let us disable it on s390. And rest of the cleanups w.r.t
> ELF header swap etc, let us now target that for 3.12.
> 
> Sounds reasonable?

Hi Vivek,

Ok this is not our preferred solution but we can't expect that life is
always easy ;-)

Our s390 kernel maintainer Martin Schwidefsky agreed to send the following
two patches upstream for 3.11:

 * s390/kdump: Disable mmap for s390
 * s390/kdump: Allow copy_oldmem_page() copy to virtual memory

@Andrew:

Would you then take the "ELF header in new memory" patch series for 3.12?

Regards,
Michael

