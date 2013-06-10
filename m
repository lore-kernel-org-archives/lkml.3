Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab3FJNxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:53:32 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:42491 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3FJNxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:53:31 -0400
Date: Mon, 10 Jun 2013 15:53:25 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: HATAYAMA Daisuke <d.hatayama@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH v5 1/5] vmcore: Introduce ELF header in new memory
 feature
Message-ID: <20130610155325.5e75f243@holzheu>
In-Reply-To: <CABOkKT33diYR+7Nt9HdRxxqnb1KGkUz8YLTjGODsv2s5vj+3og@mail.gmail.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1370624161-2298-2-git-send-email-holzheu@linux.vnet.ibm.com>
	<CABOkKT33diYR+7Nt9HdRxxqnb1KGkUz8YLTjGODsv2s5vj+3og@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061013-2966-0000-0000-000007D6A0D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jun 2013 22:35:30 +0900
HATAYAMA Daisuke <d.hatayama@gmail.com> wrote:

> 2013/6/8 Michael Holzheu <holzheu@linux.vnet.ibm.com>:
> <cut>
> > @@ -935,10 +967,17 @@ static int __init vmcore_init(void)
> >  {
> >         int rc = 0;
> >
> > -       /* If elfcorehdr= has been passed in cmdline, then capture the dump.*/
> > -       if (!(is_vmcore_usable()))
> > -               return rc;
> > +       /*
> > +        * If elfcorehdr= has not been passed in cmdline, try to get the
> > +        * header from 2nd kernel, then capture the dump.
> > +        */
> > +       if (!(is_vmcore_usable())) {
> > +               rc = elfcorehdr_alloc();
> > +               if (rc)
> > +                       return rc;
> > +       }
> 
> Here you removed comment in the 1st path. Please keep it.

Perhaps something like the following:

/*
 * If elfcorehdr= has been passed in cmdline, then capture the dump.
 * Otherwise, try to get the header from the 2nd kernel.
 */

Michael

