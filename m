Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaKCWyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 17:54:15 -0500
Received: from www.linutronix.de ([62.245.132.108]:55857 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaKCWyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 17:54:14 -0500
Date: Mon, 3 Nov 2014 23:53:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Toshi Kani <toshi.kani@hp.com>
cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "stefan.bader@canonical.com" <stefan.bader@canonical.com>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "hmh@hmh.eng.br" <hmh@hmh.eng.br>,
        "yigal@plexistor.com" <yigal@plexistor.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4 4/7] x86, mm, pat: Add pgprot_writethrough() for WT
In-Reply-To: <1415052905.10958.39.camel@misato.fc.hp.com>
Message-ID: <alpine.DEB.2.11.1411032352161.5308@nanos>
References: <1414450545-14028-1-git-send-email-toshi.kani@hp.com>  <1414450545-14028-5-git-send-email-toshi.kani@hp.com>  <94D0CD8314A33A4D9D801C0FE68B4029593578ED@G9W0745.americas.hpqcorp.net> <1415052905.10958.39.camel@misato.fc.hp.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Nov 2014, Toshi Kani wrote:
> On Mon, 2014-11-03 at 22:10 +0000, Elliott, Robert (Server Storage)
> wrote:
>  :
> > > Subject: [PATCH v4 4/7] x86, mm, pat: Add pgprot_writethrough() for
> > > WT
> > > 
> > > This patch adds pgprot_writethrough() for setting WT to a given
> > > pgprot_t.
> > > 
> > > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > > Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ...
> > > diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> > > index a214f5a..a0264d3 100644
> > > --- a/arch/x86/mm/pat.c
> > > +++ b/arch/x86/mm/pat.c
> > > @@ -896,6 +896,16 @@ pgprot_t pgprot_writecombine(pgprot_t prot)
> > >  }
> > >  EXPORT_SYMBOL_GPL(pgprot_writecombine);
> > > 
> > > +pgprot_t pgprot_writethrough(pgprot_t prot)
> > > +{
> > > +	if (pat_enabled)
> > > +		return __pgprot(pgprot_val(prot) |
> > > +				cachemode2protval(_PAGE_CACHE_MODE_WT));
> > > +	else
> > > +		return pgprot_noncached(prot);
> > > +}
> > > +EXPORT_SYMBOL_GPL(pgprot_writethrough);
> > ...
> > 
> > Would you be willing to use EXPORT_SYMBOL for the new 
> > pgprot_writethrough function to provide more flexibility
> > for modules to utilize the new feature?  In x86/mm, 18 of 60
> > current exports are GPL and 42 are not GPL.
> 
> I simply used EXPORT_SYMBOL_GPL() since pgprot_writecombine() used
> it. :-)  This interface is intended to be used along with
> remap_pfn_range() and ioremap_prot(), which are both exported with
> EXPORT_SYMBOL().  So, it seems reasonable to export it with
> EXPORT_SYMBOL() as well.  I will make this change.

NAK.

This is new functionality and we really have no reason to give the GPL
circumventors access to it.

Thanks,

	tglx
	
