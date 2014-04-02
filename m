Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbaDBP5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:57:09 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:51717 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665AbaDBP5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:57:07 -0400
Date: Wed, 2 Apr 2014 17:56:58 +0200
From: Greg Kurz <gkurz@linux.vnet.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [RFC PATCH] powerpc/le: enable RTAS events support
Message-ID: <20140402175658.1b4a8c4d@bahia.local>
In-Reply-To: <CAMuHMdXXELjK-t4k025uRE3QPsMiYR9KevtEnq_k32m-4g+fPg@mail.gmail.com>
References: <20140328073344.26823.32931.stgit@bahia.local>
	<53398379.8000203@linux.vnet.ibm.com>
	<CAMuHMdXXELjK-t4k025uRE3QPsMiYR9KevtEnq_k32m-4g+fPg@mail.gmail.com>
Organization: IBM
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
x-cbid: 14040215-0342-0000-0000-0000084F4D11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2014 12:26:32 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Mon, Mar 31, 2014 at 5:02 PM, Nathan Fontenot
> <nfont@linux.vnet.ibm.com> wrote:
> >  struct rtas_error_log {
> > -       unsigned long version:8;                /* Architectural version */
> > -       unsigned long severity:3;               /* Severity level of error */
> > -       unsigned long disposition:2;            /* Degree of recovery */
> > -       unsigned long extended:1;               /* extended log present? */
> > -       unsigned long /* reserved */ :2;        /* Reserved for future use */
> > -       unsigned long initiator:4;              /* Initiator of event */
> > -       unsigned long target:4;                 /* Target of failed operation */
> > -       unsigned long type:8;                   /* General event or error*/
> > -       unsigned long extended_log_length:32;   /* length in bytes */
> > -       unsigned char buffer[1];                /* Start of extended log */
> > +       /* Byte 0 */
> > +       uint8_t         version;                /* Architectural version */
> > +
> > +       /* Byte 1 */
> > +       uint8_t         severity;
> > +       /* XXXXXXXX
> > +        * XXX          3: Severity level of error
> > +        *    XX        2: Degree of recovery
> > +        *      X       1: Extended log present?
> > +        *       XX     2: Reserved
> > +        */
> > +
> > +       /* Byte 2 */
> > +       uint8_t         :8;
> > +       /* XXXXXXXX
> > +        * XXXX         4: Initiator of event
> > +        *     XXXX     4: Target of failed operation
> > +        */
> > +       uint8_t         type;                   /* General event or error*/
> > +       uint32_t        extended_log_length;    /* length in bytes */
> 
> Now the bitfields are gone, things like the above can become __be32,
> so we get extra type checking from sparse ("make C=1").
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 

I am reworking a patch in this direction.

Thanks.

--
Greg

> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


-- 
Gregory Kurz                                     kurzgreg@fr.ibm.com
                                                 gkurz@linux.vnet.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)562 165 496

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

