Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaG2XHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:07:41 -0400
Received: from smtprelay0067.hostedemail.com ([216.40.44.67]:40450 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754313AbaG2XHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:07:39 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3167:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:4321:5007:7652:9040:9108:10004:10400:10848:11232:11658:11914:12296:12517:12519:12555:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trick38_25554d0e03008
X-Filterd-Recvd-Size: 2226
Message-ID: <1406675255.12100.22.camel@joe-AO725>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Borislav Petkov <bp@alien8.de>, Prarit Bhargava <prarit@redhat.com>,
        linux-kernel@vger.kernel.org, lszubowi@redhat.com,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org
Date: Tue, 29 Jul 2014 16:07:35 -0700
In-Reply-To: <alpine.DEB.2.02.1407291541480.20991@chino.kir.corp.google.com>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com>
	 <20140729222932.GA17481@pd.tnic> <53D82118.6090202@redhat.com>
	 <20140729223603.GC17241@pd.tnic>
	 <alpine.DEB.2.02.1407291541480.20991@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-29 at 15:42 -0700, David Rientjes wrote:
> On Wed, 30 Jul 2014, Borislav Petkov wrote:
> 
> > On Tue, Jul 29, 2014 at 06:32:56PM -0400, Prarit Bhargava wrote:
> > > and it was best to keep the code simple with a KiB.
> > 
> > You're missing the point - the output doesn't get simple with KiB. Read
> > the example I just gave you!
> > 
> > (13893632kiB) is actively *not* helping when one looks at it!
> > 
> 
> /proc/meminfo must be frustrating then, too.
> 
> If Prarit is going to implement this suggested reverse memparse() then it 
> would be nice to also have it as a generic function that others can use.

Maybe yet another vsprintf extension?

Maybe %pH<vartype> where vartype is one of [hh, h, u, ul, ull]
with something like
	u64 t1 = (u64)*(appropriate cast)vartype;
	u64 t2 = t1;
	int index = 0;
	while ((t1 >>= 10)) {
		index++;
		t2 >>= 10;
	}
	
to output the equivalent of
	%llu%s, t2, "bkmgtpezy"[index]
ala dump_pagetables


