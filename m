Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3FJNs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:48:29 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:34734 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab3FJNs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:48:28 -0400
Date: Mon, 10 Jun 2013 15:48:17 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: HATAYAMA Daisuke <d.hatayama@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v5 2/5] s390/vmcore: Use ELF header in new memory
 feature
Message-ID: <20130610154817.3275672f@holzheu>
In-Reply-To: <CABOkKT13E-nkhu1j06OPqR2dMiK6WbTMp2rPj4mzom_+uDBziQ@mail.gmail.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1370624161-2298-3-git-send-email-holzheu@linux.vnet.ibm.com>
	<CABOkKT13E-nkhu1j06OPqR2dMiK6WbTMp2rPj4mzom_+uDBziQ@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061013-3548-0000-0000-000005A225C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jun 2013 22:36:57 +0900
HATAYAMA Daisuke <d.hatayama@gmail.com> wrote:

> > -static int setup_kdump_elfcorehdr(void)
> > +void elfcorehdr_free(void)
> >  {
> > -       size_t elfcorebuf_sz;
> > -       char *elfcorebuf;
> > -
> > -       if (!OLDMEM_BASE || is_kdump_kernel())
> > -               return -EINVAL;
> > -       s390_elf_corehdr_create(&elfcorebuf, &elfcorebuf_sz);
> > -       elfcorehdr_addr = (unsigned long long) elfcorebuf;
> > -       elfcorehdr_size = elfcorebuf_sz;
> > -       return 0;
> > +       if (!elfcorehdr_newmem)
> > +               return;
> > +       vfree(elfcorehdr_newmem);  
> 
> kfree is correct here?

You are right, I fixed that!

Thanks!
Michael

