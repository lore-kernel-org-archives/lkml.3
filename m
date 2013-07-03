Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab3GCH7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 03:59:23 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:58726 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab3GCH7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 03:59:21 -0400
Date: Wed, 3 Jul 2013 09:59:13 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v6 2/5] s390/vmcore: Use ELF header in new memory
 feature
Message-ID: <20130703095913.6f6d145d@holzheu>
In-Reply-To: <20130702162322.GD22603@redhat.com>
References: <1372707159-10425-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1372707159-10425-3-git-send-email-holzheu@linux.vnet.ibm.com>
	<20130702162322.GD22603@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070307-5024-0000-0000-0000067C7EFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Jul 2013 12:23:23 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Mon, Jul 01, 2013 at 09:32:36PM +0200, Michael Holzheu wrote:
> 
> [..]
> > +ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos)
> > +{
> > +	void *src = (void *)(unsigned long)*ppos;
> > +
> > +	src = elfcorehdr_newmem ? src : src - OLDMEM_BASE;
> 
> Seriously, we need to get rid of all this OLDMEM_BASE logic in s390
> specific code. For regular kdump, it is no different than x86. Only
> special handling required for zfcpdump for HSA region.
> 
> Why do we need above. Is it to cover the case where elfcorehdr have
> been prepared by user space? Are elf headers initially stored in
> reserved region and then swapped. Why do we need to swap these or
> why kexec-tools could not take care of swapping it.

I know it is confusing. The "src - OLDMEM_BASE" term is currently
needed because of the swap issue that we have discussed already. We
load the ELF header into reserved memory
[OLDMEM_BASE, OLDMEM_BASE + OLDMEM_SIZE] that is swapped with
[0, OLDMEM_SIZE]. So the ELF header address has to be adjusted.

Thanks!
Michael

