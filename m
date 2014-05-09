Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320AbaEIRDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 13:03:04 -0400
Received: from smtprelay0135.hostedemail.com ([216.40.44.135]:32926 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932286AbaEIRDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 13:03:02 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3167:3352:3622:3865:3867:3874:4321:5007:7652:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12114:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grass21_8e8fb306f3f13
X-Filterd-Recvd-Size: 2232
Message-ID: <1399654978.11258.17.camel@joe-AO725>
Subject: Re: [PATCH 2/2] x86: Fix typo in MSR_IA32_MISC_ENABLE_LIMIT_CPUID
 macro
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@suse.de>
Cc: Andres Freund <andres@anarazel.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andy Whitcroft <apw@canonical.com>
Date: Fri, 09 May 2014 10:02:58 -0700
In-Reply-To: <20140509103303.GC16058@pd.tnic>
References: <1399598957-7011-1-git-send-email-andres@anarazel.de>
	 <1399598957-7011-3-git-send-email-andres@anarazel.de>
	 <20140509075730.GB16058@pd.tnic> <20140509103303.GC16058@pd.tnic>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 12:33 +0200, Borislav Petkov wrote:
> On Fri, May 09, 2014 at 09:57:30AM +0200, Borislav Petkov wrote:
> > > diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
[]
> > > -#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID		(1ULL << MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT);
> > > +#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID		(1ULL << MSR_IA32_MISC_ENABLE_LIMIT_CPUID_BIT)
> 
> Btw, we should probably be catching typos like that with checkpatch.
> Here's an initial version for single-line macros:
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -3313,6 +3313,11 @@ sub process {
>  			}
>  		}
>  
> +		if ($line =~ /^\+\s*#\s*define\s.*;\s*$/) {
> +			WARN("TRAILING_SEMICOLON",
> +			     "Trailing semicolon at macro definition\n" . $herecurr);
> +		}
> +

Seems sensible.

I suggest moving the test next to the other macro
definition tests for things like unnecessary semicolon
around "do {... while (0)" around line 3800.

Extending the test to find multiline forms like

#define	foo	\
	bar;

would also be trivially done there.

