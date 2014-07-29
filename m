Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbaG2WCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:02:54 -0400
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:36546 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751300AbaG2WCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:02:53 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3867:3868:4321:5007:7652:7904:10004:10400:10848:11026:11232:11473:11657:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: range18_35d7eaf9c675c
X-Filterd-Recvd-Size: 2094
Message-ID: <1406671368.12100.5.camel@joe-AO725>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org,
        lszubowi@redhat.com, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org
Date: Tue, 29 Jul 2014 15:02:48 -0700
In-Reply-To: <alpine.DEB.2.02.1407291327450.13073@chino.kir.corp.google.com>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com>
	 <alpine.DEB.2.02.1407291327450.13073@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-29 at 13:29 -0700, David Rientjes wrote:
> On Tue, 29 Jul 2014, Prarit Bhargava wrote:
> > diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
[]
> > @@ -384,10 +384,10 @@ static void __init print_efi_memmap(void)
> >  	     p < memmap.map_end;
> >  	     p += memmap.desc_size, i++) {
> >  		md = p;
> > -		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
> > +		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluKiB)\n",
> >  			i, md->type, md->attribute, md->phys_addr,
> >  			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
> > -			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
> > +			(md->num_pages << 2));
> >  	}
> >  #endif  /*  EFI_DEBUG  */
> >  }
> 
> If EFI_PAGE_SHIFT were to ever change from its hard-coded 12, then( this 
> would be wrong.  Any reason to not simply print EFI_PAGE_SIZE and 
> md->num_pages?

Or maybe ((u64)EFI_PAGE_SIZE * md->num_pages) >> 10


